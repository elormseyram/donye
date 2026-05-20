class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class NetworkException implements Exception {
  const NetworkException({required this.message});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class AppAuthException implements Exception {
  const AppAuthException({required this.message});
  final String message;

  @override
  String toString() => 'AppAuthException: $message';
}

class MqttException implements Exception {
  const MqttException({required this.message});
  final String message;

  @override
  String toString() => 'MqttException: $message';
}

class CacheException implements Exception {
  const CacheException({required this.message});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}
