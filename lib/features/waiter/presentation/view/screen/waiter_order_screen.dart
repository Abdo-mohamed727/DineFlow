
import 'package:dineflow/features/waiter/presentation/view_model/cubit/waiter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/widgets/status_badge.dart';
import 'package:dineflow/core/widgets/app_icon_button.dart';
import 'package:dineflow/core/widgets/app_loading_indicator.dart';
import 'package:dineflow/core/widgets/app_error_state.dart';
import 'package:dineflow/core/widgets/app_empty_state.dart';

import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedFilter = 'all';
  String _searchQuery = '';

  final List<Map<String, String>> _filters = const [
    {'label': 'All Orders', 'value': 'all'},
    {'label': 'Pending', 'value': 'pending'},
    {'label': 'Accepted', 'value': 'accepted'},
    {'label': 'Preparing', 'value': 'preparing'},
    {'label': 'Ready', 'value': 'ready'},
    {'label': 'Completed', 'value': 'completed'},
    {'label': 'Cancelled', 'value': 'cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<WaiterCubit>().getOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _changeFilter(String value) {
    setState(() {
      _selectedFilter = value;
    });

    if (value == 'all') {
      context.read<WaiterCubit>().getOrders();
    } else {
      context.read<WaiterCubit>().getOrdersByStatus(value);
    }
  }

  List<OrderWaiterEntity> _filterOrders(
    List<OrderWaiterEntity> orders,
  ) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) return orders;

    return orders.where((order) {
      return order.orderNumber.toLowerCase().contains(query) ||
          order.customer.name.toLowerCase().contains(query) ||
          (order.table?.tableNumber.toString().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<WaiterCubit, WaiterState>(
          builder: (context, state) {
            return state.when(
              initial: () => const AppLoadingIndicator(
                message: 'Loading orders...',
                center: true,
              ),
              loading: () => const AppLoadingIndicator(
                message: 'Loading orders...',
                center: true,
              ),
              error: (message) => AppErrorState(
                title: 'Could not load orders',
                message: message,
                onRetry: () {
                  if (_selectedFilter == 'all') {
                    context.read<WaiterCubit>().getOrders();
                  } else {
                    context
                        .read<WaiterCubit>()
                        .getOrdersByStatus(_selectedFilter);
                  }
                },
              ),
              ordersLoaded: (page) => _buildOrdersContent(page),
              orderLoaded: (order) => _buildOrdersContentFromSingle(order),
              orderCreated: (_) => const AppLoadingIndicator(
                message: 'Refreshing orders...',
                center: true,
              ),
              orderStatusUpdated: (_) => const AppLoadingIndicator(
                message: 'Refreshing orders...',
                center: true,
              ),
              requestsLoaded: (_) => _buildUnexpectedState(),
              requestUpdated: (_) => _buildUnexpectedState(),
              tablesLoaded: (_) => _buildUnexpectedState(),
              tableLoaded: (_) => _buildUnexpectedState(),
              tableUpdated: (_) => _buildUnexpectedState(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUnexpectedState() {
    return AppErrorState(
      title: 'Orders unavailable',
      message: 'Reload the orders list to continue.',
      onRetry: () => context.read<WaiterCubit>().getOrders(),
    );
  }

  Widget _buildOrdersContentFromSingle(OrderWaiterEntity order) {
    return _buildOrdersContent(
      OrdersPageEntity(
        items: [order],
        total: 1,
        page: 1,
        limit: 1,
        totalPages: 1,
      ),
    );
  }

  Widget _buildOrdersContent(OrdersPageEntity page) {
    final orders = _filterOrders(page.items);

    return RefreshIndicator(
      color: AppColors.primaryContainer,
      backgroundColor: AppColors.surfaceContainer,
      onRefresh: () async {
        if (_selectedFilter == 'all') {
          await context.read<WaiterCubit>().getOrders();
        } else {
          await context
              .read<WaiterCubit>()
              .getOrdersByStatus(_selectedFilter);
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          _buildHeader(page.total),
          const SizedBox(height: 24),
          _buildSummary(page),
          const SizedBox(height: 24),
          _buildSearchField(),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Order List',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${orders.length} orders',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 36),
              child: AppEmptyState(
                title: 'No orders found',
                message:
                    'Orders matching your search will appear here.',
                iconData: Icons.receipt_long_outlined,
              ),
            )
          else
            ...orders.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _OrderCard(
                  order: order,
                  onTap: () => _showOrderDetails(order),
                ),
              ),
            ),
          if (page.totalPages > 1) ...[
            const SizedBox(height: 8),
            Text(
              'Page ${page.page} of ${page.totalPages}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(int total) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Orders',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage your restaurant orders',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$total total orders',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        AppIconButton(
          iconData: Icons.refresh_rounded,
          tooltip: 'Refresh orders',
          backgroundColor: AppColors.surfaceContainer,
          iconColor: AppColors.primary,
          onPressed: () {
            if (_selectedFilter == 'all') {
              context.read<WaiterCubit>().getOrders();
            } else {
              context
                  .read<WaiterCubit>()
                  .getOrdersByStatus(_selectedFilter);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSummary(OrdersPageEntity page) {
    final inProgress = page.items.where((order) {
      final status = _normalize(order.status);
      return status == 'accepted' ||
          status == 'preparing';
    }).length;

    final pending = page.items.where(
      (order) => _normalize(order.status) == 'pending',
    ).length;

    final completed = page.items.where((order) {
      final status = _normalize(order.status);
      return status == 'completed' ||
          status == 'served' ||
          status == 'pickedup' ||
          status == 'paid';
    }).length;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Pending',
            value: pending.toString(),
            icon: Icons.schedule_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            title: 'In Progress',
            value: inProgress.toString(),
            icon: Icons.restaurant_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            title: 'Completed',
            value: completed.toString(),
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'Search order, customer, table...',
        hintStyle: const TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.onSurfaceVariant,
        ),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.outlineVariant,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final selected = _selectedFilter == filter['value'];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _changeFilter(filter['value']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? AppColors.primaryContainer
                      : AppColors.outlineVariant,
                  width: 0.7,
                ),
              ),
              child: Text(
                filter['label']!,
                style: TextStyle(
                  color: selected
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOrderDetails(OrderWaiterEntity order) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Order Details',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _detailRow('Customer', order.customer.name),
                  _detailRow(
                    'Order type',
                    _typeLabel(order.type),
                  ),
                  _detailRow(
                    'Table',
                    order.table == null
                        ? 'No table assigned'
                        : 'Table ${order.table!.tableNumber}',
                  ),
                  _detailRow(
                    'Created',
                    _formatDate(order.createdAt),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Items',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            item.subtotal.toStringAsFixed(2),
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (order.notes != null &&
                      order.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _detailRow('Notes', order.notes!),
                  ],
                  const Divider(
                    height: 28,
                    color: AppColors.outlineVariant,
                  ),
                  _detailRow(
                    'Subtotal',
                    order.subtotal.toStringAsFixed(2),
                  ),
                  _detailRow(
                    'Tax',
                    order.tax.toStringAsFixed(2),
                  ),
                  const SizedBox(height: 8),
                  _detailRow(
                    'Total',
                    order.total.toStringAsFixed(2),
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isTotal
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
                fontSize: isTotal ? 15 : 13,
                fontWeight:
                    isTotal ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isTotal
                    ? AppColors.primary
                    : AppColors.onSurface,
                fontSize: isTotal ? 17 : 13,
                fontWeight:
                    isTotal ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');
  }

  String _typeLabel(String type) {
    switch (_normalize(type)) {
      case 'dinein':
        return 'Dine In';
      case 'takeaway':
        return 'Takeaway';
      default:
        return type;
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year;
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/$year  $hour:$minute';
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant,
          width: 0.6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColors.primary,
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderWaiterEntity order;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.onTap,
  });

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');
  }

  OrderStatus _parseStatus(String value) {
    switch (_normalize(value)) {
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'readyforpickup':
        return OrderStatus.readyForPickup;
      case 'served':
        return OrderStatus.served;
      case 'pickedup':
        return OrderStatus.pickedUp;
      case 'paymentpending':
        return OrderStatus.paymentPending;
      case 'paid':
        return OrderStatus.paid;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  OrderType? _parseType(String value) {
    switch (_normalize(value)) {
      case 'dinein':
        return OrderType.dineIn;
      case 'takeaway':
        return OrderType.takeaway;
      default:
        return null;
    }
  }

  String _typeLabel(String value) {
    switch (_normalize(value)) {
      case 'dinein':
        return 'Dine In';
      case 'takeaway':
        return 'Takeaway';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.outlineVariant,
              width: 0.7,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(
                        alpha: 0.13,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.primary,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          order.customer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(
                    status: _parseStatus(order.status),
                    orderType: _parseType(order.type),
                    fontSize: 10,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 14,
                runSpacing: 10,
                children: [
                  _InfoLabel(
                    icon: Icons.shopping_bag_outlined,
                    text: _typeLabel(order.type),
                  ),
                  if (order.table != null)
                    _InfoLabel(
                      icon: Icons.table_restaurant_outlined,
                      text: 'Table ${order.table!.tableNumber}',
                    ),
                  _InfoLabel(
                    icon: Icons.restaurant_menu_rounded,
                    text: '${order.items.length} items',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(
                height: 1,
                color: AppColors.outlineVariant,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ORDER TOTAL',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          order.total.toStringAsFixed(2),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View details',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primary,
                        size: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLabel({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}