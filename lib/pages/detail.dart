import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String phone;
  final String from;
  final String to;
  final String remark;
  final num time;

  DetailPage(this.phone, this.from, this.to, this.remark, this.time);

  @override
  State<DetailPage> createState() {
    return DetailState();
  }
}

class DetailState extends State<DetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('拼车详情'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text(widget.phone),
          ),
          Container(
            child: Text(widget.from),
          ),
          Container(
            child: Text(widget.to),
          ),
          Container(
            child: Text(widget.remark),
          ),
          Container(
            child: Text(widget.time.toString()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
