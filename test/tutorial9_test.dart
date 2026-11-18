import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Finder _field(String key) => find.byKey(ValueKey(key));

void _viewport(WidgetTester tester, Size size, {double textScale = 1}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String key, String value) async {
  final field = _field(key);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> _openForm(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await _tapVisible(tester, find.text('Add Project'));
  expect(find.byType(ProjectFormPage), findsOneWidget);
  // Let the card's transient feedback dismiss before tapping the bottom Save.
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Add Project pushes a route; Back returns to the same menu', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final home = tester.element(find.byType(MyHomePage));
    await _tapVisible(tester, find.text('Add Project'));
    final context = tester.element(find.byType(ProjectFormPage));
    expect(Navigator.of(context).canPop(), isTrue);
    expect(find.text('You pressed the Add Project button!'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(tester.element(find.byType(MyHomePage)), same(home));
    expect(find.byType(ProjectFormPage), findsNothing);
  });

  testWidgets('drawer switches screens by replacement and closes itself', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    var drawer = find.byType(Drawer);
    await tester.tap(
      find.descendant(of: drawer, matching: find.text('Add Project')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    var context = tester.element(find.byType(ProjectFormPage));
    expect(Navigator.of(context).canPop(), isFalse);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    drawer = find.byType(Drawer);
    final selected = tester.widget<ListTile>(
      find.descendant(
        of: drawer,
        matching: find.widgetWithText(ListTile, 'Add Project'),
      ),
    );
    expect(selected.selected, isTrue);
    await tester.tap(find.descendant(of: drawer, matching: find.text('Home')));
    await tester.pumpAndSettle();

    context = tester.element(find.byType(MyHomePage));
    expect(Navigator.of(context).canPop(), isFalse);
    expect(find.byType(ProjectFormPage), findsNothing);
    expect(find.text('2606816592'), findsOneWidget);
  });

  testWidgets('blank and whitespace-only fields cannot open confirmation', (
    tester,
  ) async {
    await _openForm(tester);
    await _type(tester, 'project-name', '   ');
    await _tapVisible(tester, find.text('Save'));
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Enter a project name.'), findsOneWidget);
    expect(find.text('Enter a project description.'), findsOneWidget);

    await _type(tester, 'project-name', 'My project');
    await _type(tester, 'project-description', '  ');
    await _tapVisible(tester, find.text('Save'));
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Enter a project name.'), findsNothing);
    expect(find.text('Enter a project description.'), findsOneWidget);
    final nameState = tester.state<FormFieldState<String>>(
      _field('project-name'),
    );
    expect(nameState.value, 'My project');
  });

  testWidgets(
    'confirmation shows all values; OK resets fields and backing state',
    (tester) async {
      _viewport(tester, const Size(900, 1000));
      await _openForm(tester);
      await _type(tester, 'project-name', '  Vehicle analytics  ');
      await _type(tester, 'project-description', 'Diagnostic data analysis');
      await _tapVisible(tester, _field('project-category'));
      await tester.tap(find.text('Data Science').last);
      await tester.pumpAndSettle();
      await _type(tester, 'project-technologies', 'Python, SQL');
      await _type(tester, 'project-link', 'https://example.com/project');
      await _tapVisible(tester, find.text('Save'));

      for (final value in [
        'Project Name: Vehicle analytics',
        'Description: Diagnostic data analysis',
        'Category: Data Science',
        'Technologies: Python, SQL',
        'Link: https://example.com/project',
      ]) {
        expect(find.text(value), findsOneWidget);
      }
      expect(find.text('Project added successfully!'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      for (final key in [
        'project-name',
        'project-description',
        'project-technologies',
        'project-link',
      ]) {
        expect(
          tester.state<FormFieldState<String>>(_field(key)).value ?? '',
          '',
        );
      }
      expect(
        tester.state<FormFieldState<String>>(_field('project-category')).value,
        'Web Development',
      );
      await _type(tester, 'project-name', 'Second project');
      await _type(tester, 'project-description', 'Only required fields');
      await _tapVisible(tester, find.text('Save'));
      expect(find.text('Category: Web Development'), findsOneWidget);
      expect(find.text('Technologies: Not provided'), findsOneWidget);
      expect(find.text('Link: Not provided'), findsOneWidget);
      expect(find.textContaining('Python, SQL'), findsNothing);
    },
  );

  testWidgets('form and confirmation remain scrollable with large text', (
    tester,
  ) async {
    _viewport(tester, const Size(320, 640), textScale: 1.8);
    await _openForm(tester);
    await _type(tester, 'project-name', 'Accessible project');
    await _type(tester, 'project-description', 'Long description. ' * 30);
    await _tapVisible(tester, find.text('Save'));
    expect(find.byType(AlertDialog), findsOneWidget);
    await _tapVisible(tester, find.text('OK'));
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
