import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/networking/dio_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({'token': 'test-access-token'});
    sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  test('sends the saved token as a Bearer authorization header', () async {
    final dio = getdio();
    String? authorizationHeader;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          authorizationHeader = options.headers['Authorization'] as String?;
          handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: const {}),
          );
        },
      ),
    );

    await dio.get('/test');

    expect(authorizationHeader, 'Bearer test-access-token');
  });
}
