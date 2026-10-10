import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';

import 'package:injectable/injectable.dart';

import 'update_table_params.dart';

@lazySingleton
class UpdateTableUseCase
    implements UseCase<Result<TableEntity>, UpdateTableParams> {
  final WaiterRepository _repository;

  const UpdateTableUseCase(this._repository);

  @override
  Future<Result<TableEntity>> call(UpdateTableParams params) {
    return _repository.updateTable(params.tableId, params.status);
  }
}
