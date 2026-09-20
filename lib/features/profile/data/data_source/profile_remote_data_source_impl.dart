import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/features/auth/data/models/user_model.dart';
import 'package:dineflow/features/profile/data/data_source/profile_remote_data_source_interface.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRemoteDataSourceInterface)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceInterface {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<User> getProfile() async {
    try {
      Response response;
      try {
        response = await _dio.get(ApiConstants.profile);
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          response = await _dio.get(ApiConstants.me);
        } else {
          rethrow;
        }
      }

      if (response.data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return User.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<User> updateProfile({
    required String name,
    String? phone,
  }) async {
    try {
      Response response;
      try {
        response = await _dio.patch(
          ApiConstants.profile,
          data: {'name': name, 'phone': phone},
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          try {
            response = await _dio.patch(
              ApiConstants.me,
              data: {'name': name, 'phone': phone},
            );
          } on DioException catch (_) {
            response = await _dio.put(
              ApiConstants.me,
              data: {'name': name, 'phone': phone},
            );
          }
        } else {
          rethrow;
        }
      }

      if (response.data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return User.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }
}
