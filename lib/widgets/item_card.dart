import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key, this.onPreview});

  final ItemHomepage item;
  final VoidCallback? onPreview;

  void _showFeedback(BuildContext context) {
    final preview = onPreview;
    // Replace an old message rather than queueing one for every quick tap.
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('You pressed the ${item.name} button!'),
          action: preview == null
              ? null
              : SnackBarAction(label: 'Preview', onPressed: preview),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: item.color,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showFeedback(context),
          focusColor: Colors.white24,
          hoverColor: Colors.white12,
          splashColor: Colors.white24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 106),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 26, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
