import 'package:flutter/material.dart';

import 'calc_app_bar.dart';
import 'studio_backdrop.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.body,
    this.floating = false,
    super.key,
  });

  final String title;
  final Widget body;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    return StudioBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CalcAppBar(title: title, compact: floating),
        body: body,
      ),
    );
  }
}
