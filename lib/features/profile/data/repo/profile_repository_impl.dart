import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/data/data_source/profile_remote_data_source_interface.dart';
import 'package:dineflow/features/profile/domain/repo/profile_repository_interface.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepositoryInterface)
class ProfileRepositoryImpl implements ProfileRepositoryInterface {
  final ProfileRemoteDataSourceInterface _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserEntity>> getProfile() async {
    try {
      final userModel = await _remoteDataSource.getProfile();
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
  Future<Result<UserEntity>> updateProfile({
    required String name,
    String? phone,
  }) async {
    try {
      final userModel = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
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
}
