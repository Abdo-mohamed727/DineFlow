import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/auth/domain/repo/auth_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LogoutUseCase implements UseCase<Result<void>, NoParams> {
  final AuthRepositoryInterface _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.logout();
  }
}
