import 'package:dineflow/features/waiter/data/data_source/waiter_data_source_interface.dart';
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
      ApiConstants.pendingRequests,
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
      ApiConstants.acceptRequest(requestId),
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
      ApiConstants.completeRequest(requestId),
    );

    return WaiterRequestModel.fromJson(
      response.data['data']['request'],
    );
  }
}