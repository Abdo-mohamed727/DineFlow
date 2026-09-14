import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/features/auth/data/data_source/auth_remote_data_source_interface.dart';
import 'package:dineflow/features/auth/data/models/user_model.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final uid = response.user?.id;
      if (uid == null) {
        throw const AuthException('User ID not found after login.');
      }

      final data = await _supabaseClient
          .from('users')
          .select()
          .eq('id', uid)
          .maybeSingle();

      if (data == null) {
        throw const NotFoundException(
          'User profile does not exist in database.',
        );
      }

      return UserModel.fromJson(data);
    } on AuthException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );

      final uid = response.user?.id;
      if (uid == null) {
        throw const AuthException(
          'Failed to retrieve user ID upon registration.',
        );
      }

      final userModel = UserModel(
        id: uid,
        name: name,
        email: email,
        role: UserRole.customer,
        phone: phone,
      );

      await _supabaseClient.from('users').insert(userModel.toJson());

      return userModel;
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
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) return null;

      final data = await _supabaseClient
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .maybeSingle();

      if (data == null) return null;

      return UserModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to get current user data: ${e.toString()}');
    }
  }
}
