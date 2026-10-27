import 'package:dineflow/features/orders/domain/entity/request_waiter_entity.dart';

class RequestModel {
  Data? data;

  RequestModel({this.data});

  RequestModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  RequestData? request;

  Data({this.request});

  Data.fromJson(Map<String, dynamic> json) {
    request = json['request'] != null
        ? new RequestData.fromJson(json['request'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class RequestData {
  String? customerId;
  String? tableId;
  String? diningSessionId;
  String? type;
  String? status;
  String? message;
  String? id;
  String? createdAt;
  String? updatedAt;

  RequestData({
    this.customerId,
    this.tableId,
    this.diningSessionId,
    this.type,
    this.status,
    this.message,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  RequestData.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    tableId = json['tableId'];
    diningSessionId = json['diningSessionId'];
    type = json['type'];
    status = json['status'];
    message = json['message'];
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['tableId'] = this.tableId;
    data['diningSessionId'] = this.diningSessionId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['message'] = this.message;
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  RequestWaiterEntity toEntity() {
    return RequestWaiterEntity(
      customerId: customerId,
      tableId: tableId,
      diningSessionId: diningSessionId,
      type: type,
      status: status,
      message: message,
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
