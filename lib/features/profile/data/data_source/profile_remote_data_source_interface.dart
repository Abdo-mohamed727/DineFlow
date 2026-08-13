import 'package:dineflow/features/auth/data/models/user_model.dart';

abstract interface class ProfileRemoteDataSourceInterface {
  Future<UserModel> getProfile();

  Future<UserModel> updateProfile({
    required String name,
    String? phone,
  });
}
