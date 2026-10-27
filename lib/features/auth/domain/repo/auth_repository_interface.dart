import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';

abstract interface class AuthRepositoryInterface {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  Future<Result<void>> logout();

  Future<Result<UserEntity?>> getCurrentUserData();
}
