import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/features/auth/data/data_source/auth_remote_data_source_interface.dart';
import 'package:dineflow/features/auth/data/models/user_model.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw const AuthException('User ID not found after login.');
      }

      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundException(
          'User profile does not exist in database.',
        );
      }

      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed.');
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
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw const AuthException(
          'Failed to retrieve user ID upon registration.',
        );
      }

      await credential.user?.updateDisplayName(name);

      final userModel = UserModel(
        id: uid,
        name: name,
        email: email,
        role: UserRole.customer,
        phone: phone,
      );

      await _firestore.collection('users').doc(uid).set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed.');
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to register user: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return null;

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (!doc.exists || doc.data() == null) return null;

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException('Failed to get current user data: ${e.toString()}');
    }
  }
}
