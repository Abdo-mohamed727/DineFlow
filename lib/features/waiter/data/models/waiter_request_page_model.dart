import 'package:dineflow/features/waiter/data/models/waiter_request_model.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';

class WaiterRequestsPageModel {
  final List<WaiterRequestModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const WaiterRequestsPageModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory WaiterRequestsPageModel.fromJson(Map<String, dynamic> json) {
    return WaiterRequestsPageModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => WaiterRequestModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 50,
      totalPages: json['totalPages'] ?? 0,
    );
  }
  WaiterRequestsPageEntity toEntity() {
    return WaiterRequestsPageEntity(
      items: items.map((item) => item.toEntity()).toList(),
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}