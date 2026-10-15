import 'package:flutter/material.dart';

import 'page_entrance.dart';

/// Колонка ограниченной ширины: форма не растягивается на широкий монитор
/// и остаётся читаемой на узком окне.
class NarrowBody extends StatelessWidget {
  const NarrowBody({
    required this.child,
    this.maxWidth = 440,
    this.animate = true,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: child,
            ),
          ),
        );
        if (animate) {
          content = PageEntrance(child: content);
        }
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: content,
          ),
        );
      },
    );
  }
}
