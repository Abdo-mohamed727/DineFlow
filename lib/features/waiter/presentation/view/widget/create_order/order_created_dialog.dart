import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderCreatedDialog extends StatelessWidget {
  final String orderNumber;

  const OrderCreatedDialog({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: AppColors.surfaceContainer,
    icon: const Icon(
      Icons.check_circle_outline_rounded,
      color: Colors.greenAccent,
      size: 56,
    ),
    title: const Text(
      'Order created successfully',
      textAlign: TextAlign.center,
      style: TextStyle(color: AppColors.onSurface),
    ),
    content: Text(
      orderNumber.isEmpty
          ? 'The order has been created.'
          : 'Order $orderNumber has been created.',
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.onSurfaceVariant),
    ),
    actions: [
      FilledButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Done'),
      ),
    ],
  );
}
