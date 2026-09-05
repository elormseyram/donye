// src/services/mqtt.service.js
// Connects to the MQTT broker and:
//   1. Subscribes to all bike telemetry and location topics
//   2. Saves incoming data to Supabase automatically
//   3. Listens for alert conditions and creates alerts
//
// Topics subscribed:
//   donye/+/telemetry   ← live sensor data from bike
//   donye/+/location    ← live GPS from bike
//   donye/+/status      ← bike online/offline status
//
// Topics published:
//   donye/{bikeId}/commands  ← lock/unlock/honk etc from Flutter

import mqtt from 'mqtt';
import { supabaseAdmin } from '../config/supabase.js';
import logger from '../config/logger.js';

const BROKER_URL    = `mqtt://${process.env.MQTT_BROKER_HOST || 'broker.hivemq.com'}`;
const BROKER_PORT   = parseInt(process.env.MQTT_BROKER_PORT || '1883', 10);
const TOPIC_PREFIX  = process.env.MQTT_TOPIC_PREFIX || 'donye';

// Alert thresholds
const THRESHOLDS = {
  batteryLow:     20,    // % — warn below this
  batteryCritical: 10,   // % — critical below this
  tempHigh:       45,    // °C — warn above this
  tempCritical:   60,    // °C — critical above this
};

let mqttClient = null;

// ── Connect to broker ─────────────────────────────────────────────────────

export const connectMQTT = () => {
  logger.info(`Connecting to MQTT broker at ${BROKER_URL}:${BROKER_PORT}`);

  mqttClient = mqtt.connect(BROKER_URL, {
    port:              BROKER_PORT,
    clientId:          `donye-backend-${Date.now()}`,
    clean:             true,
    reconnectPeriod:   5000,   // retry every 5 seconds if disconnected
    connectTimeout:    10000,
  });

  mqttClient.on('connect', () => {
    logger.info('✅ MQTT broker connected');

    // Subscribe to all bike topics using wildcard +
    const topics = [
      `${TOPIC_PREFIX}/+/telemetry`,
      `${TOPIC_PREFIX}/+/location`,
      `${TOPIC_PREFIX}/+/status`,
    ];

    topics.forEach((topic) => {
      mqttClient.subscribe(topic, { qos: 1 }, (err) => {
        if (err) {
          logger.error(`Failed to subscribe to ${topic}:`, err);
        } else {
          logger.info(`Subscribed to: ${topic}`);
        }
      });
    });
  });

  mqttClient.on('message', async (topic, payload) => {
    try {
      const message = JSON.parse(payload.toString());
      await handleMessage(topic, message);
    } catch (err) {
      logger.error(`Failed to process MQTT message on ${topic}:`, err);
    }
  });

  mqttClient.on('error', (err) => {
    logger.error('MQTT error:', err.message);
  });

  mqttClient.on('reconnect', () => {
    logger.info('MQTT reconnecting...');
  });

  mqttClient.on('disconnect', () => {
    logger.warn('MQTT disconnected');
  });

  mqttClient.on('offline', () => {
    logger.warn('MQTT client offline');
  });
};

// ── Route incoming messages ───────────────────────────────────────────────

const handleMessage = async (topic, message) => {
  // Extract topic type: donye/BIKE001/telemetry → ['donye', 'BIKE001', 'telemetry']
  const parts    = topic.split('/');
  const bikeId   = parts[1];
  const topicType = parts[2];

  switch (topicType) {
    case 'telemetry':
      await handleTelemetry(bikeId, message);
      break;
    case 'location':
      await handleLocation(bikeId, message);
      break;
    case 'status':
      await handleStatus(bikeId, message);
      break;
    default:
      logger.warn(`Unknown topic type: ${topicType}`);
  }
};

// ── Handle telemetry data ─────────────────────────────────────────────────

const handleTelemetry = async (bikeId, data) => {
  logger.debug(`Telemetry from bike ${bikeId}: speed=${data.speedKmh}km/h battery=${data.batteryPercentage}%`);

  // Save to telemetry_logs table
  const { error } = await supabaseAdmin
    .from('telemetry_logs')
    .insert({
      bike_id:             bikeId,
      battery_percentage:  data.batteryPercentage,
      voltage_v:           data.voltageV,
      current_a:           data.currentA,
      speed_kmh:           data.speedKmh,
      temperature_celsius: data.temperatureCelsius,
      odometer:            data.odometer,
      motor_rpm:           data.motorRpm,
      status:              data.status ?? 'normal',
      timestamp:           data.timestamp ?? new Date().toISOString(),
    });

  if (error) {
    logger.error(`Failed to save telemetry for bike ${bikeId}:`, error.message);
    return;
  }

  // Check alert conditions
  await checkAlerts(bikeId, data);
};

// ── Handle GPS location ───────────────────────────────────────────────────

