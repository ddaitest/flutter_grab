import 'dart:async';

import 'package:amap_base/src/search/model/poi_item.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/date_time_picker.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/common/widget/page_title.dart';
import 'package:flutter_grab/manager/beans2.dart';
import 'package:flutter_grab/manager/main_model.dart';
import 'package:intl/intl.dart';

import 'select_poi.dart';

class PublishPage extends StatelessWidget {
  final PageType pageType;

  PublishPage(this.pageType, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getCommonScaffold(
      "发布",
      onLeadingPressed: () => Navigator.of(context).pop(null),
      body: MyCustomForm()..pageType = pageType,
    );
  }
}

class MyCustomForm extends StatefulWidget {
  PageType pageType;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState()..pageType = pageType;
  }
}

final dataFormat = DateFormat("y-M-D H:m ");

class MyCustomFormState extends State<MyCustomForm> {
  ///false if vehicle.
  final _formKey = GlobalKey<FormState>();
  MainModel model;

  PageType pageType;

  final myControllerStart = TextEditingController();
  final myControllerEnd = TextEditingController();
  final myControllerSeat = TextEditingController();
  final myControllerMoney = TextEditingController();
  final myControllerRemark = TextEditingController();

  List _startPois = List<PoiItem>();
  List _endPois = List<PoiItem>();

  PoiItem startSelected;
  PoiItem endSelected;

  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());
  GlobalKey keyStartSelected = GlobalKey<AutoCompleteTextFieldState<PoiItem>>();
  GlobalKey keyEndSelected = GlobalKey<AutoCompleteTextFieldState<PoiItem>>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      model = MainModel.of(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    myControllerStart.dispose();
    myControllerEnd.dispose();
    myControllerSeat.dispose();
    myControllerMoney.dispose();
    myControllerRemark.dispose();
    super.dispose();
  }

  Future _doPublish() async {
    final x = DateTime(
      _fromDate.year,
      _fromDate.month,
      _fromDate.day,
      _fromTime.hour,
      _fromTime.minute,
    );
    UserInfo userInfo = model.userInfo;
    if (userInfo == null) {
      return null;
    }
    final body = <String, String>{
      'ciphertext': userInfo.auth,
      'mobileNo': userInfo.mobile,
      'userId': userInfo.id.toString(),
      'startTypecode': startSelected.typeCode,
      'startAddress':
          '${startSelected.cityName}${startSelected.adName}${startSelected.title}',
      'startLocation': startSelected.latLonPoint.toString(),
      'startName': startSelected.title,
      'startAdcode': startSelected.adCode,
      'startDistrict': startSelected.direction,
      'endTypecode': endSelected.typeCode,
      'endAddress':
          '${endSelected.cityName}${endSelected.adName}${endSelected.title}',
      'endLocation': endSelected.latLonPoint.toString(),
      'endName': endSelected.title,
      'endAdcode': endSelected.adCode,
      'endDistrict': endSelected.direction,
      'setoutTime': dataFormat.format(x),
      'seatNum': myControllerSeat.text,
      'money': myControllerMoney.text,
      'remark': myControllerRemark.text,
      'publishType': pageType == PageType.FindVehicle ? '1' : '2',
      'publishState': type1.toString(),
      'openId': 'undefined',
      'formId': 'the formId is a mock one',
    };

    model.publish(body).then((result) {
      print("result=$result");
      closeLoadingDialog(context);
      Navigator.pop(context);
    });

    return showLoadingDialog(context, "发布中");
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            _getDropdown(),
            SizedBox(height: 20),
            _getType1(),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    )
                  ]),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: getDecoration("出发："),
                    controller: myControllerStart,
                    onTap: () => Navigator.push<PoiItem>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectPOIPage())).then((v) {
                      startSelected = v;
                      print("startSelected = $v");
                      setState(() {
                        myControllerStart.text =
                            '${v.cityName}-${v.adName}-${v.title}';
                      });
                    }),
                  ),
                  TextField(
                    decoration: getDecoration("到达："),
                    controller: myControllerEnd,
                    onTap: () => Navigator.push<PoiItem>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectPOIPage())).then((v) {
                      endSelected = v;
                      print("endSelected = $v");
                      setState(() {
                        myControllerEnd.text =
                            '${v.cityName}-${v.adName}-${v.title}';
                      });
                    }),
                  ),
                  TextFormField(
                    decoration: getDecoration("座位："),
                    keyboardType: TextInputType.number,
                    controller: myControllerSeat,
                    validator: (x) {
                      return x.isEmpty ? "请输入" : null;
                    },
                  ),
                  TextFormField(
                    decoration: getDecoration("价格："),
                    keyboardType: TextInputType.number,
                    controller: myControllerMoney,
                    validator: (x) {
                      return x.isEmpty ? "请输入" : null;
                    },
                  ),
                  TextFormField(
                    decoration: getDecoration("备注："),
                    controller: myControllerRemark,
                  ),
                  SizedBox(height: 20),
                  DateTimePicker(
                    labelText: '出发时间',
                    selectedDate: _fromDate,
                    selectedTime: _fromTime,
                    selectDate: (DateTime date) {
                      setState(() {
                        _fromDate = date;
                      });
                    },
                    selectTime: (TimeOfDay time) {
                      setState(() {
                        _fromTime = time;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            MaterialButton(
              height: 55,
              elevation: 4,
              color: colorPrimary,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (myControllerStart.text.isEmpty) {
                    showSnackBar(context, "请选择出发点");
                    return;
                  }
                  if (myControllerEnd.text.isEmpty) {
                    showSnackBar(context, "请选择到打点");
                    return;
                  }
                  _doPublish();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Text(
                '发布',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }

  int type1 = 1;

  _getType1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 1,
          groupValue: type1,
          onChanged: (v) {
            setState(() {
              type1 = v;
              print("xxx = $type1  v=$v");
            });
          },
        ),
        Text("普通拼车"),
        Radio(
          value: 2,
          groupValue: type1,
          onChanged: (v) {
            setState(() {
              type1 = v;
              print("yyy = $type1  v=$v");
            });
          },
        ),
        Text("长期拼车")
      ],
    );
  }

  _getDropdown() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(color: colorPrimary, width: 1),
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 10.0,
//                  spreadRadius: 5.0,
                )
              ]),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 40,
            margin: EdgeInsets.only(left: 60, right: 50, top: 2),
            child: DropdownButton<PageType>(
              value: pageType,
              onChanged: (PageType newValue) {
                setState(() {
                  pageType = newValue;
                });
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color: colorPrimary,
              ),
              elevation: 8,
              style: textStyle3,
              underline: Container(),
              isExpanded: true,
              items: <PageType>[PageType.FindPassenger, PageType.FindVehicle]
                  .map<DropdownMenuItem<PageType>>((PageType value) {
                return DropdownMenuItem<PageType>(
                  value: value,
                  child: Text(getTitle(value)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
