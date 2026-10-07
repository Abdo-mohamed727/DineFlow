import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';

class WaiterRequestsPageEntity {
  final List<WaiterRequestEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const WaiterRequestsPageEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}