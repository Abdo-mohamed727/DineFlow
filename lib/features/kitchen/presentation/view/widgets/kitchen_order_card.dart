import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/kitchen/presentation/view_model/cubit/kitchen_cubit.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KitchenOrderCard extends StatelessWidget {
  const KitchenOrderCard({super.key, required this.order});
  final OrderEntity order;

  static const _green = Color(0xFF81C784);
  static const _amber = Color(0xFFFFB300);
  static const _red = Color(0xFFEF5350);
  static const _blue = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KitchenCubit>();
    final isDineIn = order.orderType == OrderType.dineIn;
    final elapsed = _elapsedLabel(order.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor(order.status).withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: type badge + table/pickup label + order# + elapsed ──
          _CardHeader(
            order: order,
            isDineIn: isDineIn,
            elapsed: elapsed,
            green: _green,
            amber: _amber,
          ),
          const Divider(height: 1, color: Color(0xFF2A2A2A)),

          // ── Items list ──
          if (order.items.isNotEmpty) ...[
            _ItemsList(items: order.items),
            const Divider(height: 1, color: Color(0xFF2A2A2A)),
          ],

          // ── Footer: status chip + total ──
          _OrderMeta(order: order),
          const SizedBox(height: 12),

          // ── Action button ──
          _ActionButton(
            order: order,
            cubit: cubit,
            green: _green,
            amber: _amber,
            red: _red,
            blue: _blue,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return _amber;
      case OrderStatus.accepted:
        return _green;
      case OrderStatus.preparing:
        return _blue;
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return _green;
      default:
        return AppColors.outlineVariant;
    }
  }

  String _elapsedLabel(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    return DateFormat('HH:mm').format(dt);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────
class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.order,
    required this.isDineIn,
    required this.elapsed,
    required this.green,
    required this.amber,
  });
  final OrderEntity order;
  final bool isDineIn;
  final String elapsed;
  final Color green;
  final Color amber;

  @override
  Widget build(BuildContext context) {
    // Prefer tableNumber (human-readable), fall back to tableId only as last resort
    final tableLabel = order.tableNumber?.isNotEmpty == true
        ? 'Table ${order.tableNumber}'
        : (order.tableId != null ? 'Table' : null);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          // Order-type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (isDineIn ? green : amber).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: (isDineIn ? green : amber).withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              isDineIn ? 'DINE IN' : 'TAKEAWAY',
              style: TextStyle(
                color: isDineIn ? green : amber,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Table label (only for dine-in, human-readable)
          if (isDineIn && tableLabel != null)
            Text(
              tableLabel,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

          const Spacer(),

          // Order number + elapsed time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#${order.orderNumber ?? order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (elapsed.isNotEmpty)
                Text(
                  elapsed,
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Items list
// ─────────────────────────────────────────────────────────────────────────────
class _ItemsList extends StatelessWidget {
  const _ItemsList({required this.items});
  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER ITEMS',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => _ItemRow(item: item)),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quantity badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF42A5F5).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              '×${item.quantity}',
              style: const TextStyle(
                color: Color(0xFF42A5F5),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.notes != null && item.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.notes!,
                      style: const TextStyle(
                        color: Color(0xFFFFB300),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer meta (status chip + total)
// ─────────────────────────────────────────────────────────────────────────────
class _OrderMeta extends StatelessWidget {
  const _OrderMeta({required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          _StatusChip(status: order.status),
          const Spacer(),
          Text(
            'Total: \$${(order.total / 100).toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.pending => ('● PENDING', const Color(0xFFFFB300)),
      OrderStatus.accepted => ('● ACCEPTED', const Color(0xFF81C784)),
      OrderStatus.preparing => ('● PREPARING', const Color(0xFF42A5F5)),
      OrderStatus.ready ||
      OrderStatus.readyForPickup =>
        ('● READY', const Color(0xFF66BB6A)),
      _ => ('● ${status.name.toUpperCase()}', AppColors.onSurfaceVariant),
    };
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action buttons
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.order,
    required this.cubit,
    required this.green,
    required this.amber,
    required this.red,
    required this.blue,
  });
  final OrderEntity order;
  final KitchenCubit cubit;
  final Color green;
  final Color amber;
  final Color red;
  final Color blue;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isProcessing = false;

  Future<void> _handleAction(Future<void> Function() action) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await action();
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    // Read from both local state and cubit state to be perfectly safe across rebuilds
    final isProcessing = _isProcessing || widget.cubit.isProcessing(widget.order.id);

    return switch (widget.order.status) {
      // ── Pending: confirm order only ───────────────────────────────────────
      OrderStatus.pending => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: _Btn(
              label: isProcessing ? 'Confirming...' : 'Confirm Order',
              icon: Icons.thumb_up_alt_rounded,
              color: widget.green,
              onTap: isProcessing ? null : () => _handleAction(() => widget.cubit.confirmOrder(widget.order.id)),
            ),
          ),
        ),
      // ── Accepted: start preparing only ────────────────────────────────────
      OrderStatus.accepted => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: _Btn(
              label: isProcessing ? 'Processing...' : 'Start Preparing',
              icon: Icons.local_fire_department_rounded,
              color: widget.amber,
              onTap: isProcessing ? null : () => _handleAction(() => widget.cubit.startPreparing(widget.order.id)),
            ),
          ),
        ),
      // ── Preparing: mark ready ─────────────────────────────────────────────
      OrderStatus.preparing => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: _Btn(
              label: isProcessing ? 'Processing...' : 'Mark as Ready ✓',
              icon: Icons.check_circle_rounded,
              color: widget.green,
              onTap: isProcessing ? null : () => _handleAction(() => widget.cubit.markReady(widget.order.id)),
            ),
          ),
        ),
      // ── Ready: hand off ───────────────────────────────────────────────────
      OrderStatus.ready || OrderStatus.readyForPickup => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: _Btn(
              label: 'Complete / Hand Off ✓',
              icon: Icons.handshake_rounded,
              color: const Color(0xFF66BB6A),
              onTap: () {},
            ),
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

/// Two equal-width buttons side by side.
class _DualBtnRow extends StatelessWidget {
  const _DualBtnRow({
    required this.leftLabel,
    required this.leftIcon,
    required this.leftColor,
    required this.onLeftTap,
    required this.rightLabel,
    required this.rightIcon,
    required this.rightColor,
    required this.onRightTap,
  });

  final String leftLabel;
  final IconData leftIcon;
  final Color leftColor;
  final VoidCallback? onLeftTap;
  final String rightLabel;
  final IconData rightIcon;
  final Color rightColor;
  final VoidCallback? onRightTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: _Btn(
              label: leftLabel,
              icon: leftIcon,
              color: leftColor,
              onTap: onLeftTap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Btn(
              label: rightLabel,
              icon: rightIcon,
              color: rightColor,
              onTap: onRightTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 17),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black87,
        disabledBackgroundColor: color.withValues(alpha: 0.5),
        disabledForegroundColor: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
