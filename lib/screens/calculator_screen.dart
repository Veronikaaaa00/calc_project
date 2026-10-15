import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../widgets/app_shell.dart';
import '../widgets/narrow_body.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  String _operation = '+';

  static const _operations = ['+', '-', '*', '/'];

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final a = _aController.text.trim().replaceAll(',', '.');
    final b = _bController.text.trim().replaceAll(',', '.');
    final location = Uri(
      path: '/calculator/result',
      queryParameters: {'a': a, 'op': _operation, 'b': b},
    ).toString();
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppShell(
      title: 'Калькулятор',
      body: NarrowBody(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Два числа и операция',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'После вычисления откроется отдельный экран. Параметры уйдут в адрес.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _aController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Первое число',
                  prefixIcon: Icon(Icons.looks_one_outlined),
                ),
                validator: validateNumber,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _operation,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Операция',
                  prefixIcon: Icon(Icons.functions_rounded),
                ),
                items: [
                  for (final operation in _operations)
                    DropdownMenuItem(
                      value: operation,
                      child: Text(
                        operation,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                            ),
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _operation = value ?? '+'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Второе число',
                  prefixIcon: Icon(Icons.looks_two_outlined),
                ),
                validator: validateNumber,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Вычислить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
