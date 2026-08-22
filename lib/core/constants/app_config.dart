abstract class AppConfig {
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const String dornyePortalUrl =
      String.fromEnvironment('DORNYE_PORTAL_URL');
  static const String dornyePortalPublishableKey =
      String.fromEnvironment('DORNYE_PORTAL_PUBLISHABLE_KEY');
  static const String mqttBrokerHost =
      String.fromEnvironment('MQTT_BROKER_HOST');
  static const int mqttBrokerPort = 1883;
  static const int mqttBrokerTlsPort = 8883;
  static const bool mqttUseTls = true;
  static const String mqttUsername = String.fromEnvironment('MQTT_USERNAME');
  static const String mqttPassword = String.fromEnvironment('MQTT_PASSWORD');
  static const String mqttTopicPrefix = 'sherides/bikes';
  static const int mqttKeepAliveSeconds = 30;
  static const String googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String appName = 'SheRides Telemetry';
  static const int telemetryHistoryLimit = 100;
  static const int mqttReconnectMaxDelaySeconds = 30;
  static const bool isDevMode = false;
}
