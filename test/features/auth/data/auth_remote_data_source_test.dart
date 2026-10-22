import 'dart:typed_data';

import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestHttpAdapter implements HttpClientAdapter {
  _TestHttpAdapter(this.statusCode);

  final int statusCode;
  int requestCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    return ResponseBody.fromString(
      '{}',
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late SharedPreferences preferences;
  late _TestHttpAdapter adapter;
  late Dio dio;

  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({'token': 'expired-token'});
    preferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(preferences);

    adapter = _TestHttpAdapter(401);
    dio = Dio(BaseOptions(baseUrl: 'https://test.example'))
      ..httpClientAdapter = adapter;
  });

  tearDown(() async {
    dio.close(force: true);
    await sl.reset();
  });

  test('does not request current user when no session token exists', () async {
    await preferences.remove('token');

    final user = await AuthRemoteDataSourceImpl(dio).getCurrentUserData();

    expect(user, isNull);
    expect(adapter.requestCount, 0);
  });

  test('clears an expired token and returns unauthenticated on 401', () async {
    final user = await AuthRemoteDataSourceImpl(dio).getCurrentUserData();

    expect(user, isNull);
    expect(adapter.requestCount, 1);
    expect(preferences.getString('token'), isNull);
  });
}
