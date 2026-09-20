import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/features/auth/data/data_source/auth_remote_data_source_interface.dart';
import 'package:dineflow/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final token = response.data?['data']?['token'] ?? response.data?['token'];
      if (token != null) {
        final prefs = sl<SharedPreferences>();
        await prefs.setString('token', token.toString());
      }

      final userData = response.data?['data']?['user'] ??
          response.data?['user'] ??
          response.data;

      if (userData == null) {
        throw const AuthException('User data not found after login.');
      }

      return User.fromJson(userData as Map<String, dynamic>);
    } on AuthException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      final userData = response.data?['data']?['user'] ??
          response.data?['user'] ??
          response.data;

      if (userData == null) {
        throw const AuthException(
          'Failed to retrieve user data upon registration.',
        );
      }

      return User.fromJson(userData as Map<String, dynamic>);
    } on AuthException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to register user: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
      final prefs = sl<SharedPreferences>();
      await prefs.remove('token');
    } catch (e) {
      throw ServerException('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUserData() async {
    try {
      final response = await _dio.get(ApiConstants.me);
      if (response.data == null) return null;

      final userData = response.data?['data']?['user'] ??
          response.data?['user'] ??
          response.data;

      if (userData == null) return null;
      return User.fromJson(userData as Map<String, dynamic>);
    } catch (e) {
      throw ServerException('Failed to get current user data: ${e.toString()}');
    }
  }
}
