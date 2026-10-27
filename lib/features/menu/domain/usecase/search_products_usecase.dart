import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/domain/repo/menu_repository_interface.dart';
import 'package:injectable/injectable.dart';

final class SearchProductsParams {
  final String query;
  final List<ProductEntity>? products;

  const SearchProductsParams({
    required this.query,
    this.products,
  });
}

@lazySingleton
class SearchProductsUseCase
    implements UseCase<Result<List<ProductEntity>>, SearchProductsParams> {
  final MenuRepositoryInterface _repository;

  const SearchProductsUseCase(this._repository);

  @override
  Future<Result<List<ProductEntity>>> call(
    SearchProductsParams params,
  ) async {
    final query = params.query.trim().toLowerCase();

    // Perform client-side filter on cached product list if provided
    if (params.products != null) {
      if (query.isEmpty) {
        return Success(params.products!);
      }

      final filtered = params.products!.where((product) {
        final nameMatches = product.name.toLowerCase().contains(query);
        final descMatches = product.description.toLowerCase().contains(query);
        return nameMatches || descMatches;
      }).toList();

      return Success(filtered);
    }

    // Fallback to repository search if no cached product list is provided
    return _repository.searchProducts(params.query);
  }
}
