import 'package:dineflow/features/waiter/data/models/customer_model.dart';
import 'package:dineflow/features/waiter/data/models/table_model.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';

class WaiterRequestModel {
  final String id;
  final CustomerModel customer;
  final TableModel table;
  final String diningSessionId;
  final String type;
  final String status;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? handledBy;
  final DateTime? handledAt;

  const WaiterRequestModel({
    required this.id,
    required this.customer,
    required this.table,
    required this.diningSessionId,
    required this.type,
    required this.status,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    this.handledBy,
    this.handledAt,
  });

  factory WaiterRequestModel.fromJson(Map<String, dynamic> json) {
    final customerData = json['customerId'];
    final tableData = json['tableId'];

    return WaiterRequestModel(
      id: json['id'] ?? '',
      customer: customerData is Map<String, dynamic>
          ? CustomerModel.fromJson(customerData)
          : CustomerModel(
              id: customerData?.toString() ?? '',
              name: '',
            ),
     table: tableData is Map<String, dynamic>
    ? TableModel.fromJson(tableData)
    : TableModel(
        id: tableData?.toString() ?? '',
        tableNumber: 0,
        capacity: 0,
        status: '',
        location: '',
      ),
      diningSessionId: json['diningSessionId']?.toString() ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      handledBy: json['handledBy']?.toString(),
      handledAt: json['handledAt'] != null
          ? DateTime.parse(json['handledAt'])
          : null,
    );
  }

  WaiterRequestEntity toEntity() {
    return WaiterRequestEntity(
      id: id,
      customer: customer.toEntity(),
      table: table.toEntity()as TableEntity,
      diningSessionId: diningSessionId,
      type: type,
      status: status,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
      handledBy: handledBy,
      handledAt: handledAt,
    );
  }
}