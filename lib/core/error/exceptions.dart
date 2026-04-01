class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  const ServerException({this.message, this.statusCode});

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class NetworkException implements Exception {
  const NetworkException();
}

class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});
}