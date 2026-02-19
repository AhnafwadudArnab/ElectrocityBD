import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  static const String _loggedInKey = 'electrocity_is_logged_in';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  static Future<void> clear() async {
    await setLoggedIn(false);
  }
}
