import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';

class TableModel {
  final String id;
  final int tableNumber;
  final int capacity;
  final String status;
  final String location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TableModel({
    required this.id,
    required this.tableNumber,
    required this.capacity,
    required this.status,
    required this.location,
    this.createdAt,
    this.updatedAt,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id']?.toString() ?? '',
      tableNumber: json['tableNumber'] ?? 0,
      capacity: json['capacity'] ?? 0,
      status: json['status']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  TableEntity toEntity() {
    return TableEntity(
      id: id,
      tableNumber: tableNumber,
      capacity: capacity,
      status: status,
      location: location,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}