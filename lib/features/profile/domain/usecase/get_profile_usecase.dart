import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/repo/profile_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetProfileUseCase implements UseCase<Result<UserEntity>, NoParams> {
  final ProfileRepositoryInterface _repository;

  const GetProfileUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(NoParams params) {
    return _repository.getProfile();
  }
}
