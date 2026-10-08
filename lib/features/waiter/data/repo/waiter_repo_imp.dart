import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/data/data_source/waiter_data_source_interface.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WaiterRepository)
class WaiterRepositoryImpl implements WaiterRepository {
  final WaiterDataSource dataSource;

  WaiterRepositoryImpl(this.dataSource);

  @override
  Future<Result<WaiterRequestsPageEntity>> getPendingRequests() async {
    try {
      final model = await dataSource.getPendingRequests();

      return Success(model.toEntity());
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<WaiterRequestEntity>> acceptRequest(String requestId) async {
    try {
      final model = await dataSource.acceptRequest(requestId);

      return Success(model.toEntity());
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<WaiterRequestEntity>> completeRequest(String requestId) async {
    try {
      final model = await dataSource.completeRequest(requestId);

      return Success(model.toEntity());
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<CreateOrderEntity>> createDineOrder(
    CreateDineOrderParams params,
  ) async {
    try {
      final model = await dataSource.createDineOrder(
        params.diningSessionId,
        params.items
            .map(
              (item) => {
                'productId': item.productId,
                'quantity': item.quantity,
              },
            )
            .toList(),
        params.notes,
      );

      return Success(model.toEntity());
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    }
  }

  Future<Result<CreateOrderEntity>> createTakeAwayOrder(
    CreateTakeAwayOrderParams params,
  ) async {
    try {
      final model = await dataSource.createTakeAwayOrder(
        params.items
            .map(
              (item) => {
                'productId': item.productId,
                'quantity': item.quantity,
              },
            )
            .toList(),
      );

      return Success(model.toEntity());
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<OrdersPageEntity>> getOrders() async {
    try {
      final model = await dataSource.getOrders();

      return Success(model.toEntity());
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<OrdersPageEntity>> getOrdersByStatus(String status) async {
    try {
      final model = await dataSource.getOrdersByStatus(status);

      return Success(model.toEntity());
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(AppException exception) {
    return switch (exception) {
      ServerException() => ServerFailure(exception.message),
      NetworkException() => NetworkFailure(exception.message),
      AuthException() => AuthFailure(exception.message),
      CacheException() => CacheFailure(exception.message),
      NotFoundException() => NotFoundFailure(exception.message),
      _ => ServerFailure(exception.message),
    };
  }
}
