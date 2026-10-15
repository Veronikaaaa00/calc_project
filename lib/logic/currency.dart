/// Валюта и её курс: сколько рублей стоит одна единица.
class Currency {
  const Currency({
    required this.code,
    required this.title,
    required this.rubPerUnit,
  });

  final String code;
  final String title;
  final double rubPerUnit;
}

const currencyFromPrefKey = 'currency_from';
const currencyToPrefKey = 'currency_to';

const currencies = <Currency>[
  Currency(code: 'RUB', title: 'Российский рубль', rubPerUnit: 1),
  Currency(code: 'USD', title: 'Доллар США', rubPerUnit: 92.5),
  Currency(code: 'EUR', title: 'Евро', rubPerUnit: 100.2),
  Currency(code: 'CNY', title: 'Китайский юань', rubPerUnit: 12.8),
  Currency(code: 'GBP', title: 'Фунт стерлингов', rubPerUnit: 118.4),
  Currency(code: 'KZT', title: 'Казахстанский тенге', rubPerUnit: 0.19),
];

Currency? findCurrency(String? code) {
  if (code == null) {
    return null;
  }
  for (final currency in currencies) {
    if (currency.code == code) {
      return currency;
    }
  }
  return null;
}

sealed class ConvertResult {
  const ConvertResult();
}

class ConvertSuccess extends ConvertResult {
  const ConvertSuccess(this.value);

  final double value;
}

class ConvertFailure extends ConvertResult {
  const ConvertFailure(this.message);

  final String message;
}

/// Конвертирует сумму через рубль как промежуточную валюту.
ConvertResult convertCurrency(
  String? fromCode,
  String? toCode,
  String? rawAmount,
) {
  final fromText = fromCode?.trim() ?? '';
  final toText = toCode?.trim() ?? '';
  final amountText = rawAmount?.trim() ?? '';
  if (fromText.isEmpty || toText.isEmpty || amountText.isEmpty) {
    return const ConvertFailure('В адресе не хватает параметров');
  }

  final from = findCurrency(fromText);
  final to = findCurrency(toText);
  if (from == null || to == null) {
    return const ConvertFailure('Неизвестная валюта');
  }

  final amount = double.tryParse(amountText.replaceAll(',', '.'));
  if (amount == null) {
    return const ConvertFailure('В адресе переданы не числа');
  }

  final rubles = amount * from.rubPerUnit;
  return ConvertSuccess(rubles / to.rubPerUnit);
}

/// Денежная сумма с двумя знаками после запятой.
String formatMoney(double value) {
  if (!value.isFinite) {
    return 'Некорректный результат';
  }
  return value.toStringAsFixed(2);
}
