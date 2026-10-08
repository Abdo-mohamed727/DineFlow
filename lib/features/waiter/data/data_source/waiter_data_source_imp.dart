import 'package:dineflow/features/waiter/data/data_source/waiter_data_source_interface.dart';
import 'package:dineflow/features/waiter/data/models/create_order_model.dart';
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
      queryParameters: {
        'status': 'pending',
      },
    );

    return WaiterRequestsPageModel.fromJson(
      response.data['data'],
    );
  }

  @override
  Future<WaiterRequestModel> acceptRequest(
    String requestId,
  ) async {
    final response = await dio.patch(
      ApiConstants.updateWaiterRequestStatus(requestId),
      data: {
        'status': 'accepted',
      },
    );

    return WaiterRequestModel.fromJson(
      response.data['data']['request'],
    );
  }

  @override
  Future<WaiterRequestModel> completeRequest(
    String requestId,
  ) async {
    final response = await dio.patch(
      ApiConstants.updateWaiterRequestStatus(requestId),
      data: {
        'status': 'completed',
      },
    );

    return WaiterRequestModel.fromJson(
      response.data['data']['request'],
    );
  }

  @override
  Future<CreateOrderModel> createDineOrder(
    String diningSessionId,
    List<Map<String, dynamic>> items,
    String? notes,
  ) async {
    final response = await dio.post(
      ApiConstants.createDineOrder,
      data: {
        'orderType': 'DINE_IN',
        'diningSessionId': diningSessionId,
        'items': items,
        'notes': notes,
      },
    );

    return CreateOrderModel.fromJson(
      response.data['data'],
    );
  }
}