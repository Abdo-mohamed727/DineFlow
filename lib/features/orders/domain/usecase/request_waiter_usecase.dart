import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/domain/entity/request_waiter_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RequestWaiterUseCase
    implements UseCase<Result<RequestWaiterEntity>, RequestWaiterParams> {
  final OrderRepositoryInterface _repository;

  const RequestWaiterUseCase(this._repository);

  @override
  Future<Result<RequestWaiterEntity>> call(RequestWaiterParams params) {
    return _repository.requestWaiter(
      params.request,
      diningSessionId: params.diningSessionId,
    );
  }
}

class RequestWaiterParams {
  final RequestWaiterEntity request;
  final String diningSessionId;

  const RequestWaiterParams({
    required this.request,
    required this.diningSessionId,
  });
}
