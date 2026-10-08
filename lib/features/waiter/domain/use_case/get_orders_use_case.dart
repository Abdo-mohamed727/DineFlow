import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class GetOrdersUseCase implements UseCase<Result<OrdersPageEntity>, NoParams> {
  final WaiterRepository _repository;

  const GetOrdersUseCase(this._repository);

  @override
  Future<Result<OrdersPageEntity>> call(NoParams params) {
    return _repository.getOrders();
  }
}
