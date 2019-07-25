import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/manager/api.dart';
import 'package:flutter_grab/manager/beans.dart';
import 'package:package_info/package_info.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashModel extends Model {
  /// Wraps [ScopedModel.of] for this [Model].
  static SplashModel of(BuildContext context) =>
      ScopedModel.of<SplashModel>(context, rebuildOnChange: true);

  var _imagesList = [
    'images/welcome.png',
    'images/welcome2.jpg',
    'images/welcome3.jpeg'
  ];
  String _splashTip = "在你需要的每个地方\n载着你去往每个地方\n无佣金，乘客少花钱\n不抽成，车主多挣钱";
  bool _showWelcome = false;

  String _splashUrl;

  String _splashGoto;

  String get splashUrl => _splashUrl;

  String get splashGoto => _splashGoto;

  get imagesList => _imagesList;

  String get splashTip => _splashTip;

  bool get showWelcome => _showWelcome;

  initValue() async {
    _queryAdData();
    _queryUpdateData();
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    _showWelcome = prefs.getBool("welcome") ?? true;
//    _splashUrl = prefs.getString("splash_url") ?? null;
//    _splashGoto = prefs.getString("splash_goto") ?? null;
//    notifyListeners();
  }

//  clickWelcome() async {
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    sharedPreferences.setBool("welcome", false);
//  }

  ///广告数据
  _queryAdData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("ERROR. packageInfo.version ${packageInfo.version}");
    print("ERROR. packageInfo.buildNumber ${packageInfo.buildNumber}");

    Response response = await API.queryAD();
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    var resultData = parsed['data'];
    if (resultCode == 200 && resultData != null) {
      final newData =
          resultData.map<AdInfo>((json) => AdInfo.fromJson(json)).toList();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      for (var ad in newData) {
        switch (ad.type) {
          case 0: //Splash
            sharedPreferences.setString("splash_url", ad.image);
            sharedPreferences.setString("splash_goto", ad.action);
            break;
          case 1: //Home
            sharedPreferences.setString("showCard_url", ad.image);
            sharedPreferences.setString("showCard_goto", ad.action);
            break;
          case 2: //List

            break;
        }
      }
    }
  }

  ///升级数据
  _queryUpdateData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Response response =
        await API.queryUpgrade(packageInfo.version, packageInfo.buildNumber);
    final parsed = json.decode(response.data);
    final resultData = UpdateInfo.fromJson(parsed);
    if (resultData.code == 200 && resultData != null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool("is_force", resultData.isForce);
      sharedPreferences.setString("version", resultData.version);
      sharedPreferences.setInt("build_name", resultData.buildName);
      sharedPreferences.setString("message", resultData.message);
      sharedPreferences.setString("ios_url", resultData.iosUrl);
      sharedPreferences.setString("android_url", resultData.androidUrl);
    }
  }
}
