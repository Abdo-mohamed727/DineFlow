import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:dineflow/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:dineflow/features/profile/domain/usecase/upload_profile_image_usecase.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

final _validPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/m9sAAAAASUVORK5CYII=',
);

const _user = UserEntity(
  id: 'user-1',
  name: 'Test User',
  email: 'test@example.com',
  profileImage: 'https://example.com/old.png',
);

class _GetProfileUseCase implements GetProfileUseCase {
  @override
  Future<Result<UserEntity>> call(NoParams params) async =>
      const Success(_user);
}

class _UpdateProfileUseCase implements UpdateProfileUseCase {
  int calls = 0;
  Result<UserEntity> result = const Success(_user);
  Completer<Result<UserEntity>>? pendingResult;
  final List<String> callsInOrder;

  _UpdateProfileUseCase(this.callsInOrder);

  @override
  Future<Result<UserEntity>> call(UpdateProfileParams params) {
    calls++;
    callsInOrder.add('update');
    return pendingResult?.future ?? Future.value(result);
  }
}

class _UploadProfileImageUseCase implements UploadProfileImageUseCase {
  int calls = 0;
  UploadProfileImageParams? params;
  Result<UserEntity> result = const Success(
    UserEntity(
      id: 'user-1',
      name: 'Test User',
      email: 'test@example.com',
      profileImage: 'https://example.com/new.png',
    ),
  );
  Completer<Result<UserEntity>>? pendingResult;
  final List<String> callsInOrder;

  _UploadProfileImageUseCase(this.callsInOrder);

  @override
  Future<Result<UserEntity>> call(UploadProfileImageParams params) {
    calls++;
    this.params = params;
    callsInOrder.add('upload');
    return pendingResult?.future ?? Future.value(result);
  }
}

void main() {
  late ProfileCubit cubit;
  late _UpdateProfileUseCase updateUseCase;
  late _UploadProfileImageUseCase uploadUseCase;
  late List<String> callsInOrder;

  setUp(() {
    callsInOrder = [];
    updateUseCase = _UpdateProfileUseCase(callsInOrder);
    uploadUseCase = _UploadProfileImageUseCase(callsInOrder);
    cubit = ProfileCubit(_GetProfileUseCase(), updateUseCase, uploadUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  XFile image() => XFile.fromData(
    Uint8List.fromList(_validPng),
    name: 'avatar.png',
    path: 'avatar.png',
  );

  test('selecting a valid image emits a local preview', () async {
    final selected = image();

    await cubit.selectProfileImage(selected, user: _user);

    expect(
      cubit.state.maybeWhen(
        loaded: (user, preview) => user == _user && preview != null,
        orElse: () => false,
      ),
      isTrue,
    );
    expect(uploadUseCase.calls, 0);
  });

  test(
    'invalid image format is rejected without replacing the current image',
    () async {
      await cubit.selectProfileImage(
        XFile.fromData(
          Uint8List.fromList([1, 2, 3]),
          name: 'avatar.png',
          path: 'avatar.png',
        ),
        user: _user,
      );

      expect(
        cubit.state.maybeWhen(
          error: (message, user, _) =>
              message.contains('invalid image') && user == _user,
          orElse: () => false,
        ),
        isTrue,
      );
      expect(uploadUseCase.calls, 0);
    },
  );

  test(
    'uploads the image before updating profile and uses uploaded URL',
    () async {
      await cubit.selectProfileImage(image(), user: _user);
      await cubit.updateProfile(
        const UpdateProfileParams(name: 'Changed', phone: '123'),
        user: _user,
      );

      expect(callsInOrder, ['upload', 'update']);
      expect(uploadUseCase.params?.fileName, 'avatar.png');
      expect(
        cubit.state.maybeWhen(
          updateSuccess: (user) =>
              user.profileImage == 'https://example.com/new.png',
          orElse: () => false,
        ),
        isTrue,
      );
    },
  );

  test(
    'upload failure keeps the old profile and skips profile update',
    () async {
      uploadUseCase.result = const FailureResult(
        ServerFailure('Image upload failed'),
      );
      await cubit.selectProfileImage(image(), user: _user);

      await cubit.updateProfile(
        const UpdateProfileParams(name: 'Changed'),
        user: _user,
      );

      expect(updateUseCase.calls, 0);
      expect(
        cubit.state.maybeWhen(
          error: (message, user, _) =>
              message == 'Image upload failed' &&
              user?.profileImage == _user.profileImage,
          orElse: () => false,
        ),
        isTrue,
      );
    },
  );

  test(
    'profile update failure after image upload is reported as an error',
    () async {
      updateUseCase.result = const FailureResult(
        ServerFailure('Profile update failed'),
      );
      await cubit.selectProfileImage(image(), user: _user);

      await cubit.updateProfile(
        const UpdateProfileParams(name: 'Changed'),
        user: _user,
      );

      expect(callsInOrder, ['upload', 'update']);
      expect(
        cubit.state.maybeWhen(
          error: (message, _, _) => message == 'Profile update failed',
          orElse: () => false,
        ),
        isTrue,
      );
    },
  );

  test('saving without a selected image does not upload', () async {
    await cubit.updateProfile(
      const UpdateProfileParams(name: 'Changed'),
      user: _user,
    );

    expect(uploadUseCase.calls, 0);
    expect(updateUseCase.calls, 1);
  });

  test('duplicate saves do not start concurrent upload requests', () async {
    final pendingUpload = Completer<Result<UserEntity>>();
    uploadUseCase.pendingResult = pendingUpload;
    await cubit.selectProfileImage(image(), user: _user);

    final firstSave = cubit.updateProfile(
      const UpdateProfileParams(name: 'Changed'),
      user: _user,
    );
    await Future<void>.delayed(Duration.zero);
    await cubit.updateProfile(
      const UpdateProfileParams(name: 'Changed'),
      user: _user,
    );

    expect(uploadUseCase.calls, 1);
    expect(updateUseCase.calls, 0);
    pendingUpload.complete(uploadUseCase.result);
    await firstSave;
    expect(updateUseCase.calls, 1);
  });
}
