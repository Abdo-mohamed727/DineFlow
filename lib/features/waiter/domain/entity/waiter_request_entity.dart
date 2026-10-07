class WaiterRequestEntity {
  final String id;
  final CustomerEntity customer;
  final TableEntity table;
  final String diningSessionId;
  final String type;
  final String status;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? handledBy;
  final DateTime? handledAt;

  const WaiterRequestEntity({
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
}

class CustomerEntity {
  final String id;
  final String name;

  const CustomerEntity({
    required this.id,
    required this.name,
  });
}

class TableEntity {
  final String id;
  final int tableNumber;

  const TableEntity({
    required this.id,
    required this.tableNumber,
  });
}