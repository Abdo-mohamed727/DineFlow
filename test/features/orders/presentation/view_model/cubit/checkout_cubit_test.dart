import 'dart:async';

import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/data/models/order_request.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_params.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dineflow/features/orders/domain/entity/request_waiter_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:dineflow/features/orders/domain/usecase/create_order_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/get_available_tables_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/start_dining_usecase.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

class _OrderRepository implements OrderRepositoryInterface {
  Result<OrderEntity> createResult = const FailureResult(
    NetworkFailure('No connection'),
  );
  Completer<Result<OrderEntity>>? pendingCreateResult;
  final List<CreateOrderRequest> requests = [];
  final List<PendingOrder> pendingOrders = [];

  @override
  Future<void> addPendingOrder(PendingOrder order) async {
    if (!pendingOrders.any(
      (item) => item.clientOrderId == order.clientOrderId,
    )) {
      pendingOrders.add(order);
    }
  }

  @override
  Future<void> deletePendingOrder(String clientOrderId) async {
    pendingOrders.removeWhere((order) => order.clientOrderId == clientOrderId);
  }

  @override
  Future<List<PendingOrder>> getPendingOrders() async => List.of(pendingOrders);

  @override
  Future<void> updatePendingOrderStatus(
    String clientOrderId,
    PendingOrderStatus status, {
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  }) async {
    final index = pendingOrders.indexWhere(
      (order) => order.clientOrderId == clientOrderId,
    );
    if (index < 0) throw StateError('Order $clientOrderId was not found.');
    pendingOrders[index] = pendingOrders[index].copyWith(
      status: status,
      retryCount: retryCount,
      lastError: lastError,
      clearLastError: clearLastError,
    );
  }

  @override
  Future<Result<OrderEntity>> sendPendingOrder(PendingOrder order) {
    requests.add(
      CreateOrderRequest.fromJson({
        ...order.payload,
        'clientOrderId': order.clientOrderId,
      }),
    );
    return pendingCreateResult?.future ?? Future.value(createResult);
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
  late CheckoutCubit cubit;

  setUp(() {
    repository = _OrderRepository();
    cubit = CheckoutCubit(
      CreateOrderUseCase(repository, const Uuid()),
      GetAvailableTablesUseCase(repository),
      StartDiningUseCase(repository),
    );
    cubit.selectOrderType(OrderType.takeaway);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('retrying a pending order reuses its clientOrderId', () async {
    await cubit.placeOrder();
    final firstClientOrderId = repository.requests.single.clientOrderId;
    expect(firstClientOrderId, matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(repository.pendingOrders.single.clientOrderId, firstClientOrderId);

    repository.createResult = const Success(
      OrderEntity(
        id: 'order-1',
        orderType: OrderType.takeaway,
        status: OrderStatus.pending,
      ),
    );
    await cubit.placeOrder();

    expect(repository.requests, hasLength(2));
    expect(
      repository.requests.map((request) => request.clientOrderId).toSet(),
      {firstClientOrderId},
    );
    expect(repository.pendingOrders, isEmpty);
  });

  test('double tap creates one pending entry and sends one request', () async {
    final pendingResult = Completer<Result<OrderEntity>>();
    repository.pendingCreateResult = pendingResult;

    final firstTap = cubit.placeOrder();
    await Future<void>.delayed(Duration.zero);
    await cubit.placeOrder();

    expect(repository.requests, hasLength(1));
    expect(repository.pendingOrders, hasLength(1));

    pendingResult.complete(
      const Success(
        OrderEntity(
          id: 'order-1',
          orderType: OrderType.takeaway,
          status: OrderStatus.pending,
        ),
      ),
    );
    await firstTap;
  });

  test(
    'network errors and timeouts remain pending with the saved message',
    () async {
      await cubit.placeOrder();
      final clientOrderId = repository.requests.single.clientOrderId;
      expect(
        repository.pendingOrders.single.status,
        PendingOrderStatus.pending,
      );
      expect(
        cubit.state.errorMessage,
        'Saved, will send when you\'re back online',
      );

      repository.createResult = const FailureResult(
        NetworkFailure('Connection timeout. Please try again.'),
      );
      await cubit.placeOrder();

      expect(repository.requests, hasLength(2));
      expect(repository.requests.last.clientOrderId, clientOrderId);
      expect(repository.pendingOrders.single.clientOrderId, clientOrderId);
      expect(
        repository.pendingOrders.single.status,
        PendingOrderStatus.pending,
      );
      expect(repository.pendingOrders.single.lastError, isNull);
      expect(
        cubit.state.errorMessage,
        'Saved, will send when you\'re back online',
      );
    },
  );

  test('5xx response remains pending with the saved message', () async {
    repository.createResult = const FailureResult(
      ServerFailure('Server is unavailable.', statusCode: 503),
    );

    await cubit.placeOrder();

    expect(repository.pendingOrders.single.status, PendingOrderStatus.pending);
    expect(
      cubit.state.errorMessage,
      'Saved, will send when you\'re back online',
    );
  });

  test('4xx response marks the order failed and shows its error', () async {
    repository.createResult = const FailureResult(
      ServerFailure('Item unavailable', statusCode: 422),
    );

    await cubit.placeOrder();

    expect(repository.pendingOrders.single.status, PendingOrderStatus.failed);
    expect(repository.pendingOrders.single.lastError, 'Item unavailable');
    expect(cubit.state.errorMessage, 'Item unavailable');
  });

  test('401 without token refresh is treated as a failed order', () async {
    repository.createResult = const FailureResult(
      AuthFailure('Please log in again.', statusCode: 401),
    );

    await cubit.placeOrder();

    expect(repository.requests, hasLength(1));
    expect(repository.pendingOrders.single.status, PendingOrderStatus.failed);
    expect(repository.pendingOrders.single.lastError, 'Please log in again.');
  });
}
