import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_impl.dart';
import 'package:dineflow/features/orders/data/models/order_request.dart';
import 'package:dineflow/features/orders/data/models/request_waiter_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sends the idempotency key as a header for takeaway orders', () async {
    const idempotencyKey = '0d69fcb5-b792-48c6-a2fc-bbc6e6f4a8f3';
    Map<String, dynamic>? sentBody;
    Map<String, dynamic>? sentHeaders;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          sentBody = Map<String, dynamic>.from(options.data as Map);
          sentHeaders = Map<String, dynamic>.from(options.headers);
          handler.resolve(
            Response(
              requestOptions: options,
              data: {
                'data': {'id': 'order-1', 'status': 'PENDING'},
              },
            ),
          );
        },
      ),
    );

    await OrderRemoteDataSourceImpl(dio).createTakeAwayOrder(
      const CreateOrderRequest.takeaway(),
      idempotencyKey: idempotencyKey,
    );

    expect(sentHeaders!['Idempotency-Key'], idempotencyKey);
    expect(sentBody, {'orderType': 'TAKEAWAY'});
    expect(sentBody, isNot(contains('Idempotency-Key')));
    expect(sentBody, isNot(contains('clientOrderId')));
  });

  test('sends the idempotency key as a header for dine-in orders', () async {
    const idempotencyKey = 'dine-in-order-id';
    const sessionId = '6ad0bdf2da8eb27d4bdd8d08';
    const tableId = '6aabb9dd0bc9e678caf651b8';
    Map<String, dynamic>? sentBody;
    Map<String, dynamic>? sentHeaders;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          sentBody = Map<String, dynamic>.from(options.data as Map);
          sentHeaders = Map<String, dynamic>.from(options.headers);
          handler.resolve(
            Response(
              requestOptions: options,
              data: {
                'data': {'id': 'order-1', 'status': 'PENDING'},
              },
            ),
          );
        },
      ),
    );

    await OrderRemoteDataSourceImpl(dio).createDineInOrder(
      const CreateOrderRequest.dineIn(
        diningSessionId: sessionId,
        tableId: tableId,
      ),
      diningSessionId: sessionId,
      idempotencyKey: idempotencyKey,
    );

    expect(sentHeaders!['Idempotency-Key'], idempotencyKey);
    expect(sentBody, {
      'orderType': 'DINE_IN',
      'diningSessionId': sessionId,
      'tableId': tableId,
    });
    expect(sentBody, isNot(contains('Idempotency-Key')));
    expect(sentBody, isNot(contains('clientOrderId')));
  });

  test('accepts a 201 response when creating an order', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 201,
              data: {
                'data': {'id': 'order-1', 'status': 'PENDING'},
              },
            ),
          );
        },
      ),
    );

    final order = await OrderRemoteDataSourceImpl(dio).createTakeAwayOrder(
      const CreateOrderRequest.takeaway(),
      idempotencyKey: 'takeaway-order-key',
    );

    expect(order.id, 'order-1');
  });

  test(
    'loads active dining sessions from the sessions list response',
    () async {
      const sessionId = '6ad0bdf2da8eb27d4bdd8d08';
      const tableId = '6aabb9dd0bc9e678caf651b8';
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.method, 'GET');
            expect(options.path, '/api/dining-sessions');
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'data': {
                    'sessions': [
                      {
                        'id': sessionId,
                        'tableId': {'id': tableId},
                        'status': 'active',
                      },
                    ],
                  },
                },
              ),
            );
          },
        ),
      );

      final sessions = await OrderRemoteDataSourceImpl(
        dio,
      ).getActiveDiningSessions();

      expect(sessions, hasLength(1));
      expect(sessions.single.id, sessionId);
      expect(sessions.single.tableId, tableId);
      expect(sessions.single.status, 'active');
    },
  );

  test('closes a dining session with a bodyless POST', () async {
    const sessionId = '6ad0bdf2da8eb27d4bdd8d08';
    const tableId = '6aabb9dd0bc9e678caf651b8';
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.method, 'POST');
          expect(options.path, '/api/dining-sessions/$sessionId/close');
          expect(options.data, isNull);
          handler.resolve(
            Response(
              requestOptions: options,
              data: {
                'data': {
                  'session': {
                    'id': sessionId,
                    'tableId': {'id': tableId},
                    'status': 'closed',
                  },
                },
              },
            ),
          );
        },
      ),
    );

    final session = await OrderRemoteDataSourceImpl(
      dio,
    ).closeDiningSession(sessionId);

    expect(session.id, sessionId);
    expect(session.tableId, tableId);
    expect(session.status, 'closed');
  });

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
