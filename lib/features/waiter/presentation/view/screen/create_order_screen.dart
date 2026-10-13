import 'dart:async';

import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/usecase/get_categories_usecase.dart';
import 'package:dineflow/features/menu/domain/usecase/get_products_usecase.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_body.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/create_order_controller.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/order_created_dialog.dart';
import 'package:dineflow/features/waiter/presentation/view_model/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderScreen extends StatefulWidget {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  const CreateOrderScreen({
    super.key,
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  });

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  late final CreateOrderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CreateOrderController(
      getProductsUseCase: widget.getProductsUseCase,
      getCategoriesUseCase: widget.getCategoriesUseCase,
    );
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    final message = await _controller.submitOrder(context.read<OrderCubit>());
    if (mounted && message != null) _showMessage(message);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surfaceContainerHigh,
      ),
    );
  }

  Future<void> _showOrderCreatedDialog(String orderNumber) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => OrderCreatedDialog(orderNumber: orderNumber),
    );
    if (mounted) _controller.resetAfterOrderCreated();
  }

  @override
  Widget build(BuildContext context) => BlocListener<OrderCubit, OrderState>(
    listener: (context, state) {
      state.maybeWhen(
        orderCreated: (order) =>
            unawaited(_showOrderCreatedDialog(order.orderNumber)),
        error: _showMessage,
        orElse: () {},
      );
    },
    child: Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) =>
              CreateOrderBody(controller: _controller, onSubmit: _submitOrder),
        ),
      ),
    ),
  );
}
