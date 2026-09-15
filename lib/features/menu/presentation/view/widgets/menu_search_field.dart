import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/presentation/view_model/cubit/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuSearchField extends StatefulWidget {
  const MenuSearchField({super.key});

  @override
  State<MenuSearchField> createState() => _MenuSearchFieldState();
}

class _MenuSearchFieldState extends State<MenuSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        context.read<MenuCubit>().searchProducts(value);
      },
      style: const TextStyle(color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: 'Search dishes...',
        hintStyle: TextStyle(
          color: AppColors.onSurface.withValues(alpha: 0.4),
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.onSurfaceVariant,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear_rounded,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed: () {
                  _controller.clear();
                  context.read<MenuCubit>().searchProducts('');
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.surfaceContainerHigh.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryContainer,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
