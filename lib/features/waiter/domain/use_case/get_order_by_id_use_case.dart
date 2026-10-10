import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:dineflow/features/waiter/domain/use_case/order_id_params.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class GetOrderByIdUseCase
    implements UseCase<Result<OrderWaiterEntity>, OrderIdParams> {
  final WaiterRepository _repository;

  const GetOrderByIdUseCase(this._repository);

  @override
  Future<Result<OrderWaiterEntity>> call(
    OrderIdParams params,
  ) {
    return _repository.getOrderById(params.orderId);
  }
}