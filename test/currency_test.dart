import 'package:calc_web/logic/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('в списке не меньше пяти валют', () {
    expect(currencies.length, greaterThanOrEqualTo(5));
    expect(findCurrency('USD'), isNotNull);
    expect(findCurrency('EUR'), isNotNull);
  });

  test('10 USD конвертируются в рубли по константному курсу', () {
    final result = convertCurrency('USD', 'RUB', '10') as ConvertSuccess;
    expect(result.value, closeTo(925, 0.000001));
    expect(formatMoney(result.value), '925.00');
  });

  test('обратная конвертация RUB в EUR', () {
    final result = convertCurrency('RUB', 'EUR', '100.2') as ConvertSuccess;
    expect(result.value, closeTo(1, 0.000001));
  });

  test('одинаковая валюта оставляет сумму', () {
    final result = convertCurrency('KZT', 'KZT', '15') as ConvertSuccess;
    expect(result.value, closeTo(15, 0.000001));
  });

  test('нечисловая сумма', () {
    final result = convertCurrency('USD', 'EUR', 'много');
    expect(result, isA<ConvertFailure>());
    expect((result as ConvertFailure).message, 'В адресе переданы не числа');
  });

  test('неизвестная валюта', () {
    final result = convertCurrency('USD', 'BTC', '1');
    expect(result, isA<ConvertFailure>());
    expect((result as ConvertFailure).message, 'Неизвестная валюта');
  });

  test('отсутствует обязательный параметр', () {
    expect(convertCurrency(null, 'RUB', '1'), isA<ConvertFailure>());
    expect(convertCurrency('USD', 'RUB', ''), isA<ConvertFailure>());
  });

  test('запятая в сумме', () {
    final result = convertCurrency('EUR', 'EUR', '2,5') as ConvertSuccess;
    expect(result.value, closeTo(2.5, 0.000001));
    expect(formatMoney(result.value), '2.50');
  });
}
