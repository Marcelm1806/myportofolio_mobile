import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/widgets/project_preview.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const _viewProjects = ItemHomepage(
    name: 'View Projects',
    icon: Icons.folder_open_rounded,
    color: Color(0xFF254C62),
  );
  static const _items = [
    _viewProjects,
    ItemHomepage(
      name: 'Add Project',
      icon: Icons.add_circle_outline_rounded,
      color: Color(0xFF315744),
    ),
    ItemHomepage(
      name: 'Logout',
      icon: Icons.logout_rounded,
      color: Color(0xFF9A3F2C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyPortfolio',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      drawer: const LeftDrawer(currentPage: PortfolioPage.home),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Introduction(),
                  const SizedBox(height: 14),
                  const _CardGroup(
                    children: [
                      InfoCard(title: 'NPM', content: '2606816592'),
                      InfoCard(title: 'Name', content: 'Marcel Mikula'),
                      InfoCard(title: 'Class', content: 'PBP A'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Semantics(
                    header: true,
                    child: Text(
                      'Portfolio actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _CardGroup(
                    children: [
                      for (final item in _items)
                        ItemCard(
                          item,
                          onNavigate: item.name == 'Add Project'
                              ? () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const ProjectFormPage(),
                                  ),
                                )
                              : null,
                          onPreview: item == _viewProjects
                              ? () => showProjectPreview(context)
                              : null,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ProjectHighlight(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Introduction extends StatelessWidget {
  const _Introduction();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF29221E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACADEMIC PORTFOLIO',
              style: textTheme.labelSmall?.copyWith(
                color: const Color(0xFFF4AF97),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              header: true,
              child: Text(
                'Data & AI in practice',
                style: textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFFFFFCF8),
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'University projects at the intersection of data and business.',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFE7D9CE),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardGroup extends StatelessWidget {
  const _CardGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const gap = 10.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Let long labels and large accessibility text grow vertically.
        final fitsInRow =
            constraints.maxWidth >= 320 &&
            MediaQuery.textScalerOf(context).scale(14) <= 17;
        if (fitsInRow) {
          return Row(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0) const SizedBox(width: gap),
                Expanded(child: children[index]),
              ],
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(height: gap),
              children[index],
            ],
          ],
        );
      },
    );
  }
}
