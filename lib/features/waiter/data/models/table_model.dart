
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';

class TableModel {
  final String id;
  final int tableNumber;

  const TableModel({
    required this.id,
    required this.tableNumber,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? '',
      tableNumber: json['tableNumber'] ?? 0,
    );
  }

  TableEntity toEntity() {
    return TableEntity(
      id: id,
      tableNumber: tableNumber,
    );
  }
}