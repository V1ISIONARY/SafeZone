import 'package:shared_preferences/shared_preferences.dart';

class FirstRunService {
  static Future<bool> getFirstRunFlag(int userId, {bool defaultValue = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRunFlag = prefs.getBool('isFirstRunFlag_$userId');

    if (isFirstRunFlag == null) {
      await prefs.setBool('isFirstRunFlag_$userId', defaultValue);
      isFirstRunFlag = defaultValue;
    }

    print('Checking First Run for User ID: $userId, Flag: $isFirstRunFlag');
    return isFirstRunFlag;
  }

  static Future<void> setFirstRunFlag(int userId, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRunFlag_$userId', value);
    print('Setting First Run Flag for User ID: $userId to $value');
  }
  
}