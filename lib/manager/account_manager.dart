import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'beans2.dart';

class AccountManager {
  static const String KEY = "ACCOUNT";

//  static Future<bool> isLogin() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    print("AccountManager.isLogin() ${(prefs.getString(KEY) != null)}");
//    return prefs.getString(KEY) != null;
//  }

  static Future<bool> saveAccount(String accountJSON) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("AccountManager.saveAccount()");
    prefs.setString(KEY, accountJSON);
    return true;
  }

  static Future<UserInfo> getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(KEY) ?? "";
    if (jsonData.isNotEmpty) {
      final parsed = json.decode(jsonData);
      return UserInfo.fromJson(parsed);
    }
    return null;
  }

  static Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("AccountManager.logout()");
    return prefs.remove(KEY);
  }


}
