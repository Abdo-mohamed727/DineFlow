import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Order placed',
      role: AppRole.customer,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 88,
              color: Color(0xFF22C55E),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order created successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              order.id.isEmpty
                  ? 'Your order is being prepared.'
                  : 'Order #${order.id}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            AppPrimaryButton(
              text: 'Back to menu',
              onPressed: () => context.goNamed(AppRoutes.customerMenu),
            ),
          ],
        ),
      ),
    );
  }
}
