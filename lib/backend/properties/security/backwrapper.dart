import 'package:safezone/backend/properties/import.dart';

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
    return PopScope(
      canPop: !disableBack, // prevents Android back button
      onPopInvoked: (didPop) {
        if (disableBack && !didPop) {
          // If user tries to swipe or system-back, ignore it
          return;
        }
      },
      child: child,
    );
  }
}