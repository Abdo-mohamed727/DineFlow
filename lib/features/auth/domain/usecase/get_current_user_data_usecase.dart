import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/domain/repo/auth_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCurrentUserDataUseCase
    implements UseCase<Result<UserEntity?>, NoParams> {
  final AuthRepositoryInterface _repository;

  const GetCurrentUserDataUseCase(this._repository);

  @override
  Future<Result<UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUserData();
  }
}
