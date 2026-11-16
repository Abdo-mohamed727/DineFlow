import 'package:dineflow/features/orders/domain/entity/order_entity.dart';

enum CreateOrderDisposition { synced, pending, failed }

class CreateOrderOutcome {
  const CreateOrderOutcome({
    required this.clientOrderId,
    required this.disposition,
    this.order,
    this.message,
  });

  final String clientOrderId;
  final CreateOrderDisposition disposition;
  final OrderEntity? order;
  final String? message;
}
