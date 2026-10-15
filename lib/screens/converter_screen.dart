import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';
import '../widgets/app_shell.dart';
import '../widgets/narrow_body.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _from = 'USD';
  String _to = 'RUB';
  var _restored = false;

  @override
  void initState() {
    super.initState();
    _restorePair();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _restorePair() async {
    final prefs = await SharedPreferences.getInstance();
    final from = prefs.getString(currencyFromPrefKey);
    final to = prefs.getString(currencyToPrefKey);
    if (!mounted) {
      return;
    }
    setState(() {
      if (findCurrency(from) != null) {
        _from = from!;
      }
      if (findCurrency(to) != null) {
        _to = to!;
      }
      _restored = true;
    });
  }

  Future<void> _persistPair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(currencyFromPrefKey, _from);
    await prefs.setString(currencyToPrefKey, _to);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _persistPair();
    final amount = _amountController.text.trim().replaceAll(',', '.');
    final location = Uri(
      path: '/converter/result',
      queryParameters: {'from': _from, 'to': _to, 'amount': amount},
    ).toString();
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppShell(
      title: 'Конвертер',
      body: !_restored
          ? const Center(child: CircularProgressIndicator())
          : NarrowBody(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Из одной валюты в другую',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Курсы заданы константами: рубли за одну единицу валюты.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    DropdownButtonFormField<String>(
                      initialValue: _from,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Из валюты',
                        prefixIcon: Icon(Icons.south_west_rounded),
                      ),
                      items: _currencyItems(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _from = value);
                        _persistPair();
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _to,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'В валюту',
                        prefixIcon: Icon(Icons.north_east_rounded),
                      ),
                      items: _currencyItems(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _to = value);
                        _persistPair();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Сумма',
                        prefixIcon: Icon(Icons.payments_outlined),
                      ),
                      validator: validateNumber,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 16),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.secondary.withValues(
                          alpha: isDark ? 0.16 : 0.10,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _rateHint(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.swap_horiz_rounded),
                      label: const Text('Конвертировать'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<String>> _currencyItems() {
    return [
      for (final currency in currencies)
        DropdownMenuItem(
          value: currency.code,
          child: Text(
            '${currency.code} — ${currency.title}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ];
  }

  String _rateHint() {
    final from = findCurrency(_from);
    final to = findCurrency(_to);
    if (from == null || to == null) {
      return '';
    }
    final rate = from.rubPerUnit / to.rubPerUnit;
    return '1 ${from.code} = ${formatMoney(rate)} ${to.code}';
  }
}
