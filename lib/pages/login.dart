import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/manager/account_manager.dart';
import 'package:flutter_grab/manager/api.dart';

import '../configs.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  bool showBack = false;

  @override
  State<StatefulWidget> createState() {
    return LoginState()..showBack = showBack;
  }
}

class LoginState extends State<LoginPage> {
//  int timer = 0;
  bool showBack = false;

  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  bool check = true;
  bool enableButton = true;
  int _counter = 0;

  _sendCode(BuildContext context) {
    setState(() {
      _counter = SMS_RESEND;
      enableButton = false;
    });
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          _counter--;
          if (_counter < 1) {
            timer.cancel();
            enableButton = true;
          }
        });
      },
    );
    LoginManager.sendCode(phoneController.text).then((result) {
      showSnackBar(context, result ? "发送成功" : "发送失败");
    }, onError: (e) {
      showSnackBar(context, "发送失败");
    });
  }

  _login(BuildContext context) {
    showLoadingDialog(context, "登录中");
    LoginManager.login(phoneController.text, codeController.text).then((uid) {
      LoginManager.getUserInfo(uid).then((result) {
        closeLoadingDialog(context);
        _gotoHomePage();
      });
    }, onError: (e) {
      closeLoadingDialog(context);
      showSnackBar(context, "登录失败");
    });
  }

  _gotoHomePage() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => HomePage()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colorPrimaryDark,
            ),
            iconSize: showBack ? 32 : 0,
            onPressed: () => Navigator.of(context).pop(null)),
      ),
      body: Builder(builder: (BuildContext context) {
        return _getBody(context);
      }),
    );
  }

  Widget _getBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(40),
          children: <Widget>[
            Text(
              "Welcome",
              style: textStyle1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    )
                  ]),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: getDecoration("手机号："),
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                            decoration: getDecoration("验证码："),
                            controller: codeController,
                            keyboardType: TextInputType.number),
                      ),
                      SizedBox(width: 10),
                      MaterialButton(
                        minWidth: 100,
                        color: colorPrimary,
                        onPressed: () =>
                            enableButton ? _sendCode(context) : null,
                        child: Text(enableButton ? "发送验证码" : "等待 $_counter 秒",
                            style: textButtonSmall),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 30),
            MaterialButton(
              height: 55,
              elevation: 4,
              color: colorPrimary,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _login(context);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Text(
                '登陆 / 注册',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                    value: check,
                    activeColor: colorPrimary,
                    onChanged: (xx) {
                      setState(() {
                        check = xx;
                      });
                    }),
                Text("同意相关协议  ", style: textStyleLabel),
                Text(
                  "《XX用户协议》",
                  style: TextStyle(
                    fontSize: 15.0,
                    decoration: TextDecoration.underline,
                    color: colorPrimary,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            TEST
                ? MaterialButton(
                    height: 55,
                    elevation: 4,
                    color: colorPrimary,
                    onPressed: () {
                      _gotoHomePage();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Text(
                      " SKIP （debug）",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class LoginManager {
  static Future<bool> sendCode(String phone) async {
    Response response = await API2.sendCode(phone);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    return (resultCode == 200);
  }

  static Future<int> login(String phone, String code) async {
    Response response = await API2.login(phone, code);
    final parsed = json.decode(response.data);
    var resultData = parsed['data'];
    var resultCode = parsed['code'] ?? 0;
    if (resultCode == 200 && resultData != null) {
      return resultData['userId'] ?? -1;
    }
    return -1;
  }

  static Future<bool> getUserInfo(int uid) async {
    Response response = await API2.getUserInfo(uid);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    if (resultCode == 200) {
      return true;
    }
    return false;
  }
}
