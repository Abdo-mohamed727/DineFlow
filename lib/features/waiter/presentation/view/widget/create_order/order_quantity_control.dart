import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderQuantityControl extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const OrderQuantityControl({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return IconButton.filled(
        onPressed: () => onChanged(1),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.waiterPrimary,
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.add_rounded),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QuantityButton(icon: Icons.remove_rounded, onTap: () => onChanged(-1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Text(
            '$quantity',
            style: const TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _QuantityButton(icon: Icons.add_rounded, onTap: () => onChanged(1)),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(9),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 17, color: AppColors.onSurface),
    ),
  );
}
