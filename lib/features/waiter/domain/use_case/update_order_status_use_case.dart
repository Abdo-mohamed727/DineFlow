import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_order_status_params.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateOrderStatusUseCase
    implements UseCase<Result<OrderWaiterEntity>, UpdateOrderStatusParams> {
  final WaiterRepository _repository;

  const UpdateOrderStatusUseCase(this._repository);

  @override
  Future<Result<OrderWaiterEntity>> call(
    UpdateOrderStatusParams params,
  ) {
    return _repository.updateOrderStatus(
      params.orderId,
      params.status,
    );
  }
}