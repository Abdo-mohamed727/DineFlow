import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _dio = Dio();

Dio getdio() {
  const duration = Duration(seconds: 30);

  _dio.options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: duration,
    receiveTimeout: duration,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  _dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = sl<SharedPreferences>();
        final token = prefs.getString('token');

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
    ),
  );

  _dio.interceptors.add(
    PrettyDioLogger(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
    ),
  );

  return _dio;
}