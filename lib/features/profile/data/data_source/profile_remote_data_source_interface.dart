import 'package:dineflow/features/auth/data/models/user_model.dart';

abstract interface class ProfileRemoteDataSourceInterface {
  Future<User> getProfile();

  Future<User> updateProfile({
    required String name,
    String? phone,
  });
}
