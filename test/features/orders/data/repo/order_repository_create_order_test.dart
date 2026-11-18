import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_impl.dart';
import 'package:dineflow/features/orders/data/data_source/pending_order_local_data_source_interface.dart';
import 'package:dineflow/features/orders/data/repo/order_repository_impl.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_params.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _PendingOrders implements PendingOrderLocalDataSource {
  final List<PendingOrder> orders = [];

  @override
  Future<void> add(PendingOrder order) async {
    orders.add(order);
  }

  @override
  Future<void> delete(String clientOrderId) async {
    orders.removeWhere((order) => order.clientOrderId == clientOrderId);
  }

  @override
  Future<List<PendingOrder>> getAll() async => List.of(orders);

  @override
  Future<void> recordServerOrderId(
    String clientOrderId,
    String serverOrderId,
  ) async {
    final index = orders.indexWhere(
      (order) => order.clientOrderId == clientOrderId,
    );
    if (index < 0) throw StateError('Order $clientOrderId was not found.');
    orders[index] = orders[index].copyWith(serverOrderId: serverOrderId);
  }

  @override
  Future<void> updateStatus(
    String clientOrderId,
    PendingOrderStatus status, {
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  }) async {}
}

void main() {
  for (final statusCode in [400, 422, 503]) {
    test('preserves HTTP $statusCode when creating an order', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: statusCode,
                  data: {'message': 'Order request rejected'},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );
      final repository = OrderRepositoryImpl(
        OrderRemoteDataSourceImpl(dio),
        _PendingOrders(),
      );

      final result = await repository.createTakeAwayOrder(
        const CreateOrderParams(orderType: OrderType.takeaway),
      );

      expect(result, isA<FailureResult>());
      final failure = (result as FailureResult).failure;
      expect(failure.statusCode, statusCode);
      expect(failure.message, 'Order request rejected');
      expect(failure, isA<ServerFailure>());
    });
  }

  test('preserves 401 status for the checkout failure handler', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 401,
                data: {'message': 'Unauthorized'},
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        },
      ),
    );
    final repository = OrderRepositoryImpl(
      OrderRemoteDataSourceImpl(dio),
      _PendingOrders(),
    );

    final result = await repository.createTakeAwayOrder(
      const CreateOrderParams(orderType: OrderType.takeaway),
    );

    expect(result, isA<FailureResult>());
    final failure = (result as FailureResult).failure;
    expect(failure, isA<AuthFailure>());
    expect(failure.statusCode, 401);
  });

  test('maps request timeouts to a retryable network failure', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.receiveTimeout,
              message: 'request timed out',
            ),
          );
        },
      ),
    );
    final repository = OrderRepositoryImpl(
      OrderRemoteDataSourceImpl(dio),
      _PendingOrders(),
    );

    final result = await repository.createTakeAwayOrder(
      const CreateOrderParams(orderType: OrderType.takeaway),
    );

    expect(result, isA<FailureResult>());
    expect((result as FailureResult).failure, isA<NetworkFailure>());
  });

  for (final orderType in [OrderType.takeaway, OrderType.dineIn]) {
    test(
      'uses the pending order ID as the idempotency key for ${orderType.apiValue} retries',
      () async {
        const clientOrderId = 'c0d8c8a9-241c-42d2-aed2-a8ff74aed215';
        final payload = <String, dynamic>{
          'orderType': orderType.apiValue,
          if (orderType == OrderType.dineIn)
            'diningSessionId': 'dining-session-1',
        };
        final localOrders = _PendingOrders();
        final pendingOrder = PendingOrder(
          clientOrderId: clientOrderId,
          payload: payload,
          createdAt: DateTime.utc(2026, 11, 15),
        );
        await localOrders.add(pendingOrder);
        final sentHeaders = <Map<String, dynamic>>[];
        final sentBodies = <Map<String, dynamic>>[];
        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              sentHeaders.add(Map<String, dynamic>.from(options.headers));
              sentBodies.add(Map<String, dynamic>.from(options.data as Map));
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'data': {'id': 'server-order-1', 'status': 'PENDING'},
                  },
                ),
              );
            },
          ),
        );
        final repository = OrderRepositoryImpl(
          OrderRemoteDataSourceImpl(dio),
          localOrders,
        );

        final firstResult = await repository.sendPendingOrder(pendingOrder);
        final retryResult = await repository.sendPendingOrder(pendingOrder);

        expect(firstResult, isA<Success<OrderEntity>>());
        expect(retryResult, isA<Success<OrderEntity>>());
        expect(sentHeaders.map((headers) => headers['Idempotency-Key']), [
          clientOrderId,
          clientOrderId,
        ]);
        expect(sentBodies, [payload, payload]);
        expect(
          sentBodies.every(
            (body) =>
                !body.containsKey('Idempotency-Key') &&
                !body.containsKey('idempotencyKey') &&
                !body.containsKey('clientOrderId'),
          ),
          isTrue,
        );
        expect(localOrders.orders.single.serverOrderId, 'server-order-1');
      },
    );
  }
}
