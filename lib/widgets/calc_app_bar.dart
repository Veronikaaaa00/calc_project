import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme_controller.dart';

class CalcAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalcAppBar({required this.title, this.compact = false, super.key});

  final String title;
  final bool compact;

  @override
  Size get preferredSize => Size.fromHeight(compact ? 64 : 72);

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeScope.of(context);
    final isDark = themeController.mode == ThemeMode.dark;
    final router = GoRouter.of(context);
    // На экране 404 GoRouterState.of недоступен, адрес берём у самого роутера.
    final location = router.routeInformationProvider.value.uri.path;
    final canPop = router.canPop();
    final showBack = location != '/' && !canPop;

    return AppBar(
      toolbarHeight: preferredSize.height,
      titleSpacing: showBack || canPop ? 0 : 20,
      title: Text(title, overflow: TextOverflow.ellipsis),
      automaticallyImplyLeading: canPop,
      leading: showBack
          ? IconButton(
              tooltip: 'На главную',
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton.filledTonal(
            tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
            onPressed: themeController.toggle,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary
                  .withValues(alpha: isDark ? 0.18 : 0.10),
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
