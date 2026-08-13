import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Data model representing an item in the [FloatingBottomNavBar].
class FloatingNavItem {
  const FloatingNavItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
}

/// A refined, modern floating bottom navigation bar for DineFlow with subtle role accent glow.
class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.accentColor,
    this.margin = const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
  });

  /// Index of the currently active tab.
  final int currentIndex;

  /// Callback when a tab item is tapped.
  final ValueChanged<int> onTap;

  /// List of navigation destinations.
  final List<FloatingNavItem> items;

  /// Role accent color (defaults to [AppColors.primaryContainer]).
  final Color? accentColor;

  /// Outer margin around the floating navigation bar.
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final activeAccent = accentColor ?? AppColors.primaryContainer;

    return SafeArea(
      top: false,
      child: Padding(
        padding: margin,
        child: Container(
          height: 66.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33.0),
            boxShadow: [
              // Subtle ambient black drop shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 18.0,
                offset: const Offset(0, 6),
              ),
              // Subtle role accent glow shadow (e.g. refined Orange glow)
              BoxShadow(
                color: activeAccent.withValues(alpha: 0.16),
                blurRadius: 16.0,
                spreadRadius: 0.5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(33.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(33.0),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = index == currentIndex;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.fastOutSlowIn,
                            padding: EdgeInsets.symmetric(
                              horizontal: isSelected ? 16.0 : 12.0,
                              vertical: 9.0,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? activeAccent.withValues(alpha: 0.20)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24.0),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: activeAccent.withValues(alpha: 0.16),
                                        blurRadius: 8.0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? (item.selectedIcon ?? item.icon)
                                      : item.icon,
                                  size: 22.0,
                                  color: isSelected
                                      ? activeAccent
                                      : AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.65),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8.0),
                                  Flexible(
                                    child: Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: activeAccent,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
