import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/manager/main_model.dart';
import 'package:flutter_grab/manager/splash_model.dart';
import 'package:flutter_grab/pages/home.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

// 闪屏展示页面，首次安装时展示可滑动页面，第二次展示固定图片
class SplashState extends State<SplashPage> {
  static const length = 3;
  final pageIndexNotifier = ValueNotifier<int>(0);

  SplashModel model = SplashModel();
  MainModel mainModel;

  @override
  void initState() {
    super.initState();
//    if (model == null) {
//      model = SplashModel();
//    }
    model.initValue();
    Future.delayed(Duration.zero, () {
      mainModel = mainModel ?? MainModel.of(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getContent());
  }

  _getContent() {
    if (model.showWelcome == true) {
      return _welcomePage();
    } else {
      return _splashPage(model.splashUrl, model.splashGoto);
    }
  }

  _clickWelcome() async {
//    model.clickWelcome();
    _gotoHomePage();
  }

  _gotoNextPage() {
    if (mainModel.userInfo != null) {
      _gotoHomePage();
    } else {
      _gotoLogin();
    }
  }

  _gotoHomePage() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => HomePage()));

  _gotoLogin() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginPage()));

  _welcomePage() {
    return Stack(
      alignment: FractionalOffset.bottomCenter,
      children: <Widget>[
        PageView.builder(
            onPageChanged: (index) => pageIndexNotifier.value = index,
            itemCount: length,
            itemBuilder: (context, index) {
              return Container(
                constraints: BoxConstraints.expand(
                  width: double.infinity,
                  height: double.infinity,
                ),
                child: _getWelcomeView(index),
              );
            }),
        PageViewIndicator(
          pageIndexNotifier: pageIndexNotifier,
          length: length,
          normalBuilder: (animationController, index) => Circle(
            size: 8.0,
            color: Colors.black87,
          ),
          highlightedBuilder: (animationController, index) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animationController,
              curve: Curves.ease,
            ),
            child: Circle(
              size: 8.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  _getWelcomeView(int index) {
    final image = model.imagesList[index];
    final tip = model.splashTip;
    print("INFO. index=$index  image=$image  tip=$tip");
    if (index == 2) {
      return _getWelcome3(image, tip);
    } else {
      return _getWelcome1(image);
    }
  }

  _getWelcome1(String path) {
    return Container(
      constraints: BoxConstraints.expand(
        width: double.infinity,
        height: double.infinity,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(image: ExactAssetImage(path), fit: BoxFit.cover),
      ),
    );
  }

  _getWelcome3(String path, String tip) {
    return Container(
      constraints: BoxConstraints.expand(
        width: double.infinity,
        height: double.infinity,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(image: ExactAssetImage(path), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(tip, style: splashFont),
          ),
          Container(
            alignment: Alignment.center,
            child: MaterialButton(
              color: Colors.white,
              onPressed: _clickWelcome,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: Text(
                '立即启程',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _splashPage(String image, String action) {
    Timer(const Duration(seconds: SPLASH_TIME), () {
      _gotoNextPage();
    });
    if (image != null) {
      return GestureDetector(
        onTap: () {
          launch(action);
        },
        child: Container(
            constraints: BoxConstraints.expand(
              width: double.infinity,
              height: double.infinity,
            ),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            ),
            decoration: BoxDecoration()),
      );
    } else {
      return Container(
        constraints: BoxConstraints.expand(
          width: double.infinity,
          height: double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage('images/welcome.png'), fit: BoxFit.cover),
        ),
      );
    }
  }
}

final TextStyle splashFont = const TextStyle(
    fontSize: 27.0,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: Colors.white);
final TextStyle splashFontNow = const TextStyle(
    fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.black);
