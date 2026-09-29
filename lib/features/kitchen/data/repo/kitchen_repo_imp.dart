
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/kitchen/data/data_source/kitchen_remote_data_source_interface.dart';
import 'package:dineflow/features/kitchen/domain/repo/kitchen_repo_interface.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: KitchenRepoInterface)
class KitchenRepoImp implements KitchenRepoInterface {
  final KitchenRemoteDataSourceInterface _remoteDataSource;

  KitchenRepoImp(this._remoteDataSource);

  @override
  Future<Result<OrderEntity>> confirmOrder(String id) async {
    try {
      final result = await _remoteDataSource.confirmOrder(id);
      return Success(result.toEntity());
    } on Exception catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderEntity>> markReady(String id) async {
    try {
      final result = await _remoteDataSource.markReady(id);
      return Success(result.toEntity());
    } on Exception catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderEntity>> startPreparing(String id) async {
    try {
      final result = await _remoteDataSource.startPreparing(id);
      return Success(result.toEntity());
    } on Exception catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
