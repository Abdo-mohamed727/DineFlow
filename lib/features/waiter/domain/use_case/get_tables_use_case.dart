import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/tables_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTablesUseCase
    implements UseCase<Result<TablesEntity>, NoParams> {
  final WaiterRepository _repository;

  const GetTablesUseCase(this._repository);

  @override
  Future<Result<TablesEntity>> call(NoParams params) {
    return _repository.getTables();
  }
}