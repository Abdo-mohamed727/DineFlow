import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/tables_entity.dart';

import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetAvailableWaiterTablesUseCase
    implements UseCase<Result<TablesEntity>, NoParams> {
  final WaiterRepository _repository;

  const GetAvailableWaiterTablesUseCase(this._repository);

  @override
  Future<Result<TablesEntity>> call(NoParams params) {
    return _repository.getAvailableTables();
  }
}