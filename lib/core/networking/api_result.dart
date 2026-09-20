sealed class ApiResult<T>{
  const ApiResult();
}


class Success<T> extends ApiResult{
  final T data;
  const Success(this.data);
}


class Failure<T> extends ApiResult{
  final String error;
  const Failure(this.error);
}
