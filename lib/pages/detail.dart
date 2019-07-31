import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/widget/page_title.dart';
import 'package:flutter_grab/manager/beans2.dart';

//const Color c4 = Color(0xFF13D3CE);
//const Color c5 = Color(0xFFFF7200);
//final TextStyle mainTitleFont = const TextStyle(
//  fontSize: 18,
//);

class DetailPage extends StatefulWidget {
  final Event2 event;

  DetailPage(this.event);

  @override
  State<DetailPage> createState() {
    return DetailState()..event = event;
  }
}

class DetailState extends State<DetailPage> {
  Event2 event;
  String adForDetailUrl =
      'https://img.zcool.cn/community/012de8571049406ac7251f05224c19.png@1280w_1l_2o_100sh.png';
  LatLng start = LatLng(39.985953, 116.464719);
  LatLng end = LatLng(39.983541, 116.46737);
  AMapController _controller;

  @override
  void initState() {
    super.initState();
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
        Flexible(
          child: AMapView(
            onAMapViewCreated: (controller) {
              _controller = controller;
              _controller.markerClickedEvent.listen((marker) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(marker.toString())));
              });
            },
            amapOptions: AMapOptions(
              compassEnabled: false,
              zoomControlsEnabled: true,
              logoPosition: LOGO_POSITION_BOTTOM_CENTER,
              camera: CameraPosition(
                target: start,
                zoom: 15,
              ),
            ),
          ),
        ),
        Flexible(
          child: _getInfo(),
        ),
      ],
    );
  }

  _getInfo() {
    final dt = new DateTime.fromMillisecondsSinceEpoch(event.time);
    var date = dateFormat.format(dt);
    var time = timeFormat.format(dt);
    return ListView(padding: EdgeInsets.all(10.0), children: <Widget>[
      _getContainer(
        _getRoadLine(),
        Icons.location_on,
      ),
      _getContainer(
        Text('$date  $time', style: fontInfo),
        Icons.access_time,
      ),
      _getContainer(
        Text(event.money.toString(), style: fontInfo),
        Icons.attach_money,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: MaterialButton(
          height: 50,
          color: Color(0xff5680fa),
          child: Text(
            '马上联系 ' + '(' + event.mobile + ')',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            launchcaller('tel:' + event.mobile);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    ]);
  }

  ///判断是否有广告数据才展示
  _adJudge() {
    if (adForDetailUrl != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 25),
        child: GestureDetector(
          child: Image(
            image: CachedNetworkImageProvider(adForDetailUrl),
            fit: BoxFit.fill,
            width: 500,
            height: 400,
          ),
        ),
      );
    }
  }

  ///list中的通用样式
  Widget _getContainer(var title, IconData leadIcon, {IconData trailIcon}) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Card(
          child: ListTile(
            dense: true,
            leading: Icon(leadIcon),
            trailing: Icon(trailIcon),
            title: title,
          ),
        ));
  }

  ///位置样式
  _getRoadLine() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child:
              _getInfoView(Icons.trip_origin, colorPick, event.start, fontInfo),
        ),
        _getInfoView(Icons.trip_origin, colorDrop, event.end, fontInfo),
      ],
    );
  }

  ///公用ICON + TEXT
  _getInfoView(IconData icon, Color color, String info, TextStyle style) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: color,
          size: 14.0,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            info,
            style: style,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