const handleLocation = async (bikeId, data) => {
  logger.debug(`Location from bike ${bikeId}: lat=${data.latitude} lng=${data.longitude}`);

  const { error } = await supabaseAdmin
    .from('ride_locations')
    .insert({
      bike_id:         bikeId,
      latitude:        data.latitude,
      longitude:       data.longitude,
      heading_degrees: data.headingDegrees ?? 0,
      speed_kmh:       data.speedKmh ?? 0,
      accuracy_m:      data.accuracyM ?? 0,
      timestamp:       data.timestamp ?? new Date().toISOString(),
    });

  if (error) {
    logger.error(`Failed to save location for bike ${bikeId}:`, error.message);
  }
};

// ── Handle bike online/offline status ────────────────────────────────────

const handleStatus = async (bikeId, data) => {
  const status = data.online ? 'active' : 'inactive';
  logger.info(`Bike ${bikeId} is now ${status}`);

  const { error } = await supabaseAdmin
    .from('bikes')
    .update({ status })
    .eq('id', bikeId);

  if (error) {
    logger.error(`Failed to update bike status for ${bikeId}:`, error.message);
  }

  // Create an alert if bike goes offline unexpectedly
  if (!data.online) {
    await createAlert(bikeId, {
      type:     'fault',
      severity: 'warning',
      title:    'Bike Disconnected',
      message:  `Bike ${bikeId} went offline at ${new Date().toISOString()}`,
    });
  }
};

// ── Check sensor readings and create alerts if needed ─────────────────────

const checkAlerts = async (bikeId, data) => {
  const alerts = [];

  // Battery alerts
  if (data.batteryPercentage <= THRESHOLDS.batteryCritical) {
    alerts.push({
      type:     'battery_low',
      severity: 'critical',
      title:    'Critical Battery',
      message:  `Battery at ${data.batteryPercentage.toFixed(1)}% — charge immediately`,
    });
  } else if (data.batteryPercentage <= THRESHOLDS.batteryLow) {
    alerts.push({
      type:     'battery_low',
      severity: 'warning',
      title:    'Low Battery',
      message:  `Battery at ${data.batteryPercentage.toFixed(1)}% — please charge soon`,
    });
  }

  // Temperature alerts
  if (data.temperatureCelsius >= THRESHOLDS.tempCritical) {
    alerts.push({
      type:     'overheat',
      severity: 'critical',
      title:    'Motor Overheating',
      message:  `Motor temperature at ${data.temperatureCelsius.toFixed(1)}°C — stop riding immediately`,
    });
  } else if (data.temperatureCelsius >= THRESHOLDS.tempHigh) {
    alerts.push({
      type:     'overheat',
      severity: 'warning',
      title:    'High Motor Temperature',
      message:  `Motor temperature at ${data.temperatureCelsius.toFixed(1)}°C — monitor closely`,
    });
  }

  // Create each alert — but only if no identical unresolved alert exists
  for (const alert of alerts) {
    await createAlertIfNotExists(bikeId, alert);
  }
};

// ── Create alert only if no duplicate exists ──────────────────────────────

const createAlertIfNotExists = async (bikeId, alertData) => {
  // Check if this alert type already exists and is unresolved
  const { data: existing } = await supabaseAdmin
    .from('alerts')
    .select('id')
    .eq('bike_id', bikeId)
    .eq('type', alertData.type)
    .eq('is_resolved', false)
    .limit(1);

  if (existing && existing.length > 0) return; // already exists

  await createAlert(bikeId, alertData);
};

const createAlert = async (bikeId, alertData) => {
  const { error } = await supabaseAdmin
    .from('alerts')
    .insert({
      bike_id:     bikeId,
      type:        alertData.type,
      severity:    alertData.severity,
      title:       alertData.title,
      message:     alertData.message,
      is_read:     false,
      is_resolved: false,
      created_at:  new Date().toISOString(),
    });

  if (error) {
    logger.error(`Failed to create alert for bike ${bikeId}:`, error.message);
  } else {
    logger.info(`Alert created for bike ${bikeId}: ${alertData.title}`);
  }
};

// ── Publish a command to a bike ───────────────────────────────────────────
// Called from bikeControl.service.js when Flutter sends a command

export const publishCommand = (bikeId, command) => {
  if (!mqttClient || !mqttClient.connected) {
    logger.warn('MQTT client not connected — cannot publish command');
    return false;
  }

  const topic   = `${TOPIC_PREFIX}/${bikeId}/commands`;
  const payload = JSON.stringify(command);

  mqttClient.publish(topic, payload, { qos: 1 }, (err) => {
    if (err) {
      logger.error(`Failed to publish command to ${topic}:`, err);
    } else {
      logger.info(`Command published to ${topic}: ${command.type}`);
    }
  });

  return true;
};

// ── Disconnect cleanly ────────────────────────────────────────────────────

export const disconnectMQTT = () => {
  if (mqttClient) {
    mqttClient.end(true);
    logger.info('MQTT client disconnected');
  }
};
