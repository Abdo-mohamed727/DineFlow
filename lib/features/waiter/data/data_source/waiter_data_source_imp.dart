import 'package:dineflow/features/waiter/data/models/order_model.dart';
import 'package:dineflow/features/waiter/data/data_source/waiter_data_source_interface.dart';
import 'package:dineflow/features/waiter/data/models/create_order_model.dart';
import 'package:dineflow/features/waiter/data/models/orders_page_model.dart';
import 'package:dineflow/features/waiter/data/models/table_model.dart';
import 'package:dineflow/features/waiter/data/models/tables_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:dineflow/core/networking/api_constants.dart';

import '../models/waiter_request_model.dart';
import '../models/waiter_request_page_model.dart';

@Injectable(as: WaiterDataSource)
class WaiterDataSourceImpl implements WaiterDataSource {
  final Dio dio;

  WaiterDataSourceImpl(this.dio);

  @override
  Future<WaiterRequestsPageModel> getPendingRequests() async {
    final response = await dio.get(
      ApiConstants.waiterRequests,
      queryParameters: {'status': 'pending'},
    );

    return WaiterRequestsPageModel.fromJson(response.data['data']);
  }

  @override
  Future<WaiterRequestModel> acceptRequest(String requestId) async {
    final response = await dio.patch(
      ApiConstants.updateWaiterRequestStatus(requestId),
      data: {'status': 'accepted'},
    );

    return WaiterRequestModel.fromJson(response.data['data']['request']);
  }

  @override
  Future<WaiterRequestModel> completeRequest(String requestId) async {
    final response = await dio.patch(
      ApiConstants.updateWaiterRequestStatus(requestId),
      data: {'status': 'completed'},
    );

    return WaiterRequestModel.fromJson(response.data['data']['request']);
  }

  @override
  Future<CreateOrderModel> createDineOrder(
    String diningSessionId,
    List<Map<String, dynamic>> items,
    String? notes,
  ) async {
    final response = await dio.post(
      ApiConstants.createOrder,
      data: {
        'orderType': 'DINE_IN',
        'diningSessionId': diningSessionId,
        'items': items,
        'notes': notes,
      },
    );

    return CreateOrderModel.fromJson(response.data['data']);
  }

  @override
  Future<CreateOrderModel> createTakeAwayOrder(
    List<Map<String, dynamic>> items,
  ) async {
    final response = await dio.post(
      ApiConstants.createOrder,
      data: {'orderType': 'TAKEAWAY', 'items': items},
    );

    return CreateOrderModel.fromJson(response.data['data']);
  }

  @override
  Future<OrdersPageModel> getOrders() async {
    final response = await dio.get(ApiConstants.orders);

    return OrdersPageModel.fromJson(response.data['data']);
  }

  @override
  Future<OrdersPageModel> getOrdersByStatus(String status) async {
    final response = await dio.get(
      ApiConstants.orders,
      queryParameters: {'status': status},
    );

    return OrdersPageModel.fromJson(response.data['data']);
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    final response = await dio.get('${ApiConstants.orders}/$orderId');

    return OrderModel.fromJson(response.data['data']['order']);
  }

  @override
  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    final response = await dio.patch(
      '${ApiConstants.orders}/$orderId/status',
      data: {'status': status},
    );

    return OrderModel.fromJson(response.data['data']['order']);
  }

  @override
  Future<TablesModel> getTables() async {
    final response = await dio.get(ApiConstants.tables);

    return TablesModel.fromJson(response.data['data']);
  }

  @override
  Future<TablesModel> getAvailableTables() async {
    final response = await dio.get(
      ApiConstants.tables,
      queryParameters: {'status': 'available'},
    );

    return TablesModel.fromJson(response.data['data']);
  }

  @override
  Future<TableModel> getTableById(String tableId) async {
    final response = await dio.get('${ApiConstants.tables}/$tableId');

    return TableModel.fromJson(response.data['data']['table']);
  }

  @override
  Future<TableModel> updateTable(String tableId, String status) async {
    final response = await dio.patch(
      '${ApiConstants.tables}/$tableId',
      data: {'status': status},
    );

    return TableModel.fromJson(response.data['data']['table']);
  }
}
