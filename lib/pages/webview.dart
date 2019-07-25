import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// ignore: must_be_immutable
class WebViewPage extends StatelessWidget {
  String title;
  String url;
  BuildContext context;
  WebViewPage(String title, String url) {
    this.title = title;
    this.url = url;
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop(100);

    ///弹出页面并传回int值100，用于上一个界面的回调
    return new Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    // TODO: implement build
    return new WillPopScope(
        child: new WebviewScaffold(
          url: url,
          appBar: new AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            title: new Text(
              title,
              style: new TextStyle(color: Colors.white),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
