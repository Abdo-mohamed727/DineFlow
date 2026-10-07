import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
class GetPendingRequestsUseCase
    implements UseCase<Result<WaiterRequestsPageEntity>, NoParams> {
  final WaiterRepository _repository;

  const GetPendingRequestsUseCase(this._repository);

  @override
  Future<Result<WaiterRequestsPageEntity>> call(NoParams params) {
    return _repository.getPendingRequests();
  }
}