import 'package:flutter/material.dart';
import 'package:flutter_grab/common/ItemView2.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/widget/page_title.dart';
import 'package:flutter_grab/manager/beans2.dart';
import 'package:flutter_grab/manager/main_model.dart';

import 'publish.dart';

class HistoryPage extends StatelessWidget {
  final num uid;

  HistoryPage(this.uid);

  @override
  Widget build(BuildContext context) {
    return getCommonScaffold(
      "发布历史",
      body: FutureBuilder(
        future: MainModel.history(uid),
        builder: (BuildContext context, AsyncSnapshot<List<Event2>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView(
                children: snapshot.data.map<Widget>((event) {
                  return ItemView2(event, () {});
                }).toList(),
              );
            }
          }
          return CircularProgressIndicator();
        },
      ),
      onLeadingPressed: () => Navigator.of(context).pop(null),
    );
  }

//  _tap(Event2 event, BuildContext context) {
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: new Text("发布新信息？"),
//            content: new Text("复制内容，编辑后，然后发布新信息"),
//            actions: <Widget>[
//              // usually buttons at the bottom of the dialog
//              new FlatButton(
//                child: new Text("取消"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//              new FlatButton(
//                child: new Text("确认"),
//                onPressed: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => PublishPage(
//                              event.publishType == 1
//                                  ? PageType.FindVehicle
//                                  : PageType.FindPassenger)));
//                },
//              ),
//            ],
//          );
//        });
//  }
}
