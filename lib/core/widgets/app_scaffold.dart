import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

enum AppRole { customer, waiter, kitchen }

extension AppRoleX on AppRole {
  Color get accentColor => switch (this) {
        AppRole.customer => AppColors.primaryContainer,   
        AppRole.waiter   => const Color(0xFF64B5F6),     
        AppRole.kitchen  => const Color(0xFF81C784),     
      };

  Color get pillBackground => switch (this) {
        AppRole.customer => AppColors.primaryContainer.withValues(alpha: 0.15),
        AppRole.waiter   => const Color(0xFF64B5F6).withValues(alpha: 0.12),
        AppRole.kitchen  => const Color(0xFF81C784).withValues(alpha: 0.12),
      };

  String get label => switch (this) {
        AppRole.customer => 'Customer',
        AppRole.waiter   => 'Waiter',
        AppRole.kitchen  => 'Kitchen',
      };

  IconData get icon => switch (this) {
        AppRole.customer => Icons.person_rounded,
        AppRole.waiter   => Icons.room_service_rounded,
        AppRole.kitchen  => Icons.kitchen_rounded,
      };
}
 
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.role,
    this.leading,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.showAppBar = true,
    this.centerTitle = true,
    this.titleWidget,
  });

  final Widget body;

  final String? title;

  final AppRole? role;

  final Widget? leading;

  final List<Widget>? actions;

  final Widget? bottomNavigationBar;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final bool resizeToAvoidBottomInset;

  final bool extendBodyBehindAppBar;

  final bool showAppBar;

  final bool centerTitle;

  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.surfaceContainerLowest,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: showAppBar ? _buildAppBar(context) : null,
        body: _AppBackground(
          role: role,
          child: body,
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final accent = role?.accentColor ?? AppColors.primaryContainer;
    final canPop = Navigator.of(context).canPop();

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 1),
      child: _FrostedAppBar(
        title: title,
        titleWidget: titleWidget,
        role: role,
        accent: accent,
        centerTitle: centerTitle,
        leading: leading ??
            (canPop
                ? _BackButton(accentColor: accent)
                : null),
        actions: actions,
      ),
    );
  }
}

 
class _AppBackground extends StatelessWidget {
  const _AppBackground({required this.child, this.role});

  final Widget child;
  final AppRole? role;

  @override
  Widget build(BuildContext context) {
    final accent = role?.accentColor ?? AppColors.primaryContainer;

    return Stack(
      children: [
         
        Positioned.fill(
          child: Image.asset(
            'assets/Background Image with Dark Overlay.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),

        
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surface.withValues(alpha: 0.70),
                  AppColors.surface.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
        ),

         
        Positioned(
          top: -120,
          left: -120,
          child: _RadialGlow(
            color: accent.withValues(alpha: 0.18),
            radius: 320,
          ),
        ),

        Positioned(
          bottom: -160,
          right: -160,
          child: _RadialGlow(
            color: AppColors.surfaceBright.withValues(alpha: 0.20),
            radius: 300,
          ),
        ),

        Positioned.fill(
          child: CustomPaint(painter: _DotGridPainter()),
        ),

        Positioned.fill(child: child),
      ],
    );
  }
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  static final _paint = Paint()
    ..color = AppColors.onSurface.withValues(alpha: 0.025)
    ..strokeCap = StrokeCap.round;

  static const double _spacing = 28;
  static const double _dotRadius = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (double x = _spacing / 2; x < size.width; x += _spacing) {
      for (double y = _spacing / 2; y < size.height; y += _spacing) {
        canvas.drawCircle(Offset(x, y), _dotRadius, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _FrostedAppBar extends StatelessWidget {
  const _FrostedAppBar({
    required this.accent,
    this.title,
    this.titleWidget,
    this.role,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });

  final Color accent;
  final String? title;
  final Widget? titleWidget;
  final AppRole? role;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.82),
            border: Border(
              bottom: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: centerTitle,
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                leading: leading != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: leading,
                      )
                    : null,
                title: titleWidget ??
                    _AppBarTitle(title: title, role: role, accent: accent),
                actions: actions != null
                    ? [
                        ...actions!,
                        const SizedBox(width: 8),
                      ]
                    : null,
              ),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      accent.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    required this.accent,
    this.title,
    this.role,
  });

  final String? title;
  final AppRole? role;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Flexible(
            child: Text(
              title!,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (role != null) ...[
          if (title != null) const SizedBox(width: 8),
          _RolePill(role: role!, accent: accent),
        ],
      ],
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role, required this.accent});

  final AppRole role;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: role.pillBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(role.icon, size: 12, color: accent),
          const SizedBox(width: 4),
          Text(
            role.label,
            style: TextStyle(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}


class _BackButton extends StatelessWidget {
  const _BackButton({required this.accentColor});
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
            width: 0.8,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: accentColor,
        ),
      ),
    );
  }
}
