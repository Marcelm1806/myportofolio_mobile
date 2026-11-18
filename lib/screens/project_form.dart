import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  static const _defaultCategory = 'Web Development';
  static const _categories = [
    _defaultCategory,
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  String _projectName = '';
  String _description = '';
  String _category = _defaultCategory;
  String _technologies = '';
  String _projectLink = '';
  bool _confirming = false;

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    if (_confirming || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // Capture a snapshot, so the confirmation always matches this submission.
    final values = [
      ('Project Name', _projectName.trim()),
      ('Description', _description.trim()),
      ('Category', _category),
      ('Technologies', _technologies.trim()),
      ('Link', _projectLink.trim()),
    ];
    setState(() => _confirming = true);
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Project added successfully!'),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (label, value) in values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '$label: ${value.isEmpty ? 'Not provided' : value}',
                ),
              ),
            const Text('Preview only. This entry has not been stored.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      _formKey.currentState!.reset();
      // Reset backing values as well as field widgets: otherwise the next
      // submission could display stale optional text or the previous category.
      _projectName = '';
      _description = '';
      _category = _defaultCategory;
      _technologies = '';
      _projectLink = '';
    }
    setState(() => _confirming = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          if (Navigator.of(context).canPop())
            IconButton(
              tooltip: 'Back to portfolio',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
        ],
      ),
      drawer: const LeftDrawer(currentPage: PortfolioPage.addProject),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Share a project',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Review your entry in the confirmation. '
                      'Required fields are marked *.',
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const ValueKey('project-name'),
                      decoration: _decoration('Project Name *'),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) => _projectName = value,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter a project name.'
                          : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      key: const ValueKey('project-description'),
                      decoration: _decoration('Project Description *'),
                      minLines: 3,
                      maxLines: 5,
                      onChanged: (value) => _description = value,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter a project description.'
                          : null,
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      key: const ValueKey('project-category'),
                      decoration: _decoration('Project Category'),
                      initialValue: _defaultCategory,
                      isExpanded: true,
                      items: [
                        for (final category in _categories)
                          DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _category = value);
                      },
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      key: const ValueKey('project-technologies'),
                      decoration: _decoration(
                        'Technologies Used',
                        hint: 'Example: Python, Django, Flutter',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) => _technologies = value,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      key: const ValueKey('project-link'),
                      decoration: _decoration(
                        'Project Link',
                        hint: 'https://example.com (optional)',
                      ),
                      keyboardType: TextInputType.url,
                      onChanged: (value) => _projectLink = value,
                    ),
                    const SizedBox(height: 22),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: _confirming ? null : _submit,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
