import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/data/data_source/auth_remote_data_source_interface.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/domain/repo/auth_repository_interface.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepositoryInterface)
class AuthRepositoryImpl implements AuthRepositoryInterface {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Success(userModel.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      return Success(userModel.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Success(null);
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUserData() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUserData();
      return Success(userModel?.toEntity());
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
