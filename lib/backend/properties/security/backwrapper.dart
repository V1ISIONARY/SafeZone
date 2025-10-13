import 'package:flutter/material.dart';

class NoBackWrapper extends StatelessWidget {
  final Widget child;
  final bool disableBack;

  const NoBackWrapper({
    super.key,
    required this.child,
    this.disableBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If disableBack is true, prevent system back button
        return !disableBack; // false blocks back, true allows
      },
      child: child,
    );
  }
}