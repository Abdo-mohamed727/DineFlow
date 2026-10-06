part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading({
    UserEntity? user,
    Uint8List? imagePreview,
  }) = _Loading;
  const factory ProfileState.loaded(
    UserEntity user, {
    Uint8List? imagePreview,
  }) = _Loaded;
  const factory ProfileState.updateSuccess(UserEntity user) = _UpdateSuccess;
  const factory ProfileState.error(
    String message, {
    UserEntity? user,
    Uint8List? imagePreview,
  }) = _Error;
}
