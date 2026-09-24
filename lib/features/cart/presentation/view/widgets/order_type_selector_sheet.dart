import 'dart:developer';

import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderTypeSelectorSheet extends StatelessWidget {
  const OrderTypeSelectorSheet({super.key});

  static Future<void> show(BuildContext context, CheckoutCubit checkoutCubit) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: checkoutCubit,
        child: const OrderTypeSelectorSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (selection, message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },

              navigateToOrder: (sessionId, orderType, tableId, tableName) {
                log(
                  'SHEET NAVIGATION (Point 3):\n'
                  'orderType=$orderType\n'
                  'tableId=$tableId\n'
                  'sessionId=$sessionId',
                );

                // Close the bottom sheet first.
                Navigator.of(context).pop();

                log(
                  'PUSH ARGUMENTS (Point 4):\n'
                  'sessionId=$sessionId\n'
                  'tableId=$tableId\n'
                  'orderType=$orderType',
                );

                // Then navigate to checkout/order review.
                context.pushNamed(
                  AppRoutes.customerCheckout,
                  extra: OrderNavigationArguments(
                    sessionId: sessionId,
                    orderType: orderType,
                    tableId: tableId,
                    tableName: tableName,
                  ),
                );

                // Reset the cubit NOW — after push — so the navigateToOrder
                // state doesn't linger. This is the ONLY place that resets.
                context.read<CheckoutCubit>().resetAfterNavigation();
              },
            );
          },
          builder: (context, state) {
            final selection = state.selection;
            if (selection == null) return const SizedBox.shrink();

            final orderType = selection.orderType;
            final selectedTableId = selection.selectedTableId;
            final tables = selection.tables;
            final isLoadingTables = selection.isLoadingTables;
            final isConfirmingSelection = state.isConfirmingSelection;
            final canConfirm =
                !isConfirmingSelection &&
                !(orderType == OrderType.dineIn &&
                    (selectedTableId == null || selectedTableId.isEmpty));

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Dining Preference',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _OptionTile(
                        title: 'Takeaway',
                        icon: Icons.shopping_bag_outlined,
                        selected: orderType == OrderType.takeaway,
                        onTap: () => context
                            .read<CheckoutCubit>()
                            .selectOrderType(OrderType.takeaway),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _OptionTile(
                        title: 'Dine-in',
                        icon: Icons.table_restaurant_outlined,
                        selected: orderType == OrderType.dineIn,
                        onTap: () => context
                            .read<CheckoutCubit>()
                            .selectOrderType(OrderType.dineIn),
                      ),
                    ),
                  ],
                ),
                if (orderType == OrderType.dineIn) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Available Tables',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isLoadingTables)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    )
                  else if (tables.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No tables are currently available.',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tables.map((t) {
                        final isSelected = selectedTableId == t.id;
                        final infoParts = <String>[];
                        if (t.capacity.isNotEmpty) infoParts.add(t.capacity);
                        if (t.location != null && t.location!.isNotEmpty) {
                          infoParts.add(t.location!);
                        }
                        final labelText = infoParts.isNotEmpty
                            ? '${t.displayName} • ${infoParts.join(' • ')}'
                            : t.displayName;
                        return ChoiceChip(
                          label: Text(labelText),
                          selected: isSelected,
                          onSelected: (_) =>
                              context.read<CheckoutCubit>().selectTable(t.id),
                          selectedColor: AppColors.primaryContainer,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                ],
                const SizedBox(height: 24),
                AppPrimaryButton(
                  text: 'Confirm Choice',
                  isLoading: isConfirmingSelection,
                  onPressed: canConfirm
                      ? () {
                          if (orderType == OrderType.dineIn) {
                            log("Dine-in selected");
                          }
                          context.read<CheckoutCubit>().confirmSelection();
                        }
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryContainer.withValues(alpha: 0.16)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerHigh,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
