import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

enum PortfolioPage { home, addProject }

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, required this.currentPage});

  final PortfolioPage currentPage;

  void _navigate(BuildContext context, PortfolioPage page) {
    final navigator = Navigator.of(context);
    // Close the drawer first. Choosing the current entry needs no new route.
    navigator.pop();
    if (page == currentPage) return;
    navigator.pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => page == PortfolioPage.home
            ? const MyHomePage()
            : const ProjectFormPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MyPortfolio',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Marcel Mikula',
                    style: TextStyle(color: colors.onPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explore projects and share your work.',
                    style: TextStyle(color: colors.onPrimary),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selected: currentPage == PortfolioPage.home,
            onTap: () => _navigate(context, PortfolioPage.home),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            selected: currentPage == PortfolioPage.addProject,
            onTap: () => _navigate(context, PortfolioPage.addProject),
          ),
        ],
      ),
    );
  }
}
