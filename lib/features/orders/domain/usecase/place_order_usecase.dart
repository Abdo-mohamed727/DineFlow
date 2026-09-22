import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class PlaceOrderParams {
  final String orderType;
  final String? tableId;

  const PlaceOrderParams({
    required this.orderType,
    this.tableId,
  });
}

@lazySingleton
class PlaceOrderUseCase
    implements UseCase<Result<OrderEntity>, PlaceOrderParams> {
  final OrderRepositoryInterface _repository;

  const PlaceOrderUseCase(this._repository);

  @override
  Future<Result<OrderEntity>> call(PlaceOrderParams params) {
    return _repository.createOrder(
      orderType: params.orderType,
      tableId: params.tableId,
    );
  }
}
