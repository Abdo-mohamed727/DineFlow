import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchResultsHeader extends StatelessWidget {
  final int count;
  final String query;
  final String selectedSort;
  final ValueChanged<String> onSortChanged;

  const SearchResultsHeader({
    super.key,
    required this.count,
    required this.query,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final queryText = query.isNotEmpty ? '"$query"' : 'dishes';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count results for $queryText',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        // Sort Dropdown Button
        PopupMenuButton<String>(
          initialValue: selectedSort,
          onSelected: onSortChanged,
          color: AppColors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                'Sort by: ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              Text(
                selectedSort,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'Recommended',
              child: Text('Recommended', style: TextStyle(color: Colors.white)),
            ),
            PopupMenuItem(
              value: 'Price: Low to High',
              child: Text('Price: Low to High', style: TextStyle(color: Colors.white)),
            ),
            PopupMenuItem(
              value: 'Price: High to Low',
              child: Text('Price: High to Low', style: TextStyle(color: Colors.white)),
            ),
            PopupMenuItem(
              value: 'Name: A-Z',
              child: Text('Name: A-Z', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}
