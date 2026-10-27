import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderTypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const OrderTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: AppColors.outlineVariant, width: 0.6),
    ),
    child: Row(
      children: [
        _TypeButton(
          label: 'Dine In',
          icon: Icons.table_restaurant_rounded,
          selected: value == 'dineIn',
          onTap: () => onChanged('dineIn'),
        ),
        _TypeButton(
          label: 'Takeaway',
          icon: Icons.shopping_bag_outlined,
          selected: value == 'takeaway',
          onTap: () => onChanged('takeaway'),
        ),
      ],
    ),
  );
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(11),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.waiterPrimary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 17, color: _color),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: _color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Color get _color =>
      selected ? AppColors.waiterPrimary : AppColors.onSurfaceVariant;
}
