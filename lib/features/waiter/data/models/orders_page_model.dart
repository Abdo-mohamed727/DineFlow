import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';

import 'order_model.dart';

class OrdersPageModel {
  final List<OrderModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const OrdersPageModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory OrdersPageModel.fromJson(Map<String, dynamic> json) {
    return OrdersPageModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderModel.fromJson(
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

  OrdersPageEntity toEntity() {
    return OrdersPageEntity(
      items: items.map((item) => item.toEntity()).toList(),
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}