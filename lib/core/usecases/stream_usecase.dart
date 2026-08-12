abstract interface class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}
