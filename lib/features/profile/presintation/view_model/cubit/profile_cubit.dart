import 'dart:typed_data';

import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:dineflow/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:dineflow/features/profile/domain/usecase/upload_profile_image_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isSaving = false;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._uploadProfileImageUseCase,
  ) : super(const ProfileState.initial());

  Future<void> getProfile() async {
    emit(const ProfileState.loading());
    final result = await _getProfileUseCase(const NoParams());
    switch (result) {
      case Success(data: final user):
        emit(ProfileState.loaded(user));
      case FailureResult(failure: final failure):
        emit(ProfileState.error(failure.message));
    }
  }

  Future<void> selectProfileImage(
    XFile image, {
    required UserEntity user,
  }) async {
    if (_isSaving || isClosed) return;
    try {
      final bytes = await image.readAsBytes();
      if (isClosed) return;
      final extension = image.name.split('.').last.toLowerCase();
      if (bytes.isEmpty || !_hasSupportedImageSignature(bytes, extension)) {
        emit(
          ProfileState.error(
            'Unsupported or invalid image. Select a JPEG, PNG, or WebP image.',
            user: user,
            imagePreview: _selectedImageBytes,
          ),
        );
        return;
      }

      _selectedImage = image;
      _selectedImageBytes = bytes;
      emit(ProfileState.loaded(user, imagePreview: bytes));
    } catch (error) {
      emit(
        ProfileState.error(
          'Unable to read the selected image: $error',
          user: user,
          imagePreview: _selectedImageBytes,
        ),
      );
    }
  }

  void reportPickerError(String message, {required UserEntity user}) {
    emit(
      ProfileState.error(
        message,
        user: user,
        imagePreview: _selectedImageBytes,
      ),
    );
  }

  Future<void> updateProfile(
    UpdateProfileParams params, {
    required UserEntity user,
  }) async {
    if (_isSaving) return;
    _isSaving = true;
    emit(ProfileState.loading(user: user, imagePreview: _selectedImageBytes));

    try {
      UserEntity? uploadedUser;
      final selectedImage = _selectedImage;
      final selectedImageBytes = _selectedImageBytes;
      if (selectedImage != null) {
        if (selectedImageBytes == null) {
          emit(
            ProfileState.error(
              'The selected image is not available. Please select it again.',
              user: user,
            ),
          );
          return;
        }
        final uploadResult = await _uploadProfileImageUseCase(
          UploadProfileImageParams(
            bytes: selectedImageBytes,
            fileName: selectedImage.name,
          ),
        );
        if (isClosed) return;
        switch (uploadResult) {
          case Success(data: final uploaded):
            if (uploaded.profileImage?.isNotEmpty != true) {
              emit(
                ProfileState.error(
                  'The server did not return the uploaded profile image.',
                  user: user,
                  imagePreview: _selectedImageBytes,
                ),
              );
              return;
            }
            uploadedUser = uploaded;
          case FailureResult(failure: final failure):
            emit(
              ProfileState.error(
                failure.message,
                user: user,
                imagePreview: _selectedImageBytes,
              ),
            );
            return;
        }
      }

      final updateResult = await _updateProfileUseCase(params);
      if (isClosed) return;
      switch (updateResult) {
        case Success(data: final updatedUser):
          final resultUser = uploadedUser == null
              ? updatedUser
              : updatedUser.copyWith(profileImage: uploadedUser.profileImage);
          _selectedImage = null;
          _selectedImageBytes = null;
          emit(ProfileState.updateSuccess(resultUser));
        case FailureResult(failure: final failure):
          emit(
            ProfileState.error(
              failure.message,
              user: user,
              imagePreview: _selectedImageBytes,
            ),
          );
      }
    } finally {
      _isSaving = false;
    }
  }

  bool _hasSupportedImageSignature(Uint8List bytes, String extension) {
    final isJpeg =
        bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff;
    final isPng =
        bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4e &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0d &&
        bytes[5] == 0x0a &&
        bytes[6] == 0x1a &&
        bytes[7] == 0x0a;
    final isWebp =
        bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50;
    return switch (extension) {
      'jpg' || 'jpeg' => isJpeg,
      'png' => isPng,
      'webp' => isWebp,
      _ => false,
    };
  }
}
