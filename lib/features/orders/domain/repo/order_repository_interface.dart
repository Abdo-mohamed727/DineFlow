import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';

abstract interface class OrderRepositoryInterface {
  Future<Result<OrderEntity>> createOrder({
    required String orderType,
    String? tableId,
  });

  Future<Result<List<RestaurantTableEntity>>> getAvailableTables();
}
