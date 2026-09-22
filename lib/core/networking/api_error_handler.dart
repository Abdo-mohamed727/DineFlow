import 'package:dineflow/core/error/exception.dart';
import 'package:dio/dio.dart';
import 'api_error_model.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  /// Converts any thrown error into an [ApiErrorModel].
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) return _handleDioException(error);

    return ApiErrorModel(
      success: false,
      message: 'Unexpected error occurred',
      error: error.toString(),
    );
  }

  static ApiErrorModel _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return _local('Connection timeout. Please try again.', e);
      case DioExceptionType.sendTimeout:
        return _local('Send timeout. Please try again.', e);
      case DioExceptionType.receiveTimeout:
        return _local('Server took too long to respond.', e);
      case DioExceptionType.transformTimeout:
        return _local('Processing the response took too long.', e);
      case DioExceptionType.connectionError:
        return _local('No internet connection.', e);
      case DioExceptionType.badCertificate:
        return _local('Invalid security certificate.', e);
      case DioExceptionType.cancel:
        return _local('Request was cancelled.', e);
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.unknown:
        return _local('Something went wrong. Please try again.', e);
    }
  }

  static ApiErrorModel _handleBadResponse(Response? response) {
    final data = response?.data;

    // Server returned our expected error shape
    if (data is Map<String, dynamic>) {
      final model = ApiErrorModel.fromJson(data);
      if (model.message != null || model.error != null) return model;
    }

    // Fallback to a message based on the status code
    return ApiErrorModel(
      success: false,
      message: _messageFromStatus(response?.statusCode),
    );
  }

  static String _messageFromStatus(int? code) {
    switch (code) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'You don\'t have permission to do this.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict occurred.';
      case 422:
        return 'Invalid data submitted.';
      case 429:
        return 'Too many requests. Slow down.';
      case 500:
        return 'Internal server error.';
      case 502:
      case 503:
      case 504:
        return 'Server is unavailable. Try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static ApiErrorModel _local(String message, DioException e) {
    return ApiErrorModel(
      success: false,
      message: message,
      error: e.message,
    );
  }

  /// Maps networking errors to [AppException] so UI never sees raw Dio text.
  static Never throwAppException(
    Object error, {
    String fallback = 'Something went wrong. Please try again.',
  }) {
    if (error is AppException) {
      throw error;
    }

    final model = handle(error);
    final message = (model.message?.isNotEmpty ?? false)
        ? model.message!
        : ((model.error?.isNotEmpty ?? false) ? model.error! : fallback);

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          throw NetworkException(message);
        default:
          break;
      }

      final code = error.response?.statusCode;
      if (code == 401 || code == 403) {
        throw AuthException(message);
      }
      if (code == 404) {
        throw NotFoundException(message);
      }
    }

    throw ServerException(message);
  }
}