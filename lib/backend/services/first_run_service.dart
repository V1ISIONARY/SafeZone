import 'package:shared_preferences/shared_preferences.dart';

class FirstRunService {
  static Future<bool> getFirstRunFlag(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Generate a unique key for each user
    bool? isFirstRun = prefs.getBool('isFirstRun_$userId');
    return isFirstRun == null || isFirstRun;
  }

  static Future<void> setFirstRunFlag(int userId, bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Set a unique key for each user
    prefs.setBool('isFirstRun_$userId', flag);
  }

  // Optional: these methods can be kept if needed globally (not user-specific)
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
