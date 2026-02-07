import "package:dio/dio.dart";

abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;

  factory ServerException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerException("Connection timeout");
      case DioExceptionType.sendTimeout:
        return const ServerException("Send timeout");
      case DioExceptionType.receiveTimeout:
        return const ServerException("Receive timeout");
      case DioExceptionType.badResponse:
        return ServerException(
          e.response?.data["message"] ?? "Server error",
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerException("Request cancelled");
      default:
        return const ServerException("Network error");
    }
  }
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class AuthException extends AppException {
  const AuthException(super.message);
}
