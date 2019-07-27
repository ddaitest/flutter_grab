import 'package:shared_preferences/shared_preferences.dart';

class AccountManager {
  static const String KEY = "ACCOUNT";

  static Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY) != null;
  }

  static Future saveAccount(String accountJSON) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY, accountJSON);
  }
}
