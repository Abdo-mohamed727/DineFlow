import 'package:flutter/material.dart';
import '../enums/order_status.dart';
import '../enums/order_type.dart';
import '../theme/app_colors.dart';

/// Color-coded status badge widget for displaying DineFlow order statuses.
/// Supports context-aware labels and styling for both [OrderType.dineIn] and [OrderType.takeaway].
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.orderType,
    this.label,
    this.showDot = true,
    this.icon,
    this.padding,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = 20.0,
    this.backgroundColor,
    this.textColor,
    this.dotColor,
  });

  final OrderStatus status;
  final OrderType? orderType;
  final String? label;
  final bool showDot;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? dotColor;

  String get _resolvedLabel {
    if (label != null && label!.isNotEmpty) return label!;
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return orderType == OrderType.takeaway
            ? 'Ready for Pickup'
            : 'Ready to Serve';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.paymentPending:
        return 'Payment Pending';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get _resolvedBackgroundColor {
    if (backgroundColor != null) return backgroundColor!;
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFF3B2E00);
      case OrderStatus.accepted:
        return const Color(0xFF0D2D4A);
      case OrderStatus.preparing:
        return AppColors.primaryContainer.withValues(alpha: 0.2);
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return orderType == OrderType.takeaway
            ? const Color(0xFF0B3B32)
            : const Color(0xFF0F3B1D);
      case OrderStatus.served:
        return const Color(0xFF0E383C);
      case OrderStatus.pickedUp:
        return const Color(0xFF00363A);
      case OrderStatus.paymentPending:
        return const Color(0xFF2D184E);
      case OrderStatus.paid:
      case OrderStatus.completed:
        return const Color(0xFF13361E);
      case OrderStatus.cancelled:
        return AppColors.errorContainer.withValues(alpha: 0.3);
    }
  }

  Color get _resolvedTextColor {
    if (textColor != null) return textColor!;
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFE082);
      case OrderStatus.accepted:
        return const Color(0xFF90CAF9);
      case OrderStatus.preparing:
        return AppColors.primaryContainer;
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return orderType == OrderType.takeaway
            ? const Color(0xFF80CBC4)
            : const Color(0xFFA5D6A7);
      case OrderStatus.served:
        return const Color(0xFF80DEEA);
      case OrderStatus.pickedUp:
        return const Color(0xFF80DEEA);
      case OrderStatus.paymentPending:
        return const Color(0xFFCE93D8);
      case OrderStatus.paid:
      case OrderStatus.completed:
        return const Color(0xFF81C784);
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  Color get _resolvedDotColor {
    if (dotColor != null) return dotColor!;
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFC107);
      case OrderStatus.accepted:
        return const Color(0xFF2196F3);
      case OrderStatus.preparing:
        return AppColors.primaryContainer;
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return orderType == OrderType.takeaway
            ? const Color(0xFF009688)
            : const Color(0xFF4CAF50);
      case OrderStatus.served:
        return const Color(0xFF00BCD4);
      case OrderStatus.pickedUp:
        return const Color(0xFF00BCD4);
      case OrderStatus.paymentPending:
        return const Color(0xFFAB47BC);
      case OrderStatus.paid:
      case OrderStatus.completed:
        return const Color(0xFF4CAF50);
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _resolvedBackgroundColor;
    final txt = _resolvedTextColor;
    final dot = _resolvedDotColor;

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 6.0),
          ] else if (showDot) ...[
            Container(
              width: 7.0,
              height: 7.0,
              decoration: BoxDecoration(
                color: dot,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6.0),
          ],
          Text(
            _resolvedLabel,
            style: TextStyle(
              color: txt,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

/// Typedef alias allowing usage as OrderStatusChip.
typedef OrderStatusChip = StatusBadge;
