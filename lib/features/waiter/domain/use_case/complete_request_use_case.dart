import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:dineflow/features/waiter/domain/use_case/request_id_params.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class CompleteRequestUseCase
    implements UseCase<Result<WaiterRequestEntity>, RequestIdParams> {
  final WaiterRepository _repository;

  const CompleteRequestUseCase(this._repository);

  @override
  Future<Result<WaiterRequestEntity>> call(RequestIdParams params) {
    return _repository.completeRequest(params.requestId);
  }
}