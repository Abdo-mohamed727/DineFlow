import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/features/auth/data/models/user_model.dart';
import 'package:dineflow/features/profile/data/data_source/profile_remote_data_source_interface.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

@LazySingleton(as: ProfileRemoteDataSourceInterface)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceInterface {
  final SupabaseClient _supabaseClient;

  ProfileRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<UserModel> getProfile() async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) {
        throw const AuthException('No authenticated user found.');
      }

      final data = await _supabaseClient
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .maybeSingle();

      if (data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return UserModel.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? phone,
  }) async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) {
        throw const AuthException('No authenticated user found.');
      }

      await _supabaseClient
          .from('users')
          .update({'name': name, 'phone': phone})
          .eq('id', currentUser.id);

      final data = await _supabaseClient
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .maybeSingle();

      if (data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return UserModel.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }
}
