import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/cart/data/data_source/cart_remote_data_source_interface.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/cart/domain/repo/cart_repository_interface.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRepositoryInterface)
class CartRepositoryImpl implements CartRepositoryInterface {
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<CartEntity>> getCart() {
    return _guard(() async {
      final model = await _remoteDataSource.getCart();
      return model.toEntity();
    });
  }

  @override
  Future<Result<CartEntity>> addItem({
    required String productId,
    required int quantity,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.addItem(
        productId: productId,
        quantity: quantity,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<CartEntity>> updateItem({
    required String productId,
    required int quantity,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.updateItem(
        productId: productId,
        quantity: quantity,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<CartEntity>> removeItem(String productId) {
    return _guard(() async {
      final model = await _remoteDataSource.removeItem(productId);
      return model.toEntity();
    });
  }

  @override
  Future<Result<CartEntity>> clearCart() {
    return _guard(() async {
      final model = await _remoteDataSource.clearCart();
      return model.toEntity();
    });
  }

  Future<Result<CartEntity>> _guard(
    Future<CartEntity> Function() action,
  ) async {
    try {
      return Success(await action());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
