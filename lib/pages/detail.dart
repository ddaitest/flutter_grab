import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/widget/info_view.dart';
import 'package:flutter_grab/common/widget/page_title.dart';
import 'package:flutter_grab/manager/beans2.dart';
import 'package:flutter_grab/common/amapLoad.dart';
import 'package:flutter_grab/manager/main_model.dart';

class DetailPage extends StatefulWidget {
  final Event2 event;

  DetailPage(this.event);

  @override
  State<StatefulWidget> createState() {
    return _DetailState(event);
  }
}

class _DetailState extends State<DetailPage> {
  _DetailState(this.event);

  Event2 event;

//  String adForDetailUrl =
//      'https://img.zcool.cn/community/012de8571049406ac7251f05224c19.png@1280w_1l_2o_100sh.png';
  AMapController _controller;

  String seat;
  String remark;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getCommonScaffold(
      "详细信息",
      elevation: 4.0,
      onLeadingPressed: () => Navigator.of(context).pop(null),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: AMapView(
            onAMapViewCreated: (controller) {
              _controller = controller;
              print("11 _controller=$_controller");
              _controller.markerClickedEvent.listen((marker) {});
            },
            amapOptions: AMapOptions(
              compassEnabled: false,
              zoomControlsEnabled: true,
              logoPosition: LOGO_POSITION_BOTTOM_LEFT,
            ),
          ),
        ),
        Expanded(child: _getInfo()),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: _getActionPart(),
        ),
      ],
    );
  }

  _getInfo() {
    final dt = new DateTime.fromMillisecondsSinceEpoch(event.time);
    var date = dateFormat.format(dt);
    var time = timeFormat.format(dt);
    return Container(
      child: ListView(children: <Widget>[
        Container(
          decoration: getContainerBg2(),
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _getHeader(),
              PADDING,
              InfoView(
                  icon: Icons.trip_origin,
                  color: colorPick,
                  info: event.start,
                  style: textStyleInfo), //起点
              PADDING,
              InfoView(
                  icon: Icons.trip_origin,
                  color: colorDrop,
                  info: event.end,
                  style: textStyleInfo), //终点
              PADDING,
              _getDateTime(), //出发时间
              PADDING,
              InfoView(
                  icon: Icons.search,
                  color: colorDrop,
                  info: event.publishType == 1 ? "人找车" : "车找人",
                  style: textStyleInfo), //找人？找车？
              PADDING,
              InfoView(
                  icon: Icons.payment,
                  color: colorDrop,
                  info: "价格 ¥${event.money}",
                  style: textStyleInfo), //价格
              PADDING,
              InfoView(
                  icon: Icons.code,
                  color: colorDrop,
                  info: event.publishType == 1 ? "普通拼车" : "长期拼车",
                  style: textStyleInfo), //备注
              PADDING,
              InfoView(
                  icon: Icons.airline_seat_recline_normal,
                  color: colorDrop,
                  info: "座位 $seat",
                  style: textStyleInfo), //备注
              PADDING,
              InfoView(
                  icon: Icons.insert_comment,
                  color: colorDrop,
                  info: "备注 $remark",
                  style: textStyleInfo), //备注
              PADDING,
            ],
          ),
        )
      ]),
    );
    //座位，，备注，
  }

  Widget _getActionPart() {
    return getButtonBig("马上联系 ${event.mobile}",
        onPressed: () => launchcaller('tel:' + event.mobile));
  }

  _getHeader() {
    var phone = event.mobile;
    if (phone.length > 7) {
      phone = phone.replaceRange(3, 7, "****");
    }

    return Row(
      children: <Widget>[
        getMainIcon(event.publishType), //头像
        PADDING_H,
        Expanded(child: Text(phone, style: fontPhone), flex: 2), //电话
      ],
    );
  }

  ///出发时间
  _getDateTime() {
    final dt = DateTime.fromMillisecondsSinceEpoch(event.time);
    var date = datetimeFormat.format(dt);
    return InfoView(
      icon: Icons.access_time,
      color: c3,
      info: date,
    );
  }

  LatLng _parserLatLng(String text) {
    List<String> x = text.split(",");
    if (x.length == 2) {
      return LatLng(double.tryParse(x[1]), double.tryParse(x[0]));
    }
    return null;
  }

  _refreshData() {
    MainModel.getEventDetail(event.id).then((ev) {
      print("_refreshData = $ev");
      _drawMap(ev);
      setState(() {
        seat = "${ev.seat ?? ""}";
        remark = "${ev.remark ?? ""}";
      });
    });
  }

  _drawMap(Event2 ev) {
    LatLng start = _parserLatLng(ev.startAt);
    LatLng end = _parserLatLng(ev.endAt);
    List<MarkerOptions> markers = [];
    if (start != null) {
      markers.add(MarkerOptions(
        icon: 'images/start.png',
        position: start,
        title: ev.start,
        snippet: ev.startCity,
      ));
    }
    if (end != null) {
      markers.add(MarkerOptions(
        icon: 'images/end.png',
        position: end,
        title: ev.end,
        snippet: ev.endCity,
      ));
    }
    if (markers.length > 0) {
      _controller.addMarkers(markers);
    }
    if (start != null && end != null) {
      loading(
        context,
        AMapSearch().calculateDriveRoute(RoutePlanParam(from: start, to: end)),
      ).then((result) {
        result.paths[0].steps.expand((step) => step.TMCs).forEach((tmc) {
          _controller.addPolyline((PolylineOptions(
            latLngList: tmc.polyline,
            width: 15,
            lineJoinType: PolylineOptions.LINE_JOIN_MITER,
            lineCapType: PolylineOptions.LINE_CAP_TYPE_ROUND,
          )));
        });
      });
    }
  }
}
