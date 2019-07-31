import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/manager/beans2.dart';

const Color c4 = Color(0xFF13D3CE);
const Color c5 = Color(0xFFFF7200);
final TextStyle mainTitleFont = const TextStyle(
  fontSize: 18,
);

class DetailPage extends StatefulWidget {
  final String phone;
  final String from;
  final String to;
  final num money;
  final num time;

  DetailPage(this.phone, this.from, this.to, this.money, this.time);

  @override
  State<DetailPage> createState() {
    return DetailState();
  }
}

class DetailState extends State<DetailPage> {
  String adForDetailUrl =
      'https://img.zcool.cn/community/012de8571049406ac7251f05224c19.png@1280w_1l_2o_100sh.png';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dt = new DateTime.fromMillisecondsSinceEpoch(widget.time);
    var date = dateFormat.format(dt);
    var time = timeFormat.format(dt);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "拼车详情",
            style: textStyle1,
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.arrow_back,
                color: colorPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(null)),
        ),
        body: Center(
          child: ListView(padding: EdgeInsets.all(10.0), children: <Widget>[
            _getContainer(
              _getRoadLine(),
              Icons.location_on,
            ),
            _getContainer(
              Text('$date  $time', style: mainTitleFont),
              Icons.access_time,
            ),
            _getContainer(
              Text(widget.money.toString(), style: mainTitleFont),
              Icons.attach_money,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: MaterialButton(
                height: 50,
                color: Color(0xff5680fa),
                child: Text(
                  '马上联系 ' + '(' + widget.phone + ')',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () {
                  launchcaller('tel:' + widget.phone);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ]),
        ));
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
//                onTap: () {
//                  launch(listGoto);
//                },
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
              _getInfoView(Icons.trip_origin, c4, widget.from, mainTitleFont),
        ),
        _getInfoView(Icons.trip_origin, c5, widget.to, mainTitleFont),
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
