# MyPortfolio Mobile

A Flutter companion to my [Django portfolio](https://github.com/Marcelm1806/myportofolio), built for Platform-Based Programming at Universitas Indonesia. The home screen shows my student information, a portfolio action menu, and an offline preview of selected work. Tutorial 09 adds a shared navigation drawer and a project form with validation and a confirmation dialog.

- **Name:** Marcel Mikula
- **NPM:** 2606816592
- **Class:** PBP A

[Tutorial 08: Basic Flutter](https://pbp.cs.ui.ac.id/en/tutorial/tutorial-8.html) · [Assignment 7: Basic Flutter](https://pbp.cs.ui.ac.id/en/assignments/individual/tugas-7.html) · [Tutorial 09: Navigation and Forms](https://pbp.cs.ui.ac.id/en/tutorial/tutorial-9.html)

## Run locally

Use the Flutter SDK from Tutorial 08. This repository was created with Flutter 3.47.9 and Dart 3.13.7. Run the following commands from the project root with Flutter on your PATH:

```sh
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d chrome
```

To run on a configured iOS simulator or Android emulator, use its device ID from `flutter devices` in place of `chrome`. The current app needs no Django server, account, or external API. Tutorial 09 adds no dependencies.

On the home screen, check the NPM, Name, and Class cards. Tap each colored action and look for `You pressed the [Button Name] button!`. Tap **Preview** on the View Projects message, or **Browse project notes**, to see the three entries. Add Project now opens a form that previews its values in a confirmation dialog. Logout still only shows feedback. Try a narrow window and larger system text to check the scrollable layout.

## Code map

| Path | Responsibility |
| --- | --- |
| `lib/main.dart` | Starts the app and defines its Material 3 theme |
| `lib/screens/menu.dart` | Stateless home page, owner information, and adaptive card layout |
| `lib/models/item_homepage.dart` | Immutable label, icon, and color for each action |
| `lib/widgets/info_card.dart` | Reusable labeled identity card |
| `lib/widgets/project_card.dart` | Tappable action card, feedback, and an optional navigation callback |
| `lib/widgets/project_preview.dart` | Featured-project summary and scrollable preview sheet |
| `lib/widgets/left_drawer.dart` | Shared Home/Add Project navigation with a selected entry |
| `lib/screens/project_form.dart` | Stateful project form, validation, and data confirmation |
| `test/widget_test.dart` | Checks identity, color/contrast, all three messages, project preview, and narrow layout with large text |
| `test/tutorial9_test.dart` | Push/pop, drawer replacement, validation, confirmation, reset, and a narrow form at large text size |

The action colors are assigned once in the `ItemHomepage` data and used by the same `ItemCard` widget. `LayoutBuilder` uses the available content width, and the two card groups stack at narrow widths or large text sizes. The design reuses the cream, dark ink, and terracotta tones of the web portfolio; the action surfaces use blue, green, and rust.

Preparation on Flutter 3.47.9: analysis found no issues, all five widget tests passed, and the release web build completed. The widget tests cover the preview at 390 × 844 and the menu at 320 × 640 with text scaled to 180%. These checks do not constitute testing on a physical phone.

## Weekly progress

| Stage | Work |
| --- | --- |
| Tutorial 08 | Created the Flutter project, separated `main.dart` and `menu.dart`, made the home page stateless, and built the example cards. [Tutorial commit](https://github.com/Marcelm1806/myportofolio_mobile/commit/561a77e852bae9c8bf4687d6da888f399314fe99) |
| Assignment 7 | Replaced sample identity data, styled each action through the model, added the local preview and adaptive layout, replaced the starter counter test, and documented the implementation. |
| Tutorial 09 | Continued from Assignment 7 commit `a7627e5`, added the drawer and project form, and refactored screens and the action card. |

Assignment 7's deadline was November 16, 2026, 23:59 WIB. The current Tutorial 09 handoff is documented below.

## Reflections

These answers describe the Assignment 7 version. The new screens and widgets are explained under Tutorial 09 below.

### Assignment 7

1. **Widget tree and parent-child relationships.** The widget tree describes how the UI is composed. Each parent configures one or more children. For example, `MyApp` builds `MaterialApp`, whose home is `MyHomePage`. The home page builds a `Scaffold`; its `Column` contains the introduction, the card groups, and the project highlight. A layout parent passes size constraints down to its children, and each child chooses a size within them. A widget can also read inherited data such as the theme from a parent above it.

2. **Widgets used in the app.** The table lists the widgets explicitly built in the application code. Calls such as `Theme.of`, `MediaQuery.textScalerOf`, `Navigator.of`, and `ScaffoldMessenger.of` use services or inherited data already in the tree; `showModalBottomSheet` opens the preview route.

   | Widget | Function |
   | --- | --- |
   | `MyApp`, `MaterialApp` | Start the portfolio UI and configure its title, theme, and home screen. |
   | `MyHomePage`, `Scaffold`, `AppBar` | Compose the home screen, provide its Material page structure, and show the title bar. |
   | `SafeArea`, `SingleChildScrollView`, `ListView` | Avoid screen edges or system overlays, scroll the home content, and scroll the preview entries. |
   | `Center`, `Align`, `ConstrainedBox` | Center the content, align the preview close button, and constrain content width or card height. |
   | `_CardGroup`, `LayoutBuilder`, `Row`, `Column`, `Expanded` | Choose horizontal or vertical cards based on available space, arrange children, and share the row width. |
   | `Padding`, `SizedBox` | Add space around content and create consistent gaps. |
   | `_Introduction`, `DecoratedBox` | Build the welcome panel and paint its rounded background. |
   | `InfoCard`, `ProjectHighlight`, `Card` | Display one student field and the featured project in reusable card surfaces. |
   | `ItemCard`, `Material`, `InkWell` | Build one action, supply its colored Material surface, and handle taps with an ink response. |
   | `Text`, `Icon`, `Semantics` | Render labels and symbols and identify headings and actions to assistive technology. |
   | `SnackBar`, `SnackBarAction` | Show feedback for each tap and offer the optional project preview. |
   | `TextButton` (including `TextButton.icon`) | Open project notes and close the preview. |

3. **MaterialApp.** It sets up app-wide Material styling and common infrastructure such as navigation and the scaffold messenger. In this project, my root `MyApp` returns a `MaterialApp` that provides the shared colors and text styles. The `home` property establishes the initial page, and the navigation infrastructure lets the preview open and close without rebuilding the app from scratch.

4. **StatelessWidget and StatefulWidget.** Both are immutable widget configurations. A stateless widget depends on its constructor values and inherited inputs; it can still rebuild when those inputs change. A stateful widget has a separate `State` object that can keep values across rebuilds, such as editable form input or a selection. Calling `setState` signals that a rebuild is needed. `MyHomePage` can stay stateless because its menu is fixed and Flutter's `ScaffoldMessenger` and `Navigator` manage the feedback and preview state.

5. **BuildContext.** A context represents a widget's location in the tree. Inside `build`, `Theme.of(context)` gets the enclosing theme, while `MediaQuery.textScalerOf(context)` reads the text scale at the card group's position. The `ItemCard` tap uses its context below `MaterialApp` to find the `ScaffoldMessenger`, and the preview's close button uses the sheet's context to find its `Navigator`.

6. **Hot reload and hot restart.** Hot reload applies supported Dart changes in a debug session and rebuilds the affected UI while preserving current state. It is useful for changing the card layout or text. It does not rerun `main()` or initialization such as `initState()`. Use a hot restart when changed startup logic or initial values need to run again and the in-memory state can be reset. Changes to native host code, such as Kotlin or Swift, need a full stop and rebuild.

Reference: Flutter documentation on [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html) and [hot reload and restart](https://docs.flutter.dev/tools/hot-reload).

## Tutorial 09: Navigation, layouts, and forms

This implementation continues from [Assignment 7 commit a7627e5](https://github.com/Marcelm1806/myportofolio_mobile/commit/a7627e535450387e5b62b074768f3eec7740adbd). It preserves the personal content, theme, and project preview while adding the tutorial's new flow.

| Tutorial element | Implementation |
| --- | --- |
| Drawer | `LeftDrawer` is shared by Home and Add Project. It closes before switching routes and simply closes when the current entry is selected. |
| Push and pop | The Add Project card opens `ProjectFormPage` with `Navigator.push` and `MaterialPageRoute`; Back returns to the existing menu. |
| Replacement | The drawer uses `pushReplacement`. It replaces the current page; routes below it remain in the stack. |
| Form state | `ProjectFormPage` is stateful and owns a stable `GlobalKey<FormState>` and the input values. Home remains stateless. |
| Inputs | Project Name and Project Description are required after trimming. Category is a dropdown; Technologies Used and Project Link are optional text fields. |
| Categories | Web Development (default), Mobile Development, Machine Learning, Data Science, and Other. |
| Confirmation | Save validates the fields and shows all five values in a scrollable `AlertDialog`. Empty optional values read Not provided. |
| Reset | OK closes the dialog and resets the fields and backing values, including the default category. Repeated taps cannot open duplicate confirmations. |
| Organization | Screens are under `lib/screens/`, and the action card is in `lib/widgets/project_card.dart`. Affected imports are updated. |
| Layout | Both the form and confirmation scroll; the form has safe-area padding and a bounded content width. |

The tutorial's newer examples import `package:material_ui/material_ui.dart`. This Flutter 3.47.9 project already uses the SDK's Material widgets, so it keeps `package:flutter/material.dart` and adds no package. The dropdown uses `initialValue`.

The confirmation is a local preview: **no entry is added to a database, file, or in-memory portfolio list**. The existing project preview stays unchanged after submitting. Networking and storage come later. This implements Tutorial 09; Assignment 8 separately requires a form for the independently chosen portfolio section.

### Verify locally

Preparation on Flutter 3.47.9 and Dart 3.13.7 passed all **10 widget tests** (five existing, adapted where navigation changed, plus five new tests). `flutter analyze` found no issues, Dart formatting passed, and `flutter build web` completed successfully. The new layout test exercises the form and its long confirmation at 320 × 640 with text scaled to 180%. Native-device testing remains a local step.

Run `flutter analyze`, `flutter test`, and `flutter run -d chrome`, then check:

1. Open the drawer from Home. Select Add Project, then use its drawer to return Home. The drawer closes after navigation.
2. Open Add Project with its colored card. The form appears and Back returns to the existing menu.
3. Press Save with empty or whitespace-only required fields. Errors appear and no confirmation opens.
4. Fill the name, multiline description, category, technologies, and link. Save and compare all five values with the dialog.
5. Press OK. Text clears and Web Development is selected. Submit a second entry using only required fields and check that the old optional values do not reappear.
6. Try a narrow screen and larger text. Check that the form and dialog scroll and the original project preview still works.

The tutorial deadline is **Wednesday, November 18, 2026, at 23:59 WIB**. It is a prerequisite for Assignment 8, due **Monday, November 23, 2026, at 23:59 WIB**. Push the final public commit before the tutorial deadline and submit its **commit URL** through the Tutorial 09 slot in SCELE.

References: [official Tutorial 09](https://pbp.cs.ui.ac.id/en/tutorial/tutorial-9.html), [Flutter form validation](https://docs.flutter.dev/cookbook/forms/validation), and [FormState.reset](https://api.flutter.dev/flutter/widgets/FormState/reset.html).

## AI assistance

| My request | Assistance and verification |
| --- | --- |
| Check whether Assignment 7 is due and continue from my mobile repository using the usual patch workflow. | ChatGPT/Codex read the course specification and inspected the public Tutorial 08 commit before making changes. |
| Work from the existing portfolio and prepare the assignment as a patch. | The assistant drafted the Flutter widgets, local preview, tests, and README. It matched the Flutter/Dart versions to the repository and checked the prepared changes there. |
| Continue with the linked Tutorial 09 using the usual patch workflow. | ChatGPT/Codex checked the live course page and GitHub base, adapted the drawer and form to the existing theme, updated imports, added flow tests, and drafted this documentation. |

The existing Tutorial 08 commit and the Assignment 7 patch are separate. The starting code still contained sample identity fields and the default counter test; keeping the tutorial structure did not mean keeping those placeholders. The tests now exercise this portfolio's own buttons and layout. Automated checks cover the Flutter build and simulated widget interactions; I still review the interface on my device and check that I can explain the code and the reflection answers before submitting.

For Tutorial 09, the form resets its backing values as well as its visible fields. A second-submission test checks that old optional text and a previous category do not reappear. The generated patch was also checked against the exact public base commit. Automated tests do not verify keyboard behaviour or appearance on my Mac, and patch preparation does not submit anything to SCELE.
