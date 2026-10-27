class TableEntity {
  final String id;
  final int tableNumber;
  final int capacity;
  final String status;
  final String location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TableEntity({
    required this.id,
    required this.tableNumber,
    required this.capacity,
    required this.status,
    required this.location,
    this.createdAt,
    this.updatedAt,
  });
}