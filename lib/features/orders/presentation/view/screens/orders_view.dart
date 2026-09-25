import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_error_state.dart';
import 'package:dineflow/core/widgets/app_icon_button.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/orders/presentation/view/widgets/no_active_orders_banner.dart';
import 'package:dineflow/features/orders/presentation/view/widgets/orders_shimmer_loading.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/presentation/view/widgets/active_order_card.dart';
import 'package:dineflow/features/orders/presentation/view/widgets/order_history_section.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrdersCubit>()..fetchOrders(),
      child: const _OrdersViewBody(),
    );
  }
}

class _OrdersViewBody extends StatefulWidget {
  const _OrdersViewBody();

  @override
  State<_OrdersViewBody> createState() => _OrdersViewBodyState();
}

class _OrdersViewBodyState extends State<_OrdersViewBody> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            return state.when(
              initial: () => const OrdersShimmerLoading(),
              loading: () => const OrdersShimmerLoading(),
              loaded: (allOrders, filteredOrders, selectedStatus) {
                return _OrdersContent(allOrders: allOrders);
              },
              empty: (allOrders, selectedStatus, message) {
                return _OrdersContent(allOrders: const []);
              },
              error: (message) => _ErrorBody(message: message),
            );
          },
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrdersAppBar(),
        Expanded(
          child: AppErrorState(
            message: message,
            onRetry: () => context.read<OrdersCubit>().refreshOrders(),
          ),
        ),
      ],
    );
  }
}

class _OrdersContent extends StatelessWidget {
  const _OrdersContent({required this.allOrders});
  final List<OrderEntity> allOrders;

  static const _activeStatuses = {
    OrderStatus.pending,
    OrderStatus.accepted,
    OrderStatus.preparing,
    OrderStatus.ready,
    OrderStatus.readyForPickup,
    OrderStatus.served,
    OrderStatus.paymentPending,
  };

  static const _historyStatuses = {
    OrderStatus.completed,
    OrderStatus.paid,
    OrderStatus.pickedUp,
    OrderStatus.cancelled,
  };

  @override
  Widget build(BuildContext context) {
    final activeOrders = allOrders
        .where((o) => _activeStatuses.contains(o.status))
        .toList();
    final historyOrders = allOrders
        .where((o) => _historyStatuses.contains(o.status))
        .toList();

    return RefreshIndicator(
      onRefresh: () => context.read<OrdersCubit>().refreshOrders(),
      color: AppColors.primaryContainer,
      backgroundColor: AppColors.surfaceContainerHigh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _OrdersAppBar()),

          // ── Active Orders ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: _ActiveOrdersHeader(count: activeOrders.length),
            ),
          ),

          if (activeOrders.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: NoActiveOrdersBanner(
                  onBrowseMenu: () => context.goNamed(AppRoutes.customerMenu),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: ActiveOrderCard(order: activeOrders[i]),
                ),
                childCount: activeOrders.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Order History ─────────────────────────────────────────────────
          if (allOrders.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _FirstTimeCustomerBody(
                onBrowseMenu: () => context.goNamed(AppRoutes.customerMenu),
              ),
            )
          else
            SliverToBoxAdapter(
              child: OrderHistorySection(orders: historyOrders),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────

class _OrdersAppBar extends StatelessWidget {
  const _OrdersAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Text(
            'Orders',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          AppIconButton(
            iconData: Icons.refresh_rounded,
            onPressed: () => context.read<OrdersCubit>().refreshOrders(),
            tooltip: 'Refresh orders',
          ),
          const SizedBox(width: 8),
          AppIconButton(
            iconData: Icons.person_rounded,
            onPressed: () => context.goNamed(AppRoutes.customerProfile),
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ── Active orders section header ─────────────────────────────────────────────

class _ActiveOrdersHeader extends StatelessWidget {
  const _ActiveOrdersHeader({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count > 0 ? 'ACTIVE ORDERS' : 'ACTIVE ORDER',
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          if (count > 1) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count LIVE',
                style: const TextStyle(
                  color: AppColors.onPrimaryContainer,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── First-time customer body ─────────────────────────────────────────────────

class _FirstTimeCustomerBody extends StatelessWidget {
  const _FirstTimeCustomerBody({required this.onBrowseMenu});
  final VoidCallback onBrowseMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No orders yet',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You haven't placed any orders with DineFlow yet.\nDiscover our chef's hand-crafted specials and taste the extraordinary.",
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: onBrowseMenu,
            icon: const Icon(Icons.restaurant_menu_rounded, size: 18),
            label: const Text('Explore Menu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
