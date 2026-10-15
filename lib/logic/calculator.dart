/// Результат вычисления: либо значение, либо описание ошибки.
sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  const CalcSuccess(this.value);

  final double value;
}

class CalcFailure extends CalcResult {
  const CalcFailure(this.message);

  final String message;
}

/// Считает выражение по строкам из адреса.
///
/// Пустые и отсутствующие параметры, нечисловой ввод, неизвестная операция
/// и деление на ноль возвращают [CalcFailure], а не исключение.
CalcResult calculate(String? rawA, String? rawOp, String? rawB) {
  final aText = rawA?.trim() ?? '';
  final bText = rawB?.trim() ?? '';
  final op = rawOp?.trim() ?? '';
  if (aText.isEmpty || bText.isEmpty || op.isEmpty) {
    return const CalcFailure('В адресе не хватает параметров');
  }

  final a = double.tryParse(aText.replaceAll(',', '.'));
  final b = double.tryParse(bText.replaceAll(',', '.'));
  if (a == null || b == null) {
    return const CalcFailure('В адресе переданы не числа');
  }

  return switch (op) {
    '+' => CalcSuccess(a + b),
    '-' => CalcSuccess(a - b),
    '*' => CalcSuccess(a * b),
    '/' =>
      b == 0
          ? const CalcFailure('Деление на ноль невозможно')
          : CalcSuccess(a / b),
    _ => const CalcFailure('Неизвестная операция'),
  };
}

/// Округляет до 6 знаков после запятой и убирает хвостовые нули.
String formatCalc(double value) {
  if (!value.isFinite) {
    return 'Некорректный результат';
  }
  final fixed = value.toStringAsFixed(6);
  if (!fixed.contains('.')) {
    return fixed;
  }
  return fixed
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

/// Проверка поля ввода: пустая строка и нечисло не проходят.
String? validateNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Введите число';
  }
  if (double.tryParse(value.trim().replaceAll(',', '.')) == null) {
    return 'Это не число';
  }
  return null;
}
