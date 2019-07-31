import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/date_time_picker.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/common/widget/page_title.dart';
import 'package:flutter_grab/manager/main_model.dart';
import 'package:amap_base/src/search/model/poi_item.dart';

import 'select_poi.dart';

class SearchPage extends StatelessWidget {
  ///表示从哪个页面进来的。 true = 人找车；false = 车找人；
  final PageType pageType;

  SearchPage({Key key, @required this.pageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getCommonScaffold(
      "搜索 " + ((pageType == PageType.FindVehicle) ? "人找车" : "车找人"),
      body: MyCustomForm()..pageType = pageType,
      onLeadingPressed: () => Navigator.of(context).pop(null),
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

class MyCustomFormState extends State<MyCustomForm> {
  PageType pageType;

  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final myControllerStart = TextEditingController();
  final myControllerEnd = TextEditingController();

  MainModel model;

  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());

  PoiItem startSelected;
  PoiItem endSelected;

  @override
  void dispose() {
    myControllerStart.dispose();
    myControllerEnd.dispose();
    super.dispose();
  }

  _search() {
    final x = DateTime(
      _fromDate.year,
      _fromDate.month,
      _fromDate.day,
      _fromTime.hour,
      _fromTime.minute,
    );

    model.updateSearchCondition(
        pageType,
        new SearchCondition(
            pickup: startSelected.adCode,
            dropoff: endSelected.adCode,
            time: x.millisecondsSinceEpoch));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      print("ERROR. initState work");
      model = model ?? MainModel.of(context);
      var condition = model.getSearchCondition(pageType);
      if (condition != null) {
        if (condition.pickup != null) {
          myControllerStart.text = condition.pickup;
        }
        if (condition.dropoff != null) {
          myControllerEnd.text = condition.dropoff;
        }
        if (condition.time != null) {
          setState(() {
            _fromDate = DateTime.fromMillisecondsSinceEpoch(condition.time);
            _fromTime = TimeOfDay.fromDateTime(_fromDate);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    model = model ?? MainModel.of(context);
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          _getDropdown(),
          SizedBox(height: 30),
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
                    print("startSelected = ${v.adCode}");
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
                    print("endSelected = ${v}");
                    setState(() {
                      myControllerEnd.text =
                          '${v.cityName}-${v.adName}-${v.title}';
                    });
                  }),
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
                _search();
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
