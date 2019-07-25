import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_grab/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

// SingleTickerProviderStateMixin is used for animation
class SplashState extends State<SplashPage> {

  bool update = true;
  String updateURL = "";
  String updateMessage = "";

//  // Create a tab controller
//
//  TabController controller;
//  int page = 0;
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  checkVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      update = prefs.getBool("update") ?? true;
      updateURL = prefs.getString("updateURL") ?? "http://www.baidu.com";
      updateMessage = prefs.getString("updateMessage") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    checkVersion();
    Timer(const Duration(seconds: 2), () {
//      Navigator.popAndPushNamed(context, '/home');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
//      Navigator.pop(context);
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => HomePage()),
//      );
//      Navigator.pushNamed(context, routeName)
//      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getContent(),
          ),
        ),
      ),
    );
  }

  getContent() {
    if (update) {
      return <Widget>[
        Text(
          "请升级版本",
          style: fontCall,
        ),
        Text(
          updateMessage,
          style: fontCall,
        ),
        RaisedButton(
          onPressed: () {
            launch(updateURL);
          },
          child: Text("更新"),
        )
      ];
    } else {
      return <Widget>[
        Text(
          "HELLO WORLD",
          style: fontCall,
        ),
      ];
    }
  }
}
