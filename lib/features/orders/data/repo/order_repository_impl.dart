import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_interface.dart';
import 'package:dineflow/features/orders/data/models/order_model.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepositoryInterface)
class OrderRepositoryImpl implements OrderRepositoryInterface {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<OrderEntity>> createOrder({
    required String orderType,
    String? tableId,
  }) async {
    try {
      final model = await _remoteDataSource.createOrder(
        CreateOrderRequest(orderType: orderType, tableId: tableId),
      );
      return Success(model.toEntity());
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

  @override
  Future<Result<List<RestaurantTableEntity>>> getAvailableTables() async {
    try {
      final models = await _remoteDataSource.getTables();
      final tables = models
          .map((e) => e.toEntity())
          .where((table) => table.isAvailable)
          .toList();
      return Success(tables);
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
