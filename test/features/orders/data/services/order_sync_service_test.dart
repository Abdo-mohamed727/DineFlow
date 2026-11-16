import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/data/models/order_request.dart';
import 'package:dineflow/features/orders/data/services/order_sync_service.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_params.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dineflow/features/orders/domain/entity/request_waiter_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class _OrderRepository implements OrderRepositoryInterface {
  final List<PendingOrder> orders = [];
  final List<CreateOrderRequest> requests = [];
  final List<Result<OrderEntity>> responses = [];
  final Set<String> createdKeys = {};
  final Map<String, int> creationCounts = {};
  Completer<Result<OrderEntity>>? pendingResult;

  @override
  Future<void> addPendingOrder(PendingOrder order) async {
    if (!orders.any((item) => item.clientOrderId == order.clientOrderId)) {
      orders.add(order);
    }
  }

  @override
  Future<void> deletePendingOrder(String clientOrderId) async {
    orders.removeWhere((order) => order.clientOrderId == clientOrderId);
  }

  @override
  Future<List<PendingOrder>> getPendingOrders() async =>
      List.of(orders)
        ..sort((first, second) => first.createdAt.compareTo(second.createdAt));

  @override
  Future<void> updatePendingOrderStatus(
    String clientOrderId,
    PendingOrderStatus status, {
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  }) async {
    final index = orders.indexWhere(
      (order) => order.clientOrderId == clientOrderId,
    );
    if (index < 0) throw StateError('Order $clientOrderId was not found.');
    orders[index] = orders[index].copyWith(
      status: status,
      retryCount: retryCount,
      lastError: lastError,
      clearLastError: clearLastError,
    );
  }

  @override
  Future<Result<OrderEntity>> sendPendingOrder(PendingOrder order) {
    final requestPayload = Map<String, dynamic>.from(order.payload)
      ..['clientOrderId'] = order.clientOrderId;
    final request = CreateOrderRequest.fromJson(requestPayload);
    requests.add(request);

    final pending = pendingResult;
    if (pending != null) return pending.future;
    if (responses.isNotEmpty) {
      return Future.value(responses.removeAt(0));
    }
    if (createdKeys.add(order.clientOrderId)) {
      creationCounts.update(
        order.clientOrderId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    return Future.value(
      Success(
        OrderEntity(
          id: 'server-${order.clientOrderId}',
          orderType: request.orderType,
          status: OrderStatus.pending,
        ),
      ),
    );
  }

  @override
  Future<Result<OrderEntity>> createTakeAwayOrder(
    CreateOrderParams params,
  ) async => const FailureResult(ServerFailure('Not used in this test'));

  @override
  Future<Result<OrderEntity>> createDineInOrder(
    CreateOrderParams params,
  ) async => const FailureResult(ServerFailure('Not used in this test'));

  @override
  Future<Result<List<OrderEntity>>> getOrders() async => const Success([]);

  @override
  Future<Result<List<RestaurantTableEntity>>> getAvailableTables() async =>
      const Success([]);

  @override
  Future<Result<SessionId>> startDining(String tableId) async =>
      const Success('session');

  @override
  Future<Result<List<DiningSessionEntity>>> getActiveDiningSessions() async =>
      const Success([]);

  @override
  Future<Result<DiningSessionEntity>> closeDiningSession(
    String sessionId,
  ) async => const Success(
    DiningSessionEntity(id: 'session', tableId: 'table', status: 'closed'),
  );

  @override
  Future<Result<RequestWaiterEntity>> requestWaiter(
    RequestWaiterEntity request, {
    required String diningSessionId,
  }) async => FailureResult(const ServerFailure('Not used in this test'));
}

void main() {
  late _OrderRepository repository;
  late List<Duration> delays;

  setUp(() {
    repository = _OrderRepository();
    delays = [];
  });

  OrderSyncService createService({
    Stream<List<ConnectivityResult>>? connectivityChanges,
    Future<List<ConnectivityResult>> Function()? checkConnectivity,
  }) {
    return OrderSyncService(
      repository,
      connectivityChanges: connectivityChanges,
      checkConnectivity: checkConnectivity,
      delay: (duration) async => delays.add(duration),
    );
  }

  PendingOrder order(
    String id, {
    int minute = 0,
    PendingOrderStatus status = PendingOrderStatus.pending,
    int retryCount = 0,
  }) {
    return PendingOrder(
      clientOrderId: id,
      payload: {'orderType': 'TAKEAWAY'},
      status: status,
      retryCount: retryCount,
      createdAt: DateTime.utc(2026, 11, 15, 10, minute),
    );
  }

  test('sends multiple queued orders in FIFO order', () async {
    await repository.addPendingOrder(order('third', minute: 3));
    await repository.addPendingOrder(order('first', minute: 1));
    await repository.addPendingOrder(order('second', minute: 2));

    await createService().syncPendingOrders();

    expect(repository.requests.map((request) => request.clientOrderId), [
      'first',
      'second',
      'third',
    ]);
    expect(repository.orders, isEmpty);
  });

  test(
    'restart resets stale sending orders and retries with the same key',
    () async {
      await repository.addPendingOrder(
        order('already-created', status: PendingOrderStatus.sending),
      );
      await repository.addPendingOrder(order('remaining', minute: 1));
      repository.createdKeys.add('already-created');

      await createService().syncPendingOrders();

      expect(repository.requests.map((request) => request.clientOrderId), [
        'already-created',
        'remaining',
      ]);
      expect(repository.createdKeys, {'already-created', 'remaining'});
      expect(repository.creationCounts.values, [1]);
      expect(repository.orders, isEmpty);
    },
  );

  test('a server 200 for an existing order removes the queue entry', () async {
    await repository.addPendingOrder(order('existing'));
    repository.createdKeys.add('existing');
    repository.responses.add(
      const Success(
        OrderEntity(
          id: 'existing-server-order',
          orderType: OrderType.takeaway,
          status: OrderStatus.pending,
        ),
      ),
    );

    await createService().syncPendingOrders();

    expect(repository.requests.single.clientOrderId, 'existing');
    expect(repository.orders, isEmpty);
    expect(repository.createdKeys, {'existing'});
  });

  test('a 4xx marks its order failed without blocking later orders', () async {
    await repository.addPendingOrder(order('invalid'));
    await repository.addPendingOrder(order('valid', minute: 1));
    repository.responses.addAll([
      const FailureResult(ServerFailure('Invalid order', statusCode: 422)),
      const Success(
        OrderEntity(
          id: 'valid-server-order',
          orderType: OrderType.takeaway,
          status: OrderStatus.pending,
        ),
      ),
    ]);

    await createService().syncPendingOrders();

    expect(repository.requests.map((request) => request.clientOrderId), [
      'invalid',
      'valid',
    ]);
    expect(repository.orders, hasLength(1));
    expect(repository.orders.single.clientOrderId, 'invalid');
    expect(repository.orders.single.status, PendingOrderStatus.failed);
    expect(repository.orders.single.lastError, 'Invalid order');
  });

  test(
    '5xx responses back off exponentially and fail after the retry limit',
    () async {
      await repository.addPendingOrder(order('unavailable'));
      await repository.addPendingOrder(order('next', minute: 1));
      repository.responses.addAll([
        for (var attempt = 0; attempt < 5; attempt++)
          const FailureResult(ServerFailure('Unavailable', statusCode: 503)),
        const Success(
          OrderEntity(
            id: 'next-server-order',
            orderType: OrderType.takeaway,
            status: OrderStatus.pending,
          ),
        ),
      ]);

      await createService().syncPendingOrders();

      expect(repository.requests, hasLength(6));
      expect(delays, const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 4),
        Duration(seconds: 8),
      ]);
      final failedOrder = repository.orders.single;
      expect(failedOrder.clientOrderId, 'unavailable');
      expect(failedOrder.status, PendingOrderStatus.failed);
      expect(failedOrder.retryCount, 5);
    },
  );

  test('429 responses use backoff and eventually continue the queue', () async {
    await repository.addPendingOrder(order('rate-limited'));
    await repository.addPendingOrder(order('next', minute: 1));
    repository.responses.addAll([
      const FailureResult(ServerFailure('Rate limited', statusCode: 429)),
      const Success(
        OrderEntity(
          id: 'rate-limited-server-order',
          orderType: OrderType.takeaway,
          status: OrderStatus.pending,
        ),
      ),
      const Success(
        OrderEntity(
          id: 'next-server-order',
          orderType: OrderType.takeaway,
          status: OrderStatus.pending,
        ),
      ),
    ]);

    await createService().syncPendingOrders();

    expect(delays, const [Duration(seconds: 1)]);
    expect(repository.orders, isEmpty);
  });

  test('concurrent sync triggers share one in-flight request', () async {
    await repository.addPendingOrder(order('single'));
    final pendingResult = Completer<Result<OrderEntity>>();
    repository.pendingResult = pendingResult;

    final service = createService();
    final firstSync = service.syncPendingOrders();
    await Future<void>.delayed(Duration.zero);
    final secondSync = service.syncPendingOrders();

    expect(repository.requests, hasLength(1));
    pendingResult.complete(
      const Success(
        OrderEntity(
          id: 'server-order',
          orderType: OrderType.takeaway,
          status: OrderStatus.pending,
        ),
      ),
    );
    await Future.wait([firstSync, secondSync]);

    expect(repository.requests, hasLength(1));
    expect(repository.orders, isEmpty);
  });

  test('syncs queued orders when the app launches online', () async {
    await repository.addPendingOrder(order('startup-online'));
    final service = createService(
      connectivityChanges: const Stream.empty(),
      checkConnectivity: () async => [ConnectivityResult.wifi],
    );

    await service.start();
    await service.syncPendingOrders();

    expect(repository.requests.map((request) => request.clientOrderId), [
      'startup-online',
    ]);
    expect(repository.orders, isEmpty);
    await service.stop();
  });

  test('startup resets stale sending entries even while offline', () async {
    await repository.addPendingOrder(
      order('interrupted', status: PendingOrderStatus.sending),
    );
    final service = createService(
      connectivityChanges: const Stream.empty(),
      checkConnectivity: () async => [ConnectivityResult.none],
    );

    await service.start();

    expect(repository.requests, isEmpty);
    expect(repository.orders.single.status, PendingOrderStatus.pending);
    await service.stop();
  });

  test('syncs queued orders when connectivity returns', () async {
    final changes = StreamController<List<ConnectivityResult>>();
    var network = <ConnectivityResult>[ConnectivityResult.none];
    final service = createService(
      connectivityChanges: changes.stream,
      checkConnectivity: () async => network,
    );
    await repository.addPendingOrder(order('startup'));

    await service.start();
    expect(repository.requests, isEmpty);

    network = [ConnectivityResult.wifi];
    changes.add(network);
    await Future<void>.delayed(Duration.zero);
    await service.syncPendingOrders();

    expect(repository.requests.map((request) => request.clientOrderId), [
      'startup',
    ]);
    expect(repository.orders, isEmpty);

    await service.stop();
    await changes.close();
  });
}
