import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_empty_state.dart';
import 'package:dineflow/core/widgets/app_error_state.dart';
import 'package:dineflow/core/widgets/app_loading_indicator.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/cart/presentation/view/widgets/cart_content.dart';
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _promoController =
      TextEditingController(text: 'CRAVINGS3');
  bool _isPromoApplied = true;

  @override
  void dispose() {
    _notesController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Checkout',
      role: AppRole.customer,
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              state.maybeWhen(
                loaded: (cart, updating, isAdding, actionError) {
                  if (actionError != null && actionError.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(actionError),
                        backgroundColor: AppColors.errorContainer,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                orElse: () {},
              );
            },
          ),
          BlocListener<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
              state.whenOrNull(
                success: (order) {
                  context.read<CartCubit>().getCart(silent: true);
                  context.goNamed(
                    AppRoutes.customerOrderSuccess,
                    extra: order,
                  );
                },
              );
            },
          ),
        ],
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return state.when(
              initial: () =>
                  const AppLoadingIndicator(message: 'Loading cart...'),
              loading: () =>
                  const AppLoadingIndicator(message: 'Loading cart...'),
              error: (message) => AppErrorState(
                message: message,
                onRetry: () => context.read<CartCubit>().getCart(),
              ),
              empty: () => AppEmptyState(
                title: 'Your cart is empty',
                message: 'Browse our menu and add something delicious.',
                iconData: Icons.shopping_bag_outlined,
                actionText: 'Browse Menu',
                onAction: () => context.goNamed(AppRoutes.customerMenu),
              ),
              loaded: (cart, updatingProductIds, isAdding, actionError) {
                return CartContent(
                  cart: cart,
                  updatingProductIds: updatingProductIds,
                  notesController: _notesController,
                  promoController: _promoController,
                  isPromoApplied: _isPromoApplied,
                  onApplyPromoToggle: () {
                    setState(() {
                      _isPromoApplied = !_isPromoApplied;
                    });
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
