import 'package:calc_web/logic/currency.dart';
import 'package:calc_web/main.dart';
import 'package:calc_web/router.dart';
import 'package:calc_web/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ThemeController themeController;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      currencyFromPrefKey: 'GBP',
      currencyToPrefKey: 'CNY',
    });
    themeController = ThemeController();
    await themeController.load();
    appRouter.go('/');
  });

  testWidgets('формы, адрес результата, ошибки, тема и пара валют', (
    tester,
  ) async {
    await _pumpApp(tester, themeController);

    expect(find.text('Калькулятор'), findsWidgets);
    expect(find.text('Конвертер валют'), findsOneWidget);

    await tester.tap(find.text('Калькулятор').last);
    await tester.pumpAndSettle();
    expect(_uri.path, '/calculator');

    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();
    expect(find.text('Введите число'), findsNWidgets(2));
    expect(_uri.path, '/calculator');

    await tester.enterText(find.byType(TextFormField).at(0), 'abc');
    await tester.enterText(find.byType(TextFormField).at(1), '2');
    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();
    expect(find.text('Это не число'), findsOneWidget);
    expect(_uri.path, '/calculator');

    await tester.enterText(find.byType(TextFormField).at(0), '10');
    await tester.enterText(find.byType(TextFormField).at(1), '3');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('/').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();

    expect(_uri.path, '/calculator/result');
    expect(_uri.queryParameters['a'], '10');
    expect(_uri.queryParameters['op'], '/');
    expect(_uri.queryParameters['b'], '3');
    expect(find.text('3.333333'), findsOneWidget);
    expect(find.textContaining('10 / 3'), findsOneWidget);

    appRouter.go('/calculator/result?a=8&op=%2B&b=2');
    await tester.pumpAndSettle();
    expect(find.text('10'), findsOneWidget);

    appRouter.go('/calculator/result?a=1&op=%2F&b=0');
    await tester.pumpAndSettle();
    expect(find.text('Деление на ноль невозможно'), findsOneWidget);

    appRouter.go('/calculator/result?a=zz&op=%2B&b=1');
    await tester.pumpAndSettle();
    expect(find.text('В адресе переданы не числа'), findsOneWidget);

    appRouter.go(
      Uri(
        path: '/calculator/result',
        queryParameters: {'a': '2', 'op': '^', 'b': '3'},
      ).toString(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Неизвестная операция'), findsOneWidget);

    appRouter.go('/calculator/result');
    await tester.pumpAndSettle();
    expect(find.text('В адресе не хватает параметров'), findsOneWidget);

    appRouter.go('/qwerty');
    await tester.pumpAndSettle();
    expect(find.text('Такой страницы нет'), findsOneWidget);
    expect(find.textContaining('/qwerty'), findsOneWidget);

    await tester.tap(find.byTooltip('Тёмная тема'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
    final restoredTheme = ThemeController();
    await restoredTheme.load();
    expect(restoredTheme.mode, ThemeMode.dark);

    appRouter.go('/converter');
    await tester.pumpAndSettle();
    expect(find.text('GBP — Фунт стерлингов'), findsOneWidget);
    expect(find.text('CNY — Китайский юань'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '2');
    await tester.tap(find.text('Конвертировать'));
    await tester.pumpAndSettle();
    expect(_uri.path, '/converter/result');
    expect(_uri.queryParameters['from'], 'GBP');
    expect(_uri.queryParameters['to'], 'CNY');
    expect(_uri.queryParameters['amount'], '2');
    expect(find.text('18.50 CNY'), findsOneWidget);

    appRouter.go('/converter/result?from=USD&to=NOK&amount=5');
    await tester.pumpAndSettle();
    expect(find.text('Неизвестная валюта'), findsOneWidget);

    appRouter.go('/converter/result?from=USD&to=EUR');
    await tester.pumpAndSettle();
    expect(find.text('В адресе не хватает параметров'), findsOneWidget);

    await _expectNoOverflow(tester, const Size(360, 640));
    await _expectNoOverflow(tester, const Size(1920, 1080));
  });
}

Uri get _uri => appRouter.routeInformationProvider.value.uri;

Future<void> _pumpApp(WidgetTester tester, ThemeController themeController) {
  return tester.pumpWidget(CalcApp(themeController: themeController));
}

Future<void> _expectNoOverflow(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  appRouter.go('/');
  await tester.pumpAndSettle();
  appRouter.go('/calculator');
  await tester.pumpAndSettle();
  appRouter.go('/converter');
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}
