import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_shell.dart';
import '../widgets/destination_tile.dart';
import '../widgets/narrow_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppShell(
      title: 'Главная',
      floating: true,
      body: NarrowBody(
        maxWidth: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Калькулятор',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Считайте и меняйте валюту. Состояние экрана хранится в адресе.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 36),
            DestinationTile(
              title: 'Калькулятор',
              subtitle: 'Четыре операции и результат в URL',
              icon: Icons.calculate_rounded,
              emphasized: true,
              onPressed: () => context.go('/calculator'),
            ),
            const SizedBox(height: 14),
            DestinationTile(
              title: 'Конвертер валют',
              subtitle: 'Шесть валют, курсы заданы в коде',
              icon: Icons.currency_exchange_rounded,
              onPressed: () => context.go('/converter'),
            ),
          ],
        ),
      ),
    );
  }
}
