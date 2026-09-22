import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Checkout',
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
          return state.when(
            success: (_) => const SizedBox.shrink(),
            initial:
                (
                  orderType,
                  selectedTableId,
                  tables,
                  isLoadingTables,
                  isPlacingOrder,
                  errorMessage,
                ) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    children: [
                      Text(
                        'Order Type',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _OrderTypeTile(
                        type: OrderType.takeaway,
                        selected: orderType == OrderType.takeaway,
                        onTap: () => context
                            .read<CheckoutCubit>()
                            .selectOrderType(OrderType.takeaway),
                      ),
                      const SizedBox(height: 10),
                      _OrderTypeTile(
                        type: OrderType.dineIn,
                        selected: orderType == OrderType.dineIn,
                        onTap: () => context
                            .read<CheckoutCubit>()
                            .selectOrderType(OrderType.dineIn),
                      ),
                      if (orderType == OrderType.dineIn) ...[
                        const SizedBox(height: 28),
                        Text(
                          'Choose a table',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        if (isLoadingTables)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (tables.isEmpty)
                          const Text(
                            'No tables are available right now.',
                            style: TextStyle(color: AppColors.onSurfaceVariant),
                          )
                        else
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: tables
                                .map(
                                  (table) => _TableChip(
                                    table: table,
                                    selected: selectedTableId == table.id,
                                    onTap: () => context
                                        .read<CheckoutCubit>()
                                        .selectTable(table.id),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                      if (errorMessage != null && errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          errorMessage,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ],
                      const SizedBox(height: 32),
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
          );
        },
      ),
    );
  }
}

class _OrderTypeTile extends StatelessWidget {
  const _OrderTypeTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final OrderType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryContainer.withValues(alpha: 0.16)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerHigh,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Icon(type.iconData, color: AppColors.onSurface),
            const SizedBox(width: 10),
            Text(
              type.label.toUpperCase().replaceAll('-', '_'),
              style: const TextStyle(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableChip extends StatelessWidget {
  const _TableChip({
    required this.table,
    required this.selected,
    required this.onTap,
  });

  final RestaurantTableEntity table;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final infoParts = <String>[];
    if (table.capacity.isNotEmpty) infoParts.add(table.capacity);
    if (table.location != null && table.location!.isNotEmpty) {
      infoParts.add(table.location!);
    }

    final labelText = infoParts.isNotEmpty
        ? '${table.displayName} • ${infoParts.join(' • ')}'
        : table.displayName;

    return ChoiceChip(
      label: Text(labelText),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryContainer,
      backgroundColor: AppColors.surfaceContainerHigh,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
