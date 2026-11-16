abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

final class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode});
}

final class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode});
}

final class CacheException extends AppException {
  const CacheException(super.message, {super.statusCode});
}

final class PermissionException extends AppException {
  const PermissionException(super.message, {super.statusCode});
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.statusCode});
}
