import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/data/models/order_request.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';

abstract interface class OrderRepositoryInterface {
  Future<Result<List<OrderEntity>>> getOrders();

  Future<Result<OrderEntity>> createTakeAwayOrder(CreateOrderRequest request);

  Future<Result<OrderEntity>> createDineInOrder(CreateOrderRequest request);

  Future<Result<List<RestaurantTableEntity>>> getAvailableTables();

  Future<Result<SessionId>> startDining(String tableId);
}
