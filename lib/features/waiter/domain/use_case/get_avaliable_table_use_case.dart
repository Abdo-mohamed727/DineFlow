import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetAvailableTablesUseCase
    implements UseCase<Result<TableEntity>, NoParams> {
  final WaiterRepository _repository;

  const GetAvailableTablesUseCase(this._repository);

  @override
  Future<Result<TableEntity>> call(NoParams params) {
    return _repository.getAvailableTables();
  }
}