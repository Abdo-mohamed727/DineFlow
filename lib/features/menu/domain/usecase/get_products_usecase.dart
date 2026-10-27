import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/domain/repo/menu_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class GetProductsParams {
  final String? categoryId;

  const GetProductsParams({this.categoryId});
}

@lazySingleton
class GetProductsUseCase
    implements UseCase<Result<List<ProductEntity>>, GetProductsParams> {
  final MenuRepositoryInterface _repository;

  const GetProductsUseCase(this._repository);

  @override
  Future<Result<List<ProductEntity>>> call(GetProductsParams params) {
    return _repository.getProducts(categoryId: params.categoryId);
  }
}
