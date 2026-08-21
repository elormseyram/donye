/*
 * SheRides Telemetry — Real Hardware Sketch
 *
 * Hardware:
 *   - ESP32 Dev Board  (powered from bike USB port)
 *   - NEO-6M GPS       (UART via Serial2)
 *   - INA219           (I2C — current & voltage sensor)
 *   - Relay module     (GPIO25 — lock / unlock)
 *
 * Wiring:
 *  NEO-6M GPS
 *    VCC  → ESP32 3.3V
 *    GND  → ESP32 GND
 *    TX   → ESP32 GPIO16 (RX2)
 *    RX   → ESP32 GPIO17 (TX2) [optional]
 *
 *  INA219  (place IN SERIES with the main battery line after the fuse)
 *    VCC  → ESP32 3.3V
 *    GND  → ESP32 GND
 *    SDA  → ESP32 GPIO21
 *    SCL  → ESP32 GPIO22
 *    VIN+ → Battery positive (after fuse)
 *    VIN- → Load / motor controller positive in
 *
 *  ⚠️  INA219 bus voltage max is 26V. For this 60V bike, USE_ADC_VOLTAGE is
 *      already set true. Wire the voltage divider:
 *      Battery+ → 200kΩ → GPIO34 → 10kΩ → GND
 *
 *  Relay module (active-HIGH, fail-safe = unlocked)
 *    VCC  → ESP32 5V (VIN pin)
 *    GND  → ESP32 GND
 *    IN   → ESP32 GPIO25
 *    COM  → Bike ignition / motor-enable wire
 *    NO   → Other end of ignition wire  (relay closed = locked)
 *
 * Libraries to install in Arduino IDE (Tools → Manage Libraries):
 *   TinyGPS++        by Mikal Hart
 *   Adafruit INA219  by Adafruit
 *   PubSubClient     by Nick O'Leary
 *   ArduinoJson      by Benoit Blanchon
 */

#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <TinyGPSPlus.h>
#include <Wire.h>
#include <Adafruit_INA219.h>
#include <time.h>

// ── Configuration ─────────────────────────────────────────────────────────────
const char* WIFI_SSID     = "YOUR_WIFI_OR_HOTSPOT_NAME";
const char* WIFI_PASSWORD = "YOUR_WIFI_PASSWORD";

const char* MQTT_HOST = "73cfd07e62844f4e8e02c3114323bcb5.s1.eu.hivemq.cloud";
const int   MQTT_PORT = 8883;
const char* MQTT_USER = "hivemq.webclient.1780094588598";
const char* MQTT_PASS = "5t*op;HrM<8!6N3LXgfC";
const char* BIKE_ID   = "dev-001";

// ── Pin definitions ───────────────────────────────────────────────────────────
#define GPS_RX_PIN   16    // ESP32 RX2 ← GPS TX
#define GPS_TX_PIN   17    // ESP32 TX2 → GPS RX (optional)
#define RELAY_PIN    25    // HIGH = locked, LOW = unlocked
#define VOLT_ADC_PIN 34    // Only used when USE_ADC_VOLTAGE = true

// ── Voltage source ────────────────────────────────────────────────────────────
// false = read bus voltage directly from INA219 (works for ≤26V batteries)
// true  = read from ADC pin via voltage divider  (required for 36V / 48V / 60V bikes)
#define USE_ADC_VOLTAGE true

// Voltage divider for 60V Li-Ion (16S, max 67.2V):
//   R1 = 200kΩ, R2 = 10kΩ → ratio = 10/210 ≈ 0.04762
//   Max ADC voltage = 67.2 × 0.04762 = 3.20V  (safe, ESP32 ADC max = 3.3V)
// ⚠️  DO NOT use 180kΩ/10kΩ here — at 67.2V that puts 3.54V on the ADC pin!
#define VOLT_DIVIDER_RATIO  0.04762f

// Battery voltage range for percentage calculation
// 60V Li-Ion (16S): full = 67.2V, empty = 48.0V
#define BATTERY_FULL_V   67.2f
#define BATTERY_EMPTY_V  48.0f

// ── Internals ─────────────────────────────────────────────────────────────────
char topicTelemetry[80];
char topicLocation[80];
char topicStatus[80];
char topicCommands[80];

WiFiClientSecure  netClient;
PubSubClient      mqtt(netClient);
TinyGPSPlus       gps;
HardwareSerial    gpsSerial(2);
Adafruit_INA219   ina219;

