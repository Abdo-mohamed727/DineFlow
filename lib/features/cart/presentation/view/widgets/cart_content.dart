import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_bottom_action_bar.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_cooking_notes_card.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_delivery_table_card.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_item_tile.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_order_header.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_payment_summary_card.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_promo_section.dart';
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
    required this.cart,
    required this.updatingProductIds,
    required this.notesController,
    required this.promoController,
    required this.isPromoApplied,
    required this.onApplyPromoToggle,
  });

  final CartEntity cart;
  final Set<String> updatingProductIds;
  final TextEditingController notesController;
  final TextEditingController promoController;
  final bool isPromoApplied;
  final VoidCallback onApplyPromoToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryContainer,
            onRefresh: () => context.read<CartCubit>().getCart(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // 1. Order Header
                CartOrderHeader(totalQuantity: cart.totalQuantity),
                const SizedBox(height: 14),

                // 2. Cart Item Tiles
                ...cart.items.map((item) {
                  final isUpdating =
                      updatingProductIds.contains(item.productId);
                  return CartItemTile(
                    item: item,
                    isUpdating: isUpdating,
                    onIncrement: () => context
                        .read<CartCubit>()
                        .updateQuantity(item.productId, item.quantity + 1),
                    onDecrement: item.quantity > 1
                        ? () => context
                            .read<CartCubit>()
                            .updateQuantity(item.productId, item.quantity - 1)
                        : null,
                    onRemove: () =>
                        context.read<CartCubit>().removeItem(item.productId),
                  );
                }),
                const SizedBox(height: 16),

                // 3. Cooking Notes Section
                CartCookingNotesCard(notesController: notesController),
                const SizedBox(height: 16),

                // 4. Promo & Voucher Section
                CartPromoSection(
                  promoController: promoController,
                  isPromoApplied: isPromoApplied,
                  onApplyPromoToggle: onApplyPromoToggle,
                ),
                const SizedBox(height: 20),

                // 5. Payment Summary Card
                CartPaymentSummaryCard(
                  cart: cart,
                  isPromoApplied: isPromoApplied,
                ),
                const SizedBox(height: 16),

                // 6. Delivery / Table Selection Card
                const CartDeliveryTableCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Fixed Place Order Bottom Bar
        const CartBottomActionBar(),
      ],
    );
  }
}
