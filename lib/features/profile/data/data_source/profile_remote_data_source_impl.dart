import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/features/auth/data/models/user_model.dart';
import 'package:dineflow/features/profile/data/data_source/profile_remote_data_source_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRemoteDataSourceInterface)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceInterface {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> getProfile() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const AuthException('No authenticated user found.');
      }

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return UserModel.fromJson(doc.data()!);
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
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const AuthException('No authenticated user found.');
      }

      final docRef = _firestore.collection('users').doc(currentUser.uid);
      await docRef.update({
        'name': name,
        'phone': phone,
      });

      final doc = await docRef.get();
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return UserModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }
}
