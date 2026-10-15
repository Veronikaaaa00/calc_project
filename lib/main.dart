import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'router.dart';
import 'theme/app_theme.dart';
import 'theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Убирает решётку из адреса: /calculator вместо /#/calculator.
  usePathUrlStrategy();
  final themeController = ThemeController();
  await themeController.load();
  runApp(CalcApp(themeController: themeController));
}

class CalcApp extends StatelessWidget {
  const CalcApp({required this.themeController, super.key});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: themeController,
      child: ListenableBuilder(
        listenable: themeController,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Калькулятор',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeController.mode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
