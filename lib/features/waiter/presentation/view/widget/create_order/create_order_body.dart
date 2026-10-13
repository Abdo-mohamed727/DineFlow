import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_bottom_bar.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_content.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_controller.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_error_state.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_header.dart';
import 'package:flutter/material.dart';

class CreateOrderBody extends StatelessWidget {
  final CreateOrderController controller;
  final VoidCallback onSubmit;

  const CreateOrderBody({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      CreateOrderHeader(itemCount: controller.totalQuantity),
      Expanded(child: _buildMainContent()),
      CreateOrderBottomBar(
        subtotal: controller.subtotal,
        isSubmitting: controller.isSubmitting,
        onSubmit: onSubmit,
      ),
    ],
  );

  Widget _buildMainContent() {
    if (controller.isLoadingProducts) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.waiterPrimary),
      );
    }
    if (controller.loadError != null) {
      return CreateOrderErrorState(
        message: controller.loadError!,
        onRetry: controller.loadProducts,
      );
    }
    return CreateOrderContent(controller: controller);
  }
}
