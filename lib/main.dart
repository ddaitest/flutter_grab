import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_grab/manager/api.dart';
import 'package:flutter_grab/manager/main_model.dart';
import 'package:flutter_grab/pages/splash.dart';
import 'package:flutter_jpush/flutter_jpush.dart';
import 'package:flutter_umeng_analytics_fork/flutter_umeng_analytics_fork.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  MainModel mainModel = MainModel();
  @override
  void initState() {
    super.initState();
    _umeng();
    UMengAnalytics.beginPageView("StartUp");
    _startupJpush();
    API.init();
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<MainModel>(
        model: mainModel,
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: new SplashPage(),
//          routes: <String, WidgetBuilder>{
//            '/publish': (BuildContext context) => PublishPage(),
//            '/search': (BuildContext context) => SearchPage(),
//          },
        ));
  }

  dispose() {
    super.dispose();

    UMengAnalytics.endPageView("StartUp");
  }

  void _startupJpush() async {
    print("初始化jpush");
    await FlutterJPush.startup();
    print("初始化jpush成功");
  }

  _umeng() async {
    if (Platform.isAndroid)
      await UMengAnalytics.init('5cc481cc3fc19568a7000b7c',
          encrypt: true, reportCrash: false);
    else if (Platform.isIOS)
      UMengAnalytics.init('5cc4860a4ca357a1fe000190',
          encrypt: true, reportCrash: false);
  }
}
