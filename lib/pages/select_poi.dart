import 'dart:async';

import 'package:amap_base/amap_base.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/city_data.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/date_time_picker.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/manager/main_model.dart';
import 'package:amap_base/src/search/model/poi_item.dart';

class SelectPOIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "选择 POI",
            style: textStyle1,
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorPrimaryDark,
              ),
              onPressed: () => Navigator.of(context).pop(null)),
        ),
        body: MyCustomForm()
//        MyCustomForm(),
        );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

const List<String> suggestions = [
  "Apple",
  "Armidillo",
  "Actual",
  "Actuary",
  "America",
  "Argentina",
  "Australia",
  "Antarctica",
  "Blueberry",
  "Cheese",
  "Danish",
  "Eclair",
  "Fudge",
  "Granola",
  "Hazelnut",
  "Ice Cream",
  "Jely",
  "Kiwi Fruit",
  "Lamb",
  "Macadamia",
  "Nachos",
  "Oatmeal",
  "Palm Oil",
  "Quail",
  "Rabbit",
  "Salad",
  "T-Bone Steak",
  "Urid Dal",
  "Vanilla",
  "Waffles",
  "Yam",
  "Zest"
];

class MyCustomFormState extends State<MyCustomForm> {
  ///false if vehicle.

  final myControllerStart = TextEditingController();

  List _pois = List<PoiItem>();

  @override
  void initState() {
    myControllerStart.addListener(() {
      print("myControllerStart changed = ${myControllerStart.text}");
      _searchPOI(myControllerStart.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    myControllerStart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
//        _getDropdown(),
        TextFormField(
          decoration: getDecoration("搜索："),
          controller: myControllerStart,
        ),
        Expanded(child: _getlist()),
      ],
    );
  }

  _showSelectCity() async {
    Result result2 = await CityPickers.showCityPicker(
        context: context,
        showType: ShowType.pc,
        citiesData: cities,
        provincesData: provinces,
        confirmWidget: Text("确认", style: textStyle3),
        cancelWidget: Text("取消", style: textStyle3));

    print("_showSelectCity $result2");
    setState(() {
      dropdownValue = result2.cityName;
    });
  }

  _getlist() {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: _pois.length,
      itemBuilder: (BuildContext context, int index) {
        PoiItem item = _pois[index];
        return Container(
          height: 50,
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop<PoiItem>(context, item),
              child: Text('${item.cityName}-${item.adName}-${item.title}'),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  String dropdownValue = "北京市";

  _getDropdown() {
    return GestureDetector(
        onTap: () {
          _showSelectCity();
        },
        child: Stack(
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
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text(dropdownValue, style: textStyle3)),
                    Icon(
                      Icons.arrow_drop_down,
                      color: colorPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  _searchPOI(String keyword) async {
    AMapSearch()
        .searchPoi(PoiSearchQuery(
      query: keyword,
//      requireSubPois: true,
      city: dropdownValue,
//      requireSubPois: true,
//      cityLimit: true,
      requireExtension: true,
    ))
        .then((result) {
          result.pois.forEach((v){
            print("xxx = ${v.adCode}");
          });
//      if (result.pois != null && result.pois.length > 0) {
//        print("Result0 = ${result.pois[0].toString()}");
//      }
      setState(() {
        _pois.clear();
        _pois.addAll(result.pois);
      });
    });
  }
}
