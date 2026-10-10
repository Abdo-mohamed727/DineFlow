import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';

class CreateTakeAwayOrderParams {
  final List<OrderItemParams> items;

  const CreateTakeAwayOrderParams({
    required this.items,
  });
}