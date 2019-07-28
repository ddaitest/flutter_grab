import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void launchcaller(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

getRoundIcon(IconData icon) {
  return Container(
    width: 36,
//    margin: EdgeInsets.only(left: 16, right: 16),
    height: 36,
    child: Icon(
      icon,
      color: Colors.white,
      size: 22,
    ),
    decoration: BoxDecoration(
      color: colorPrimary,
      shape: BoxShape.circle,
      border: Border.all(color: colorPrimary, width: 2),
    ),
  );
}

/// return A positive number if a>b , negative number if a<b , 0 if a=b
int compareVersion(String a, String b) {
  var as = a.split(".").map((string) => int.tryParse(string));
  var bs = b.split(".").map((string) => int.tryParse(string));
  int x, y;
  for (var i = 0; i < as.length; i++) {
    x = as.elementAt(i);
    y = bs.elementAt(i);
    if (x != y) {
      break;
    }
  }
  return x - y;
}

///获取升级和弹窗广告数据
///如果有升级弹窗出现则不弹广告弹窗，如没有升级则弹广告弹窗，根据isForce判断
getDialogData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map dataMap = Map();
  dataMap["isForce"] = prefs.getBool("is_force") ?? false;
  dataMap["version"] = prefs.getString("version") ?? '';
  dataMap["buildName"] = prefs.getInt("build_name") ?? 0;
  dataMap["message"] = prefs.getString("message") ?? '';
  dataMap["iosUrl"] = prefs.getString("ios_url") ?? '';
  dataMap["androidUrl"] = prefs.getString("android_url") ?? '';
  dataMap["showCardUrl"] = prefs.getString("showCard_url") ?? "";
  dataMap["showCardGoto"] = prefs.getString("showCard_goto") ?? "";
  return dataMap;
}

showSnackBar(BuildContext context, String word) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(word, textAlign: TextAlign.center),
    backgroundColor: colorPrimary,
  ));
}

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}

Future<DialogDemoAction> showLoadingDialog(BuildContext context, String word) {
  return showDialog<DialogDemoAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(word),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                LinearProgressIndicator(),
              ],
            ),
          ),
        );
      });
}

closeLoadingDialog(BuildContext context) {
  Navigator.pop(context, DialogDemoAction.cancel);
}
