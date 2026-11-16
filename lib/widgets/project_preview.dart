import 'package:flutter/material.dart';

const _projects = [
  (
    context: 'Porsche · TU Darmstadt',
    title: 'Macan field quality analytics',
    summary:
        'Developed a co-occurrence approach to find diagnostic trouble codes '
        'that appeared together in vehicle data.',
  ),
  (
    context: 'ING · TU Darmstadt',
    title: 'Explainable AI for language models',
    summary:
        'Used SHAP to explain model predictions and helped prototype an '
        'interface for exploring them.',
  ),
  (
    context: 'University of Mannheim',
    title: 'Object-centric anomaly detection',
    summary:
        'Explored how process mining can detect unusual behaviour across '
        'related objects in an event log.',
  ),
];

void showProjectPreview(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) {
      final theme = Theme.of(context);
      return SafeArea(
        top: false,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          children: [
            Semantics(
              header: true,
              child: Text('Project preview', style: theme.textTheme.titleLarge),
            ),
            for (final project in _projects)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.context,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(project.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(project.summary, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close preview'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class ProjectHighlight extends StatelessWidget {
  const ProjectHighlight({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final featured = _projects.first;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SELECTED WORK · 01 / 03',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(featured.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(featured.context, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => showProjectPreview(context),
              icon: const Icon(Icons.arrow_outward_rounded, size: 18),
              label: const Text('Browse project notes'),
            ),
          ],
        ),
      ),
    );
  }
}
