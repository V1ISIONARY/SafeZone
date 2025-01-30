import 'package:shared_preferences/shared_preferences.dart';

class FirstRunService {
  static Future<bool> isFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRun = prefs.getBool('isFirstRun');
    return isFirstRun == null || isFirstRun;
  }

  static Future<void> setFirstRunCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstRun', false);
  }
}
