import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/repo/profile_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class UpdateProfileParams {
  final String name;
  final String? phone;

  const UpdateProfileParams({
    required this.name,
    this.phone,
  });
}

@lazySingleton
class UpdateProfileUseCase
    implements UseCase<Result<UserEntity>, UpdateProfileParams> {
  final ProfileRepositoryInterface _repository;

  const UpdateProfileUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      name: params.name,
      phone: params.phone,
    );
  }
}
