import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_controller.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/order_category_selector.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/order_input_field.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/order_product_card.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/order_type_selector.dart';
import 'package:flutter/material.dart';

class CreateOrderContent extends StatelessWidget {
  final CreateOrderController controller;

  const CreateOrderContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final products = controller.filteredProducts;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        OrderTypeSelector(
          value: controller.orderType,
          onChanged: controller.setOrderType,
        ),
        if (controller.orderType == 'dineIn') ...[
          const SizedBox(height: 16),
          // OrderInputField(
          //   controller: controller.sessionController,
          //   label: 'Dining Session ID',
          //   hint: 'Enter the active dining session ID',
          //   icon: Icons.table_restaurant_outlined,
          // ),
        ],
        // const SizedBox(height: 6),
        OrderInputField(
          controller: controller.searchController,
          label: 'Search products',
          hint: 'Search by product name...',
          icon: Icons.search_rounded,
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 18),
        OrderCategorySelector(
          categories: controller.categories,
          isLoading: controller.isLoadingCategories,
          selectedId: controller.selectedCategoryId,
          onSelected: controller.setCategory,
        ),
        const SizedBox(height: 22),
        _MenuHeading(productCount: products.length),
        const SizedBox(height: 14),
        if (products.isEmpty)
          const _NoProducts()
        else
          ...products.map(
            (product) => OrderProductCard(
              product: product,
              quantity: controller.quantities[product.id] ?? 0,
              onQuantityChanged: (change) =>
                  controller.changeQuantity(product, change),
            ),
          ),
        if (controller.orderType == 'dineIn') ...[
          const SizedBox(height: 16),
          OrderInputField(
            controller: controller.notesController,
            label: 'Order notes (optional)',
            hint: 'Any special instructions...',
            icon: Icons.notes_rounded,
          ),
        ],
      ],
    );
  }
}

class _MenuHeading extends StatelessWidget {
  final int productCount;

  const _MenuHeading({required this.productCount});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(
        child: Text(
          'Menu',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      Text(
        '$productCount products',
        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
      ),
    ],
  );
}

class _NoProducts extends StatelessWidget {
  const _NoProducts();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 32),
    child: Column(
      children: [
        Icon(
          Icons.search_off_rounded,
          size: 42,
          color: AppColors.onSurfaceVariant,
        ),
        SizedBox(height: 12),
        Text(
          'No available products found',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      ],
    ),
  );
}
