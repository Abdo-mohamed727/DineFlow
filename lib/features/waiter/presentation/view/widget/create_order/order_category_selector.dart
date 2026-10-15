import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:flutter/material.dart';

class OrderCategorySelector extends StatelessWidget {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  const OrderCategorySelector({
    super.key,
    required this.categories,
    required this.isLoading,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LinearProgressIndicator(
        color: AppColors.waiterPrimary,
        backgroundColor: AppColors.surfaceContainer,
      );
    }
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _CategoryChip(
            label: 'All',
            id: null,
            selected: selectedId == null,
            onSelected: onSelected,
          ),
          ...categories.map(
            (category) => _CategoryChip(
              label: category.name,
              id: category.id,
              selected: selectedId == category.id,
              onSelected: onSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String? id;
  final bool selected;
  final ValueChanged<String?> onSelected;

  const _CategoryChip({
    required this.label,
    required this.id,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(11),
      onTap: () => onSelected(id),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.waiterPrimary.withValues(alpha: 0.2)
              : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected
                ? AppColors.waiterPrimary
                : AppColors.outlineVariant,
            width: 0.6,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? AppColors.waiterPrimary
                : AppColors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
