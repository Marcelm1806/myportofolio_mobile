import 'package:flutter/material.dart';

/// The visual identity of one action, independent of how it is rendered.
@immutable
class ItemHomepage {
  const ItemHomepage({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}