bool   bikeLocked = false;
float  odoKm      = 0.0f;
double lastLat    = 0.0;
double lastLng    = 0.0;

// ── Utilities ─────────────────────────────────────────────────────────────────
String isoNow() {
  time_t now = time(nullptr);
  char buf[30];
  strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%S.000Z", gmtime(&now));
  return String(buf);
}

float batteryPercent(float v) {
  float pct = (v - BATTERY_EMPTY_V) / (BATTERY_FULL_V - BATTERY_EMPTY_V) * 100.0f;
  return constrain(pct, 0.0f, 100.0f);
}

double haversineKm(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371.0;
  double dLat = (lat2 - lat1) * PI / 180.0;
  double dLon = (lon2 - lon1) * PI / 180.0;
  double a = sin(dLat / 2) * sin(dLat / 2)
           + cos(lat1 * PI / 180.0) * cos(lat2 * PI / 180.0)
           * sin(dLon / 2) * sin(dLon / 2);
  return R * 2.0 * atan2(sqrt(a), sqrt(1.0 - a));
}

float readBatteryVoltage() {
  if (USE_ADC_VOLTAGE) {
    int raw = analogRead(VOLT_ADC_PIN);
    float adcV = (raw / 4095.0f) * 3.3f;
    return adcV / VOLT_DIVIDER_RATIO;
  }
  float busV   = ina219.getBusVoltage_V();
  float shuntV = ina219.getShuntVoltage_mV() / 1000.0f;
  return busV + shuntV;
}

