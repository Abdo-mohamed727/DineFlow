import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/domain/repo/auth_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String? phone;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });
}

@lazySingleton
class RegisterUseCase implements UseCase<Result<UserEntity>, RegisterParams> {
  final AuthRepositoryInterface _repository;

  const RegisterUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
    );
  }
}
