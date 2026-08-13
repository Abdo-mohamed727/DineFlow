import 'package:flutter/material.dart';
import 'package:dineflow/core/theme/app_colors.dart';

/// Shared bottom link row displayed at the bottom of auth screens.
///
/// Example: *"Already have an account? **Login**"*
///
/// - [label] — the plain text part (e.g., "Already have an account? ")
/// - [linkText] — the tappable, highlighted text (e.g., "Login")
/// - [onTap] — callback invoked when the link is tapped
class AuthBottomLink extends StatelessWidget {
  const AuthBottomLink({
    super.key,
    required this.label,
    required this.linkText,
    required this.onTap,
  });

  final String label;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            fontSize: 14.0,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: AppColors.primaryContainer,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