// ── WiFi ──────────────────────────────────────────────────────────────────────
void connectWifi() {
  Serial.printf("Connecting to %s\n", WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.printf("\nConnected: %s\n", WiFi.localIP().toString().c_str());
  configTime(0, 0, "pool.ntp.org");
  delay(2000);
}

// ── MQTT command handler ───────────────────────────────────────────────────────
void onCommand(char* topic, byte* payload, unsigned int len) {
  StaticJsonDocument<128> doc;
  if (deserializeJson(doc, payload, len) != DeserializationError::Ok) return;

  const char* type = doc["type"] | "";

  if (strcmp(type, "lock") == 0) {
    bikeLocked = true;
    digitalWrite(RELAY_PIN, HIGH);
    Serial.println("[CMD] Locked");
  } else if (strcmp(type, "unlock") == 0) {
    bikeLocked = false;
    digitalWrite(RELAY_PIN, LOW);
    Serial.println("[CMD] Unlocked");
  } else if (strcmp(type, "honk") == 0) {
    // Wire a buzzer to GPIO26 and pulse it here if you have one
    Serial.println("[CMD] Honk");
  } else if (strcmp(type, "lights_on") == 0) {
    Serial.println("[CMD] Lights ON");
  } else if (strcmp(type, "lights_off") == 0) {
    Serial.println("[CMD] Lights OFF");
  }
}

// ── MQTT connect ──────────────────────────────────────────────────────────────
void connectMqtt() {
  netClient.setInsecure();
  mqtt.setServer(MQTT_HOST, MQTT_PORT);
  mqtt.setBufferSize(512);
  mqtt.setCallback(onCommand);

  char clientId[48];
  snprintf(clientId, sizeof(clientId), "sherides-hw-%s-%lu", BIKE_ID, millis());

  while (!mqtt.connected()) {
    Serial.print("Connecting to HiveMQ... ");
    if (mqtt.connect(clientId, MQTT_USER, MQTT_PASS)) {
      Serial.println("connected");
      StaticJsonDocument<64> s;
      s["bike_id"] = BIKE_ID;
      s["status"]  = "online";
      char buf[64];
      serializeJson(s, buf);
      mqtt.publish(topicStatus, buf, true);
      mqtt.subscribe(topicCommands);
    } else {
      Serial.printf("failed rc=%d, retry 5s\n", mqtt.state());
      delay(5000);
    }
  }
}

// ── Publish telemetry ─────────────────────────────────────────────────────────
void publishTelemetry() {
  float voltageV = readBatteryVoltage();
  float currentA = ina219.getCurrent_mA() / 1000.0f;
  float battPct  = batteryPercent(voltageV);
  float speedKmh = gps.speed.isValid() ? (float)gps.speed.kmph() : 0.0f;
  int   motorRpm = (int)(speedKmh * 18.5f);
  float tempC    = (float)temperatureRead();  // ESP32 internal die temp (~+10°C offset)

  StaticJsonDocument<256> doc;
  doc["bike_id"]             = BIKE_ID;
  doc["battery_percentage"]  = round(battPct  * 10) / 10.0;
  doc["voltage_v"]           = round(voltageV * 100) / 100.0;
  doc["current_a"]           = round(currentA * 100) / 100.0;
  doc["speed_kmh"]           = round(speedKmh * 10) / 10.0;
  doc["temperature_celsius"] = round(tempC    * 10) / 10.0;
  doc["odometer"]            = round(odoKm    * 10) / 10.0;
  doc["motor_rpm"]           = motorRpm;
  doc["status"]              = battPct < 10 ? "critical"
                             : battPct < 20 ? "warning"
                             : "normal";
  doc["timestamp"]           = isoNow();

  char buf[256];
  serializeJson(doc, buf);
  mqtt.publish(topicTelemetry, buf);
  Serial.printf("[TELEMETRY] bat=%.1f%% %.2fV %.3fA spd=%.1fkm/h\n",
    battPct, voltageV, currentA, speedKmh);
}

// ── Publish location ──────────────────────────────────────────────────────────
void publishLocation() {
  if (!gps.location.isValid()) {
    Serial.println("[GPS] Waiting for fix...");
    return;
  }

  double lat = gps.location.lat();
  double lng = gps.location.lng();

  if (lastLat != 0.0 && lastLng != 0.0) {
    float dist = (float)haversineKm(lastLat, lastLng, lat, lng);
    if (dist < 0.5f) odoKm += dist;  // ignore GPS jumps > 500m
  }
  lastLat = lat;
  lastLng = lng;

  StaticJsonDocument<192> doc;
  doc["bike_id"]         = BIKE_ID;
  doc["latitude"]        = lat;
  doc["longitude"]       = lng;
  doc["heading_degrees"] = gps.course.isValid() ? gps.course.deg() : 0.0;
  doc["speed_kmh"]       = gps.speed.isValid()  ? gps.speed.kmph() : 0.0;
  doc["accuracy_m"]      = gps.hdop.isValid()   ? gps.hdop.hdop() * 5.0 : 9.9;
  doc["timestamp"]       = isoNow();

  char buf[192];
  serializeJson(doc, buf);
  mqtt.publish(topicLocation, buf);
  Serial.printf("[LOCATION] lat=%.6f lng=%.6f hdg=%.1f\n", lat, lng,
    gps.course.isValid() ? gps.course.deg() : 0.0);
}

// ── Setup ─────────────────────────────────────────────────────────────────────
void setup() {
  Serial.begin(115200);

  snprintf(topicTelemetry, sizeof(topicTelemetry), "sherides/bikes/%s/telemetry", BIKE_ID);
  snprintf(topicLocation,  sizeof(topicLocation),  "sherides/bikes/%s/location",  BIKE_ID);
  snprintf(topicStatus,    sizeof(topicStatus),    "sherides/bikes/%s/status",    BIKE_ID);
  snprintf(topicCommands,  sizeof(topicCommands),  "sherides/bikes/%s/commands",  BIKE_ID);

  // Relay — start unlocked (fail-safe)
  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, LOW);

  // GPS on Serial2
  gpsSerial.begin(9600, SERIAL_8N1, GPS_RX_PIN, GPS_TX_PIN);
  Serial.println("GPS initialised on Serial2");

  // INA219
  if (!ina219.begin()) {
    Serial.println("⚠️  INA219 not found — check SDA/SCL wiring and I2C address");
  } else {
    Serial.println("INA219 ready");
  }

  // ADC pin for voltage divider (if enabled)
  if (USE_ADC_VOLTAGE) {
    analogReadResolution(12);
    pinMode(VOLT_ADC_PIN, INPUT);
  }

  connectWifi();
  connectMqtt();
}

// ── Loop ──────────────────────────────────────────────────────────────────────
void loop() {
  // Feed GPS parser
  while (gpsSerial.available()) {
    gps.encode(gpsSerial.read());
  }

  // MQTT keep-alive
  if (!mqtt.connected()) connectMqtt();
  mqtt.loop();

  unsigned long now = millis();
  static unsigned long lastTelemetry = 0;
  static unsigned long lastLocation  = 0;

  if (now - lastTelemetry >= 1000) {
    publishTelemetry();
    lastTelemetry = now;
  }

  if (now - lastLocation >= 2000) {
    publishLocation();
    lastLocation = now;
  }
}
