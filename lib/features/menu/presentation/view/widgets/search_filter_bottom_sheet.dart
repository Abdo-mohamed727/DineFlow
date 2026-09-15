import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSortSelected;

  const SearchFilterBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  static void show(
    BuildContext context, {
    required String selectedSort,
    required ValueChanged<String> onSortSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SearchFilterBottomSheet(
          selectedSort: selectedSort,
          onSortSelected: onSortSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const sortOptions = [
      'Recommended',
      'Price: Low to High',
      'Price: High to Low',
      'Name: A-Z',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sort Results',
            style: TextStyle(color: AppColors.outline, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: sortOptions.map((sortOption) {
              final isSelected = selectedSort == sortOption;
              return ChoiceChip(
                label: Text(sortOption),
                selected: isSelected,
                selectedColor: AppColors.primaryContainer,
                backgroundColor: AppColors.surfaceContainerHigh,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    onSortSelected(sortOption);
                  }
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
