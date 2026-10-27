import 'dart:convert';
import 'dart:typed_data';

import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:dineflow/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:dineflow/features/profile/domain/usecase/upload_profile_image_usecase.dart';
import 'package:dineflow/features/profile/presintation/view/widgets/edit_profile_form.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

final _validPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/m9sAAAAASUVORK5CYII=',
);
const _user = UserEntity(
  id: 'user-1',
  name: 'Test User',
  email: 'test@example.com',
);

class _GetProfileUseCase implements GetProfileUseCase {
  @override
  Future<Result<UserEntity>> call(NoParams params) async =>
      const Success(_user);
}

class _UpdateProfileUseCase implements UpdateProfileUseCase {
  @override
  Future<Result<UserEntity>> call(UpdateProfileParams params) async =>
      const Success(_user);
}

class _UploadProfileImageUseCase implements UploadProfileImageUseCase {
  @override
  Future<Result<UserEntity>> call(UploadProfileImageParams params) async =>
      const Success(_user);
}

void main() {
  late ProfileCubit cubit;

  setUp(() {
    cubit = ProfileCubit(
      _GetProfileUseCase(),
      _UpdateProfileUseCase(),
      _UploadProfileImageUseCase(),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  Future<void> showForm(
    WidgetTester tester, {
    required Future<XFile?> Function() pickImage,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: Scaffold(
            body: EditProfileForm(user: _user, pickImage: pickImage),
          ),
        ),
      ),
    );
  }

  testWidgets('picker cancellation leaves profile image unchanged', (
    tester,
  ) async {
    await showForm(tester, pickImage: () async => null);

    await tester.tap(find.text('Change photo'));
    await tester.pumpAndSettle();

    expect(cubit.state, const ProfileState.initial());
  });

  testWidgets('selected image is shown as a local preview', (tester) async {
    await showForm(
      tester,
      pickImage: () async => XFile.fromData(
        Uint8List.fromList(_validPng),
        name: 'avatar.png',
        path: 'avatar.png',
      ),
    );

    await tester.tap(find.text('Change photo'));
    await tester.pump();
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is MemoryImage,
      ),
      findsOneWidget,
    );
  });
}
