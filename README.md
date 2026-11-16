# MyPortfolio Mobile

A Flutter companion to my [Django portfolio](https://github.com/Marcelm1806/myportofolio), built for Platform-Based Programming at Universitas Indonesia. The home screen shows my student information, a portfolio action menu, and an offline preview of selected work.

- **Name:** Marcel Mikula
- **NPM:** 2606816592
- **Class:** PBP A

[Tutorial 08: Basic Flutter](https://pbp.cs.ui.ac.id/en/tutorial/tutorial-8.html) · [Assignment 7: Basic Flutter](https://pbp.cs.ui.ac.id/en/assignments/individual/tugas-7.html)

## Run locally

Use the Flutter SDK from Tutorial 08. This repository was created with Flutter 3.47.9 and Dart 3.13.7. Run the following commands from the project root with Flutter on your PATH:

```sh
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d chrome
```

To run on a configured iOS simulator or Android emulator, use its device ID from `flutter devices` in place of `chrome`. Assignment 7 needs no Django server, account, or external API.

On the home screen, check the NPM, Name, and Class cards. Tap each colored action and look for `You pressed the [Button Name] button!`. Tap **Preview** on the View Projects message, or **Browse project notes**, to see the three entries. Try a narrow window and larger system text to check the scrollable layout. Add Project and Logout only show feedback for this assignment; they do not save records or change a session.

## Code map

| Path | Responsibility |
| --- | --- |
| `lib/main.dart` | Starts the app and defines its Material 3 theme |
| `lib/menu.dart` | Stateless home page, owner information, and adaptive card layout |
| `lib/models/item_homepage.dart` | Immutable label, icon, and color for each action |
| `lib/widgets/info_card.dart` | Reusable labeled identity card |
| `lib/widgets/item_card.dart` | Tappable action card, ripple, and matching SnackBar |
| `lib/widgets/project_preview.dart` | Featured-project summary and scrollable preview sheet |
| `test/widget_test.dart` | Checks identity, color/contrast, all three messages, project preview, and narrow layout with large text |

The action colors are assigned once in the `ItemHomepage` data and used by the same `ItemCard` widget. `LayoutBuilder` uses the available content width, and the two card groups stack at narrow widths or large text sizes. The design reuses the cream, dark ink, and terracotta tones of the web portfolio; the action surfaces use blue, green, and rust.

Preparation on Flutter 3.47.9: analysis found no issues, all five widget tests passed, and the release web build completed. The widget tests cover the preview at 390 × 844 and the menu at 320 × 640 with text scaled to 180%. These checks do not constitute testing on a physical phone.

## Weekly progress

| Stage | Work |
| --- | --- |
| Tutorial 08 | Created the Flutter project, separated `main.dart` and `menu.dart`, made the home page stateless, and built the example cards. [Tutorial commit](https://github.com/Marcelm1806/myportofolio_mobile/commit/561a77e852bae9c8bf4687d6da888f399314fe99) |
| Assignment 7 | Replaced sample identity data, styled each action through the model, added the local preview and adaptive layout, replaced the starter counter test, and documented the implementation. |

Submit the final Assignment 7 commit URL from this public mobile repository in SCELE. The course deadline is November 16, 2026, 23:59 WIB.

## Reflections

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

## AI assistance

| My request | Assistance and verification |
| --- | --- |
| Check whether Assignment 7 is due and continue from my mobile repository using the usual patch workflow. | ChatGPT/Codex read the course specification and inspected the public Tutorial 08 commit before making changes. |
| Work from the existing portfolio and prepare the assignment as a patch. | The assistant drafted the Flutter widgets, local preview, tests, and README. It matched the Flutter/Dart versions to the repository and checked the prepared changes there. |

The existing Tutorial 08 commit and the Assignment 7 patch are separate. The starting code still contained sample identity fields and the default counter test; keeping the tutorial structure did not mean keeping those placeholders. The tests now exercise this portfolio's own buttons and layout. Automated checks cover the Flutter build and simulated widget interactions; I still review the interface on my device and check that I can explain the code and the reflection answers before submitting.
