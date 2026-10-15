import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_impl.dart';
import 'package:dineflow/features/orders/data/models/request_waiter_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'sends waiter request tableId as a string in the flat payload',
    () async {
      const tableId = '6aabb9dd0bc9e678caf651b8';
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      Map<String, dynamic>? sentBody;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            sentBody = Map<String, dynamic>.from(options.data as Map);
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'data': {
                    'request': {
                      'tableId': tableId,
                      'diningSessionId': '6ad0bdf2da8eb27d4bdd8d08',
                      'type': 'CALL_WAITER',
                      'message': 'Please send a waiter to our table.',
                    },
                  },
                },
              ),
            );
          },
        ),
      );
      final dataSource = OrderRemoteDataSourceImpl(dio);
      final request = RequestModel(
        data: Data(
          request: RequestData(
            tableId: tableId,
            type: 'CALL_WAITER',
            message: 'Please send a waiter to our table.',
          ),
        ),
      );

      await dataSource.requestWaiter(
        request,
        diningSessionId: '6ad0bdf2da8eb27d4bdd8d08',
      );

      expect(sentBody, {
        'diningSessionId': '6ad0bdf2da8eb27d4bdd8d08',
        'type': 'CALL_WAITER',
        'tableId': tableId,
        'message': 'Please send a waiter to our table.',
      });
      expect(sentBody!['tableId'], isA<String>());
    },
  );
}
