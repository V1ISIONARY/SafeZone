import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/main.dart';
import 'package:shake/shake.dart';

class ShakeDetectorService {
  final BuildContext context;
  late ShakeDetector detector;

  ShakeDetectorService(this.context) {
    _initShakeDetection();
  }

  void _initShakeDetection() {
    detector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) {
        _navigateToTargetPage();
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeThresholdGravity: 2.7,
    );
  }

  void _navigateToTargetPage() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      print('iz shakingggg');
      GoRouter.of(context).push('/sos-page');
    } else {
      print("Context is null");
    }
  }

  void stopListening() {
    detector.stopListening();
  }
}
