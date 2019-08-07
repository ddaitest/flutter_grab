import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/manager/beans.dart';
import 'package:flutter_grab/manager/beans2.dart';
import 'package:flutter_grab/pages/detail.dart';

import 'widget/info_view.dart';

class ItemView2 extends StatelessWidget {
  final Event2 event;
  final Function onTap;

//  final int index;
//  final int type;

  ItemView2(this.event, this.onTap) {
//    remark = "价格：${event.money}";
  }

  @override
  Widget build(BuildContext context) {
    String remark = "价格：${event.money} 元";
    return GestureDetector(
      child: Container(
        decoration: getContainerBg2(),
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: event.money != null && event.money > 0
              ? <Widget>[
                  _getHeader(),
                  PADDING,
                  _getPickup(),
                  PADDING,
                  _getDropoff(),
                  PADDING,
                  _getDateTime(),
                  PADDING,
                  _getRemark(remark),
                ]
              : <Widget>[
                  _getHeader(),
                  PADDING,
                  _getPickup(),
                  PADDING,
                  _getDropoff(),
                  PADDING,
                  _getDateTime(),
                ],
        ),
      ),
      onTap: () => onTap(),
    );
  }

  /// 第一行: 头像, 电话, Action
  _getHeader() {
    var phone = event.mobile ?? "";
    if (phone.length > 7) {
      phone = phone.replaceRange(3, 7, "****");
    }

    return Row(
      children: <Widget>[
        _getAvatar(), //头像
        PADDING_H,
        Expanded(
          child: Text(
            phone,
            style: fontPhone,
          ),
          flex: 2,
        ), //电话
        _getAction(), //打电话
      ],
    );
  }

  ///起点
  _getPickup() => InfoView(
      icon: Icons.trip_origin,
      color: colorPick,
      info: event.start,
      style: textStyleInfo);

  ///终点
  _getDropoff() => InfoView(
      icon: Icons.trip_origin,
      color: colorDrop,
      info: event.end,
      style: textStyleInfo);

  ///出发时间
  _getDateTime() {
    final dt = DateTime.fromMillisecondsSinceEpoch(event.time);
    var date = dateFormat.format(dt);
    var time = timeFormat.format(dt);
    return InfoView(
      icon: Icons.access_time,
      color: c3,
      childs: <Widget>[
        Text(date, style: fontTime1, textAlign: TextAlign.left),
        PADDING_H,
        Expanded(
            child: Text(time, style: fontTime2, textAlign: TextAlign.left)),
      ],
    );
  }

  ///备注
  _getRemark(String remark) => Text(remark, style: fontX);

  ///头像
  _getAvatar() => getMainIcon(event.publishType ?? "");

//    return getRoundIcon(getIcon(type));

  ///打电话
  _getAction() {
    return InkWell(
      onTap: () {
        launchcaller('tel:' + event.mobile);
      },
      child: getRoundIcon(Icons.call),
    );
  }
}
