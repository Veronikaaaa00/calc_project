import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';
import '../widgets/app_shell.dart';
import '../widgets/narrow_body.dart';
import '../widgets/result_panel.dart';

/// Экран ничего не получает через конструктор: все данные читаются из адреса.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = GoRouterState.of(context).uri;
    final isCalculator = uri.path.startsWith('/calculator');
    final query = uri.queryParameters;
    final backPath = isCalculator ? '/calculator' : '/converter';
    final title = isCalculator
        ? 'Результат вычисления'
        : 'Результат конвертации';
    final view = isCalculator ? _calculatorView(query) : _converterView(query);

    return AppShell(
      title: title,
      body: NarrowBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResultPanel(
              expression: view.expression,
              outcome: view.outcome,
              address: uri.toString(),
              isError: view.isError,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(backPath),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('К форме'),
            ),
          ],
        ),
      ),
    );
  }

  _ResultView _calculatorView(Map<String, String> query) {
    final expression =
        '${query['a'] ?? '—'} ${query['op'] ?? '—'} ${query['b'] ?? '—'}';
    final result = calculate(query['a'], query['op'], query['b']);
    return switch (result) {
      CalcSuccess(:final value) => _ResultView(expression, formatCalc(value)),
      CalcFailure(:final message) => _ResultView(
        expression,
        message,
        isError: true,
      ),
    };
  }

  _ResultView _converterView(Map<String, String> query) {
    final amount = query['amount'] ?? '—';
    final from = query['from'] ?? '—';
    final to = query['to'] ?? '—';
    final expression = '$amount $from → $to';
    final result = convertCurrency(query['from'], query['to'], query['amount']);
    return switch (result) {
      ConvertSuccess(:final value) => _ResultView(
        expression,
        '${formatMoney(value)} $to',
      ),
      ConvertFailure(:final message) => _ResultView(
        expression,
        message,
        isError: true,
      ),
    };
  }
}

class _ResultView {
  const _ResultView(this.expression, this.outcome, {this.isError = false});

  final String expression;
  final String outcome;
  final bool isError;
}
