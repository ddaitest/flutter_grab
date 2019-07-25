import 'package:flutter/material.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/manager/main_model.dart';
import 'package:flutter_grab/manager/beans.dart';
import 'package:intl/intl.dart';

final TextStyle fontTime = const TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.black87);
final TextStyle fontTarget = const TextStyle(
    fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.bold);
final TextStyle fontX = const TextStyle(fontSize: 14.0, color: Colors.black54);
final TextStyle fontCall =
    TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500);

final dateFormat = DateFormat("M月d日");
final timeFormat = DateFormat("HH:mm");

enum PageType { FindPassenger, FindVehicle }

String getTitle(PageType type) =>
    (type == PageType.FindPassenger ? "车找人" : "人找车");

enum PageDataStatus { READY, LOADING, ERROR_EMPTY }

///根据筛选条件，生成描述语句
String getDesc(SearchCondition condition) {
  String result = "筛选条件: ";
  if (condition.time != null) {
    final dt = new DateTime.fromMillisecondsSinceEpoch(condition.time);
    var time = DateFormat("M月d日 HH:mm").format(dt);
    result = result + "$time";
  }
  if (condition.pickup != null && condition.pickup.isNotEmpty) {
    result = result + " 从:${condition.pickup} ";
  }
  if (condition.dropoff != null && condition.dropoff.isNotEmpty) {
    result = result + " 到:${condition.dropoff}";
  }
  return result;
}

getIcon(int type) {
  if (type == 0) {
    return Icons.directions_car;
  } else {
    return Icons.record_voice_over;
  }
}

class ItemView extends StatelessWidget {
  final Event event;
  final int index;
  final int type;

  ItemView(this.event, this.index, this.type);

  _getAvatar() {
    return Container(
      width: 50,
      margin: EdgeInsets.only(left: 16, right: 16),
      height: 50,
      child: Icon(
        getIcon(type),
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
    );
  }

  _getStartTime() {
    final dt = new DateTime.fromMillisecondsSinceEpoch(event.time);
    return Row(
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: Colors.blueAccent,
          size: 20.0,
        ),
        SizedBox(width: 8.0),
        Text(
          new DateFormat("HH:mm  y年M月d日").format(dt),
          style: fontTime,
        ),
      ],
    );
  }

  _getStart2End() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              event.start ?? "start",
              style: fontTarget,
              textAlign: TextAlign.left,
            ),
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Icon(
              Icons.forward,
            ),
          ),
          Expanded(
            child: Text(
              event.end ?? "end",
              style: fontTarget,
              textAlign: TextAlign.center,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  _getRemark() {
    return Row(
      children: <Widget>[
        Text(
          event.remark ?? "remark",
          style: fontX,
        ),
      ],
    );
  }

  _getAction() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              event.phone ?? "phone",
              style: fontX,
            ),
          ],
        )),
        FlatButton(
          onPressed: () {
            launchcaller('tel:' + event.phone);
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.call,
                size: 16.0,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "打电话",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, right: 16),
      child: Row(
        children: <Widget>[
          _getAvatar(),
          Expanded(
            child: Column(
              children: event.remark != null && event.remark.isNotEmpty
                  ? <Widget>[
                      _getStartTime(),
                      _getStart2End(),
                      _getRemark(),
                      Divider(),
                      _getAction(),
                    ]
                  : <Widget>[
                      _getStartTime(),
                      _getStart2End(),
                      Divider(),
                      _getAction(),
                    ],
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
