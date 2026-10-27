import 'package:dineflow/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<User> login({required String email, required String password});

  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  Future<void> logout();

  Future<User?> getCurrentUserData();
}
