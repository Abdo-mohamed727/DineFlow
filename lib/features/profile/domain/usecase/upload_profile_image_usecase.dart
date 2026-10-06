import 'dart:typed_data';

import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/repo/profile_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class UploadProfileImageParams {
  final Uint8List bytes;
  final String fileName;

  const UploadProfileImageParams({required this.bytes, required this.fileName});
}

@lazySingleton
class UploadProfileImageUseCase
    implements UseCase<Result<UserEntity>, UploadProfileImageParams> {
  final ProfileRepositoryInterface _repository;

  const UploadProfileImageUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(UploadProfileImageParams params) {
    return _repository.uploadProfileImage(params.bytes, params.fileName);
  }
}
