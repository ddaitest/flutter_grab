import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  String localVersionName = '';
  String telphoneNum = '1234567';
  String thirdMessage = '';

  initValue() async {
    var dialogDataMap = await getDialogData();
    setState(() {
      thirdMessage = dialogDataMap["message"];
    });
  }

  @override
  void initState() {
    super.initState();
    _getVersion();
    initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "关于我们",
            style: textStyle1,
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorPrimaryDark,
              ),
              onPressed: () => Navigator.of(context).pop(null)),
        ),
        body: _getBody());
  }

  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    localVersionName = packageInfo.version;
    return localVersionName;
  }

  _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
//              padding: EdgeInsets.only(top: 100.0),
              child: Image.asset(
                'images/icon.png',
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0),
              child: Text(
                localVersionName,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Container(
//          padding: EdgeInsets.only(top: 50.0),
          child: Text(
            thirdMessage,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
        Container(
//          padding: const EdgeInsets.only(top: 100.0),
          child: FlatButton(
            onPressed: () {
              launchcaller('tel:' + telphoneNum);
            },
            child: Column(
              children: <Widget>[
                Text(
                  '联系电话：' + telphoneNum,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
