import 'package:dineflow/core/error/failure.dart';

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);
}
