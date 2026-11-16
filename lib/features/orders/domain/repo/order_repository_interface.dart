import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_params.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dineflow/features/orders/domain/entity/request_waiter_entity.dart';

abstract interface class OrderRepositoryInterface {
  Future<Result<List<OrderEntity>>> getOrders();

  Future<Result<OrderEntity>> createTakeAwayOrder(CreateOrderParams params);

  Future<Result<OrderEntity>> createDineInOrder(CreateOrderParams params);

  Future<Result<OrderEntity>> sendPendingOrder(PendingOrder order);

  Future<List<PendingOrder>> getPendingOrders();

  Future<void> addPendingOrder(PendingOrder order);

  Future<void> updatePendingOrderStatus(
    String clientOrderId,
    PendingOrderStatus status, {
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  });

  Future<void> deletePendingOrder(String clientOrderId);

  Future<Result<List<RestaurantTableEntity>>> getAvailableTables();

  Future<Result<SessionId>> startDining(String tableId);

  Future<Result<List<DiningSessionEntity>>> getActiveDiningSessions();

  Future<Result<DiningSessionEntity>> closeDiningSession(String sessionId);

  Future<Result<RequestWaiterEntity>> requestWaiter(
    RequestWaiterEntity request, {
    required String diningSessionId,
  });
}
