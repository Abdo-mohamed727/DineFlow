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
      final response = await _dio.get(ApiConstants.profile);

      if (response.data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      final userData = response.data?['data']?['user'] ??
          response.data?['user'] ??
          response.data;

      if (userData == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return User.fromJson(userData as Map<String, dynamic>);
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
      final response = await _dio.put(
        ApiConstants.profile,
        data: {'name': name, 'phone': phone},
      );

      if (response.data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      final userData = response.data?['data']?['user'] ??
          response.data?['user'] ??
          response.data;

      if (userData == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return User.fromJson(userData as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }
}
