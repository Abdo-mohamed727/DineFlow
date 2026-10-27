import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/order_type_selector_sheet.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBottomActionBar extends StatelessWidget {
  const CartBottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final isLoading = state.selection?.isLoadingTables ?? false;
            return AppPrimaryButton(
              text: 'Continue',
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () => OrderTypeSelectorSheet.show(
                      context,
                      context.read<CheckoutCubit>(),
                    ),
            );
          },
        ),
      ),
    );
  }
}
