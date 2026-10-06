import 'dart:convert';
import 'dart:typed_data';

import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/features/profile/data/data_source/profile_remote_data_source_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final _validPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/m9sAAAAASUVORK5CYII=',
);

void main() {
  test(
    'uploads multipart image to the existing profile image endpoint',
    () async {
      RequestOptions? request;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'id': 'user-1',
                  'name': 'Test User',
                  'email': 'test@example.com',
                  'profileImage': 'https://example.com/new.png',
                },
              ),
            );
          },
        ),
      );
      final dataSource = ProfileRemoteDataSourceImpl(dio);

      final user = await dataSource.uploadProfileImage(
        Uint8List.fromList(_validPng),
        'avatar.png',
      );

      expect(request?.method, 'PATCH');
      expect(request?.path, ApiConstants.profileImage);
      expect(request?.data, isA<FormData>());
      expect((request!.data as FormData).files.single.key, 'image');
      expect(user.profileImage, 'https://example.com/new.png');
    },
  );

  test('maps backend image size rejection to an explicit error', () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 413,
              data: {'message': 'Payload too large'},
            ),
          ),
        ),
      ),
    );
    final dataSource = ProfileRemoteDataSourceImpl(dio);

    await expectLater(
      dataSource.uploadProfileImage(
        Uint8List.fromList(_validPng),
        'avatar.png',
      ),
      throwsA(
        isA<ServerException>().having(
          (error) => error.message,
          'message',
          contains('exceeds the maximum'),
        ),
      ),
    );
  });

  test('maps connection failures to a network error', () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        ),
      ),
    );
    final dataSource = ProfileRemoteDataSourceImpl(dio);

    await expectLater(
      dataSource.uploadProfileImage(
        Uint8List.fromList(_validPng),
        'avatar.png',
      ),
      throwsA(
        isA<NetworkException>().having(
          (error) => error.message,
          'message',
          contains('Network error'),
        ),
      ),
    );
  });
}
