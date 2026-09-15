import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/repo/menu_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCategoriesUseCase
    implements UseCase<Result<List<CategoryEntity>>, NoParams> {
  final MenuRepositoryInterface _repository;

  const GetCategoriesUseCase(this._repository);

  @override
  Future<Result<List<CategoryEntity>>> call(NoParams params) {
    return _repository.getCategories();
  }
}
