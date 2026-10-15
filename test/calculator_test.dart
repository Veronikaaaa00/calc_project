import 'package:calc_web/logic/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('сложение', () {
    final result = calculate('2', '+', '3') as CalcSuccess;
    expect(result.value, 5);
  });

  test('вычитание', () {
    final result = calculate('10', '-', '4') as CalcSuccess;
    expect(result.value, 6);
  });

  test('умножение', () {
    final result = calculate('6', '*', '7') as CalcSuccess;
    expect(result.value, 42);
  });

  test('деление', () {
    final result = calculate('8', '/', '2') as CalcSuccess;
    expect(result.value, 4);
  });

  test('деление на ноль', () {
    final result = calculate('1', '/', '0');
    expect(result, isA<CalcFailure>());
    expect((result as CalcFailure).message, 'Деление на ноль невозможно');
  });

  test('нечисловой ввод', () {
    final result = calculate('abc', '+', '1');
    expect(result, isA<CalcFailure>());
    expect((result as CalcFailure).message, 'В адресе переданы не числа');
  });

  test('неизвестная операция', () {
    final result = calculate('2', '^', '3');
    expect(result, isA<CalcFailure>());
    expect((result as CalcFailure).message, 'Неизвестная операция');
  });

  test('отсутствует обязательный параметр', () {
    expect(calculate(null, '+', '1'), isA<CalcFailure>());
    expect(calculate('1', null, '1'), isA<CalcFailure>());
    expect(calculate('1', '+', ''), isA<CalcFailure>());
  });

  test('запятая принимается как десятичный разделитель', () {
    final result = calculate('1,5', '+', '2,25') as CalcSuccess;
    expect(result.value, closeTo(3.75, 0.000001));
  });

  test('результат округляется и не печатает длинный хвост double', () {
    final result = calculate('10', '/', '3') as CalcSuccess;
    expect(formatCalc(result.value), '3.333333');
    expect(formatCalc(5), '5');
    expect(formatCalc(1.5), '1.5');
  });

  test('пустое поле и нечисло не проходят валидацию формы', () {
    expect(validateNumber(null), 'Введите число');
    expect(validateNumber('   '), 'Введите число');
    expect(validateNumber('два'), 'Это не число');
    expect(validateNumber('3,5'), isNull);
  });
}
