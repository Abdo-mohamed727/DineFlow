import 'dart:typed_data';

import 'package:dineflow/features/auth/data/models/user_model.dart';

abstract interface class ProfileRemoteDataSourceInterface {
  Future<User> getProfile();

  Future<User> uploadProfileImage(Uint8List bytes, String fileName);

  Future<User> updateProfile({required String name, String? phone});
}
