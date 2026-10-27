import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/menu/data/data_source/menu_remote_data_source_interface.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/domain/repo/menu_repository_interface.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: MenuRepositoryInterface)
class MenuRepositoryImpl implements MenuRepositoryInterface {
  final MenuRemoteDataSource _remoteDataSource;

  MenuRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<CategoryEntity>>> getCategories() async {
    try {
      final responseModel = await _remoteDataSource.getCategories();
      return Success(responseModel.toEntity());
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getProducts({String? categoryId}) async {
    try {
      final productsModel =
          await _remoteDataSource.getProducts(categoryId: categoryId);
      return Success(productsModel.toEntity().items);
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ProductEntity>> getProductById(String id) async {
    try {
      final item = await _remoteDataSource.getProductById(id);
      return Success(item.toEntity());
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ProductEntity>>> searchProducts(String query) async {
    try {
      final productsModel = await _remoteDataSource.searchProducts(query);
      return Success(productsModel.toEntity().items);
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
