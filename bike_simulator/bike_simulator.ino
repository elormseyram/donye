#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <time.h>

const char* WIFI_SSID     = "Wokwi-GUEST";
const char* WIFI_PASSWORD = "";

const char* MQTT_HOST     = "73cfd07e62844f4e8e02c3114323bcb5.s1.eu.hivemq.cloud";
const int   MQTT_PORT     = 8883;
const char* MQTT_USER     = "hivemq.webclient.1780094588598";
const char* MQTT_PASS     = "5t*op;HrM<8!6N3LXgfC";

const char* BIKE_ID       = "dev-001";

char topicTelemetry[80];
char topicLocation[80];
char topicStatus[80];

WiFiClientSecure netClient;
PubSubClient mqtt(netClient);

struct SimState {
  double  lat          = 5.6037;
  double  lng          = -0.1870;
  double  heading      = 45.0;
  double  speedKmh     = 0.0;
  double  battery      = 95.0;
  double  voltage      = 48.6;
  double  current      = 0.0;
  double  temperature  = 28.0;
  double  odometer     = 1200.0;
  int     motorRpm     = 0;
  bool    moving       = false;
};

SimState sim;

String isoNow() {
  time_t now = time(nullptr);
  char buf[30];
  strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%S.000Z", gmtime(&now));
  return String(buf);
}

void connectWifi() {
  Serial.printf("Connecting to WiFi: %s\n", WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.printf("\nWiFi connected: %s\n", WiFi.localIP().toString().c_str());
  configTime(0, 0, "pool.ntp.org");
  delay(2000);
}

void connectMqtt() {
  netClient.setInsecure();
  mqtt.setServer(MQTT_HOST, MQTT_PORT);
  mqtt.setBufferSize(512);

  char clientId[40];
  snprintf(clientId, sizeof(clientId), "wokwi-bike-%s", BIKE_ID);

  while (!mqtt.connected()) {
    Serial.printf("Connecting to HiveMQ: %s\n", MQTT_HOST);
    if (mqtt.connect(clientId, MQTT_USER, MQTT_PASS)) {
      Serial.println("MQTT connected");
      StaticJsonDocument<64> status;
      status["bike_id"] = BIKE_ID;
      status["status"]  = "online";
      char buf[64];
      serializeJson(status, buf);
      mqtt.publish(topicStatus, buf, true);
    } else {
      Serial.printf("MQTT failed, rc=%d — retrying in 5s\n", mqtt.state());
      delay(5000);
    }
  }
}

void updateSim() {
  static unsigned long lastTick = 0;
  unsigned long now = millis();
  float dt = (now - lastTick) / 1000.0f;
  lastTick = now;

  static int phase = 0;
  static unsigned long phaseStart = 0;

  if (now - phaseStart > 15000) {
    phase = (phase + 1) % 4;
    phaseStart = now;
  }

  switch (phase) {
    case 0:
      sim.moving    = true;
      sim.speedKmh  = 22.0 + sin(now / 3000.0) * 6.0;
      sim.motorRpm  = (int)(sim.speedKmh * 18.5);
      sim.current   = 8.0 + sin(now / 4000.0) * 2.0;
      break;
    case 1:
      sim.moving    = true;
      sim.speedKmh  = 34.0 + cos(now / 2500.0) * 5.0;
      sim.motorRpm  = (int)(sim.speedKmh * 18.5);
      sim.current   = 12.0 + cos(now / 3500.0) * 3.0;
      break;
    case 2:
      sim.speedKmh  = max(0.0, sim.speedKmh - 3.0 * dt);
      sim.motorRpm  = (int)(sim.speedKmh * 18.5);
      sim.current   = sim.speedKmh > 1 ? 2.0 : 0.0;
      if (sim.speedKmh < 0.5) sim.moving = false;
      break;
    case 3:
      sim.moving    = false;
      sim.speedKmh  = 0.0;
      sim.motorRpm  = 0;
      sim.current   = 0.2;
      break;
  }

  if (sim.moving) {
    double radH = sim.heading * PI / 180.0;
    sim.lat      += cos(radH) * sim.speedKmh * dt / 111111.0;
    sim.lng      += sin(radH) * sim.speedKmh * dt / (111111.0 * cos(sim.lat * PI / 180.0));
    sim.heading  += (random(-5, 6)) * dt;
    if (sim.heading < 0)   sim.heading += 360;
    if (sim.heading > 360) sim.heading -= 360;
    sim.odometer += sim.speedKmh * dt / 3600.0;
  }

  double drainRate = (sim.current * sim.voltage) / (360.0 * 1000.0);
  sim.battery    = max(0.0, sim.battery - drainRate * dt);
  sim.voltage    = 42.0 + (sim.battery / 100.0) * 8.4;
  sim.temperature = 28.0 + (sim.current * 0.4) + sin(now / 10000.0) * 2.0;
}

void publishTelemetry() {
  StaticJsonDocument<256> doc;
  doc["bike_id"]             = BIKE_ID;
  doc["battery_percentage"]  = round(sim.battery * 10) / 10.0;
  doc["voltage_v"]           = round(sim.voltage * 100) / 100.0;
  doc["current_a"]           = round(sim.current * 100) / 100.0;
  doc["speed_kmh"]           = round(sim.speedKmh * 10) / 10.0;
  doc["temperature_celsius"] = round(sim.temperature * 10) / 10.0;
  doc["odometer"]            = round(sim.odometer * 10) / 10.0;
  doc["motor_rpm"]           = sim.motorRpm;

  if (sim.battery < 10)       doc["status"] = "critical";
  else if (sim.battery < 20)  doc["status"] = "warning";
  else                        doc["status"] = "normal";

  doc["timestamp"] = isoNow();

  char buf[256];
  serializeJson(doc, buf);
  mqtt.publish(topicTelemetry, buf);
  Serial.printf("[TELEMETRY] bat=%.1f%% spd=%.1fkm/h rpm=%d\n",
    sim.battery, sim.speedKmh, sim.motorRpm);
}

void publishLocation() {
  StaticJsonDocument<192> doc;
  doc["bike_id"]         = BIKE_ID;
  doc["latitude"]        = sim.lat;
  doc["longitude"]       = sim.lng;
  doc["heading_degrees"] = round(sim.heading * 10) / 10.0;
  doc["speed_kmh"]       = round(sim.speedKmh * 10) / 10.0;
  doc["accuracy_m"]      = 3.5;
  doc["timestamp"]       = isoNow();

  char buf[192];
  serializeJson(doc, buf);
  mqtt.publish(topicLocation, buf);
  Serial.printf("[LOCATION]  lat=%.5f lng=%.5f hdg=%.1f\n",
    sim.lat, sim.lng, sim.heading);
}

void setup() {
  Serial.begin(115200);

  snprintf(topicTelemetry, sizeof(topicTelemetry), "sherides/bikes/%s/telemetry", BIKE_ID);
  snprintf(topicLocation,  sizeof(topicLocation),  "sherides/bikes/%s/location",  BIKE_ID);
  snprintf(topicStatus,    sizeof(topicStatus),    "sherides/bikes/%s/status",    BIKE_ID);

  connectWifi();
  connectMqtt();
}

void loop() {
  if (!mqtt.connected()) connectMqtt();
  mqtt.loop();

  updateSim();

  static unsigned long lastTelemetry = 0;
  static unsigned long lastLocation  = 0;
  unsigned long now = millis();

  if (now - lastTelemetry >= 1000) {
    publishTelemetry();
    lastTelemetry = now;
  }

  if (now - lastLocation >= 2000) {
    publishLocation();
    lastLocation = now;
  }
}
