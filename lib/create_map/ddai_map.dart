import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';

class DDAIScreen extends StatefulWidget {
  LatLng start = LatLng(39.985953, 116.464719);
  LatLng end = LatLng(39.983541, 116.46737);

  @override
  _ShowMapScreenState createState() => _ShowMapScreenState()
    ..start = start
    ..end = end;
}

class _ShowMapScreenState extends State<DDAIScreen> {
  LatLng start;
  LatLng end;
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('显示地图')),
      body: Column(
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
            child: ListView(
              children: <Widget>[
                MaterialButton(
                    child: Text(
                      "TEST ",
                      style: textStyle2,
                    ),
                    onPressed: () => _addPoints()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _addPoints() {
    _controller.addMarkers([
      MarkerOptions(
        icon: 'images/start.png',
        position: start,
        title: 'start',
        snippet: 'start',
      ),
      MarkerOptions(
        icon: 'images/end.png',
        position: end,
        title: 'end',
        snippet: 'end',
      )
    ]);
    _controller.addPolyline(
      PolylineOptions(
          latLngList: [start, end],
          color: colorDrop,
          isDottedLine: false,
          isGeodesic: false,
          width: 10,
          lineCapType: PolylineOptions.LINE_CAP_TYPE_ARROW),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
