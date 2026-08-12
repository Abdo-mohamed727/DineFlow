abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

final class ServerException extends AppException {
  const ServerException(super.message);
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class AuthException extends AppException {
  const AuthException(super.message);
}

final class CacheException extends AppException {
  const CacheException(super.message);
}

final class PermissionException extends AppException {
  const PermissionException(super.message);
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message);
}
