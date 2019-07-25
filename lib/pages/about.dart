import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  TextStyle listTitleStyle = TextStyle(fontSize: 18);
  TextStyle listSubTitleStyle = TextStyle(fontSize: 13);
  String localVersionName = '';
  String mobileTelphoneNum = '15801040555';
  String telphoneNum = '010-56422595';
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
              iconSize: 30,
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
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.asset(
              'images/icon.png',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '无忧车道',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Version $localVersionName',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
//                contentPadding: const EdgeInsets.all(5),
                title: Text(
                  '商务合作',
                  style: listTitleStyle,
                ),
                subtitle: Text(
                  '$mobileTelphoneNum  $telphoneNum',
                  style: listSubTitleStyle,
                ),
                onTap: _showPhoneCard,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 3.0),
              color: Colors.white,
              child: ListTile(
                title: Text('用户须知'),
                onTap: null,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 3.0),
              color: Colors.white,
              child: ListTile(
                title: Text('关于我们'),
                onTap: null,
              ),
            )
          ],
        )

//          Container(
//            child: FlatButton(
//              onPressed: () {
//                launchcaller('tel:' + telphoneNum);
//              },
//              child: Column(
//                children: <Widget>[
//                  Text(
//                    '联系电话：' + telphoneNum,
//                    style: TextStyle(fontSize: 20, color: Colors.black),
//                  ),
//                ],
//              ),
//            ),
//          ),
      ],
    ));
  }

  Future<void> _showPhoneCard() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: ListView(
            children: <Widget>[
              ListTile(
                title: Text('aaaaaaa'),
              ),
              ListTile(
                title: Text('aaaaaaa'),
              )
            ],
          ),
        );
      },
    );
  }
}
