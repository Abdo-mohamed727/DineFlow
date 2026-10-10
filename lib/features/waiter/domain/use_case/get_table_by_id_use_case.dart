import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:dineflow/features/waiter/domain/use_case/table_id_params.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTableByIdUseCase
    implements UseCase<Result<TableEntity>, TableIdParams> {
  final WaiterRepository _repository;

  const GetTableByIdUseCase(this._repository);

  @override
  Future<Result<TableEntity>> call(TableIdParams params) {
    return _repository.getTableById(params.tableId);
  }
}
