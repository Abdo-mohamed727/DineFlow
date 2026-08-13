import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/domain/repo/auth_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

@lazySingleton
class LoginUseCase implements UseCase<Result<UserEntity>, LoginParams> {
  final AuthRepositoryInterface _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
