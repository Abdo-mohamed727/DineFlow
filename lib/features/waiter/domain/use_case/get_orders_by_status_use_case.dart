import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_orders_by_status_params.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class GetOrdersByStatusUseCase
    implements UseCase<Result<OrdersPageEntity>, GetOrdersByStatusParams> {
  final WaiterRepository _repository;

  const GetOrdersByStatusUseCase(this._repository);

  @override
  Future<Result<OrdersPageEntity>> call(
    GetOrdersByStatusParams params,
  ) {
    return _repository.getOrdersByStatus(params.status);
  }
}