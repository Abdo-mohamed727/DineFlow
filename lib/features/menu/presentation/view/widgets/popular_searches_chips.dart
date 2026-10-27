import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PopularSearchesChips extends StatelessWidget {
  final List<String> searches;
  final String activeQuery;
  final ValueChanged<String> onChipTap;

  const PopularSearchesChips({
    super.key,
    required this.searches,
    required this.activeQuery,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Searches',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: searches.map((chipText) {
              final isSelected =
                  activeQuery.toLowerCase() == chipText.toLowerCase();
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => onChipTap(chipText),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryContainer
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryContainer
                            : AppColors.surfaceContainerHigh,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryContainer
                                    .withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      chipText,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.onSurface.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
