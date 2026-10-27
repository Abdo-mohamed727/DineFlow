import 'dart:typed_data';

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
  Future<User> uploadProfileImage(Uint8List bytes, String fileName) async {
    try {
      if (bytes.isEmpty) {
        throw const ServerException('The selected image is empty.');
      }

      final extension = fileName.split('.').last.toLowerCase();
      final contentType = switch (extension) {
        'jpg' || 'jpeg' => DioMediaType('image', 'jpeg'),
        'png' => DioMediaType('image', 'png'),
        'webp' => DioMediaType('image', 'webp'),
        _ => throw const ServerException(
          'Unsupported image format. Select a JPEG, PNG, or WebP image.',
        ),
      };
      final filename = fileName.trim().isEmpty
          ? 'profile-image.$extension'
          : fileName;
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: contentType,
        ),
      });
      final response = await _dio.patch(
        ApiConstants.profileImage,
        data: formData,
      );
      if (response.data == null) {
        throw const ServerException(
          'The server did not return the updated profile.',
        );
      }
      return User.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        throw const AuthException(
          'You are not authorized to update the profile image.',
        );
      }
      if (statusCode == 404) {
        throw const NotFoundException('User profile does not exist.');
      }
      if (statusCode == 413) {
        throw const ServerException(
          'The selected image exceeds the maximum allowed file size.',
        );
      }
      if (statusCode == 415) {
        throw const ServerException(
          'Unsupported image format. Select a JPEG, PNG, or WebP image.',
        );
      }
      if (statusCode == null) {
        throw const NetworkException(
          'Network error while uploading the profile image. Check your connection and try again.',
        );
      }
      final responseMessage = e.response?.data is Map<String, dynamic>
          ? (e.response!.data as Map<String, dynamic>)['message']?.toString()
          : null;
      throw ServerException(
        responseMessage?.isNotEmpty == true
            ? responseMessage!
            : 'Failed to upload profile image: ${e.message ?? 'Unknown error'}',
      );
    } catch (e) {
      throw ServerException('Failed to upload profile image: $e');
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      Response response;
      try {
        response = await _dio.get(ApiConstants.profile);
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          response = await _dio.get(ApiConstants.me);
        } else {
          rethrow;
        }
      }

      if (response.data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return User.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<User> updateProfile({required String name, String? phone}) async {
    try {
      Response response;
      try {
        response = await _dio.patch(
          ApiConstants.profile,
          data: {'name': name, 'phone': phone},
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          try {
            response = await _dio.patch(
              ApiConstants.me,
              data: {'name': name, 'phone': phone},
            );
          } on DioException catch (_) {
            response = await _dio.put(
              ApiConstants.me,
              data: {'name': name, 'phone': phone},
            );
          }
        } else {
          rethrow;
        }
      }

      if (response.data == null) {
        throw const NotFoundException('User profile does not exist.');
      }

      return User.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }
}
