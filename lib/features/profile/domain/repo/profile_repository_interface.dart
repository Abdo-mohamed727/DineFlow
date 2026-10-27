import 'dart:typed_data';

import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';

abstract interface class ProfileRepositoryInterface {
  Future<Result<UserEntity>> getProfile();

  Future<Result<UserEntity>> uploadProfileImage(
    Uint8List bytes,
    String fileName,
  );

  Future<Result<UserEntity>> updateProfile({
    required String name,
    String? phone,
  });
}
