import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

const _actions = ['View Projects', 'Add Project', 'Logout'];

void _setViewport(WidgetTester tester, Size size, {double textScale = 1}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

void main() {
  testWidgets('the three identity cards show the portfolio owner', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(InfoCard), findsNWidgets(3));
    for (final (label, value) in [
      ('NPM', '2606816592'),
      ('Name', 'Marcel Mikula'),
      ('Class', 'PBP A'),
    ]) {
      final card = find.widgetWithText(InfoCard, label);
      expect(
        find.descendant(of: card, matching: find.text(value)),
        findsOneWidget,
      );
    }
  });

  testWidgets('each action renders its own contrasting Material color', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(ItemCard), findsNWidgets(3));
    final colors = <Color>{};
    for (final name in _actions) {
      final card = find.widgetWithText(ItemCard, name);
      final material = tester.widget<Material>(
        find.descendant(of: card, matching: find.byType(Material)),
      );
      final color = material.color!;
      colors.add(color);
      // The action labels use white on the actual card surface.
      expect(
        1.05 / (color.computeLuminance() + 0.05),
        greaterThanOrEqualTo(4.5),
      );
    }
    expect(colors, hasLength(_actions.length));
  });

  testWidgets(
    'all actions show the matching SnackBar and replace old feedback',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      for (final name in _actions) {
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('You pressed the $name button!'), findsOneWidget);
        expect(find.byType(BottomSheet), findsNothing);
        if (name == 'Add Project') {
          expect(find.byType(ProjectFormPage), findsOneWidget);
          await tester.tap(find.byTooltip('Back to portfolio'));
          await tester.pumpAndSettle();
        }
      }
    },
  );

  testWidgets('preview from the View Projects SnackBar opens and closes', (
    tester,
  ) async {
    _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('View Projects'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview'));
    await tester.pumpAndSettle();

    final sheet = find.byType(BottomSheet);
    expect(sheet, findsOneWidget);
    expect(find.text('Project preview'), findsOneWidget);
    expect(find.text('ING · TU Darmstadt'), findsOneWidget);
    final close = find.text('Close preview');
    await tester.scrollUntilVisible(
      close,
      100,
      scrollable: find.descendant(of: sheet, matching: find.byType(Scrollable)),
    );
    expect(find.text('Object-centric anomaly detection'), findsOneWidget);
    await tester.tap(close);
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
    expect(find.text('Portfolio actions'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a narrow screen with large text can scroll to the last action', (
    tester,
  ) async {
    _setViewport(tester, const Size(320, 640), textScale: 1.8);
    await tester.pumpWidget(const MyApp());

    final view = find.widgetWithText(ItemCard, 'View Projects');
    final logout = find.widgetWithText(ItemCard, 'Logout');
    expect(tester.getTopLeft(view).dx, tester.getTopLeft(logout).dx);
    expect(tester.getTopLeft(view).dy, lessThan(tester.getTopLeft(logout).dy));

    await tester.ensureVisible(logout);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('You pressed the Logout button!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
