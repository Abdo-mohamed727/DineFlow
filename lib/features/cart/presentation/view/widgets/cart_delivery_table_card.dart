import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/order_type_selector_sheet.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartDeliveryTableCard extends StatelessWidget {
  const CartDeliveryTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final selection = state.selection;
        final orderType = selection?.orderType;
        final selectedTableId = selection?.selectedTableId;
        final tables = selection?.tables ?? const [];

        String titleText = 'Choose order type';
        var icon = Icons.shopping_bag_outlined;
        if (orderType == OrderType.takeaway) {
          titleText = 'Takeaway Order';
        } else if (orderType == OrderType.dineIn) {
          final tableObj = tables.cast<dynamic>().firstWhere(
            (t) => t.id == selectedTableId,
            orElse: () => null,
          );
          final tableName = tableObj != null
              ? tableObj.name
              : (selectedTableId ?? 'Table');
          titleText = 'Deliver to $tableName';
          icon = Icons.table_restaurant_outlined;
        }

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryContainer, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      orderType == null
                          ? 'Select takeaway or dine-in to continue'
                          : 'Estimated prep time: ~15-20 mins',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  final checkoutCubit = context.read<CheckoutCubit>();
                  OrderTypeSelectorSheet.show(context, checkoutCubit);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: AppColors.primaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
