import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';

class LoginPage extends StatefulWidget {
  bool showBack = false;

  @override
  State<StatefulWidget> createState() {
    return LoginState()..showBack = showBack;
  }
}

class LoginState extends State<LoginPage> {
  int timer = 0;
  bool showBack = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
//          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorPrimaryDark,
              ),
              iconSize: showBack ? 16 : 0,
              onPressed: () => Navigator.of(context).pop(null)),
        ),
        body: _getBody());
  }

  _getBody() {
    return Container(
      color: Colors.grey,
    );
  }
}
