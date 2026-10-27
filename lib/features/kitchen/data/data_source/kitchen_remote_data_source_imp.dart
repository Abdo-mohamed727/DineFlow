import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/core/networking/api_error_handler.dart';
import 'package:dineflow/features/kitchen/data/data_source/kitchen_remote_data_source_interface.dart';
import 'package:dineflow/features/orders/data/models/order_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: KitchenRemoteDataSourceInterface)
class KitchenRemoteDataSourceImpl implements KitchenRemoteDataSourceInterface {
  final Dio _dio;

  KitchenRemoteDataSourceImpl(this._dio);

  @override
  Future<OrderModel> confirmOrder(String id) async {
    try {
      final response = await _dio.patch(ApiConstants.updateOrder(id), data: {
          'status': 'confirmed',
      });
      return OrderModel.fromJson(response.data['data']['order']);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Failed to confirm order. Please try again.',
      );
    }
  }

  @override
  Future<OrderModel> markReady(String id) async {
    try {
      final response = await _dio.patch(ApiConstants.updateOrder(id),
      data: {
         'status': 'ready',
      }
      );
      return OrderModel.fromJson(response.data['data']['order']);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Failed to mark order as ready. Please try again.',
      );
    }
  }

  @override
  Future<OrderModel> startPreparing(String id) async {
    try {
      final response = await _dio.patch(ApiConstants.updateOrder(id),
      data: {
         'status': 'preparing',
      }
      );
      return OrderModel.fromJson(response.data['data']['order']);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Failed to start preparing order. Please try again.',
      );
    }
  }
}
