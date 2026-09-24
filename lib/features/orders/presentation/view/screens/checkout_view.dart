import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Order Review',
      role: AppRole.customer,
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (order) {
              context.read<CartCubit>().getCart(silent: true);
              context.goNamed(AppRoutes.customerOrderSuccess, extra: order);
            },
          );
        },
        builder: (context, state) {
          final selection = state.selection;
          if (selection == null) return const SizedBox.shrink();

          final isPlacingOrder = selection.isPlacingOrder;
          final errorMessage = state.errorMessage;
          final isDineIn = selection.orderType == OrderType.dineIn;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              // ── Order type ────────────────────────────────────────────
              _ReviewRow(
                icon: isDineIn
                    ? Icons.table_restaurant_outlined
                    : Icons.shopping_bag_outlined,
                label: 'Order Type',
                value: selection.orderType?.label ?? 'Not selected',
              ),

              // ── Table & session (DINE_IN only) ────────────────────────
              if (isDineIn) ...[
                const SizedBox(height: 12),
                _ReviewRow(
                  icon: Icons.chair_outlined,
                  label: 'Table',
                  value: selection.tableName ??
                      selection.selectedTableId ??
                      'Not selected',
                ),
                const SizedBox(height: 12),
                _ReviewRow(
                  icon: Icons.check_circle_outline,
                  label: 'Dining Session',
                  value: selection.sessionId != null &&
                          selection.sessionId!.isNotEmpty
                      ? 'Active ✓'
                      : 'Not started',
                  valueColor: selection.sessionId != null &&
                          selection.sessionId!.isNotEmpty
                      ? Colors.greenAccent.shade400
                      : AppColors.error,
                ),
              ],

              // ── Error ─────────────────────────────────────────────────
              if (errorMessage != null && errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 32),

              // ── Place Order ───────────────────────────────────────────
              AppPrimaryButton(
                text: 'Place Order',
                isLoading: isPlacingOrder,
                onPressed: isPlacingOrder
                    ? null
                    : () => context.read<CheckoutCubit>().placeOrder(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryContainer, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
