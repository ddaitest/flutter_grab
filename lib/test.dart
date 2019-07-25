import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

import 'common/theme.dart';

const Test = false;

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestState();
}

//测试 autocomplete text view.
class _TestState extends State<TestPage> {
  AutoCompleteTextField textField;
  TextEditingController currentText1 = TextEditingController();
  TextEditingController currentText2 = TextEditingController();
  TextEditingController currentText3 = TextEditingController();
  TextEditingController currentText4 = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  String dropdownValue = "人找车";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          _getBody(),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: MaterialButton(
              elevation: 4,
              onPressed: () {
                print("currentText1=${currentText1.text}");
                print("currentText2=${currentText2.text}");
                print("currentText3=${currentText3.text}");
                print("currentText4=${currentText4.text}");
              },
              color: colorPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Text(
                '发布',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  _getBody() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
//          border: Border.all(color: colorPrimary, width: 1),
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
          SimpleAutoCompleteTextField(
            decoration: _getDecoration("出发"),
            controller: currentText1,
            style: textStylePublish,
          ),
          SizedBox(height: 20),
          SimpleAutoCompleteTextField(
            decoration: _getDecoration("到达"),
            controller: currentText2,
            style: textStylePublish,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: _getDecoration("手机"),
            controller: currentText3,
            style: textStylePublish,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: _getDecoration("备注"),
            controller: currentText4,
            style: textStylePublish,
          ),
        ],
      ),
    );
  }

  InputDecoration _getDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: textStyleLabel,
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: colorGrey)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
    );
  }

  List<String> data = [
    "a",
    "aa",
    "aaa",
    "aaaa",
    "aaaa",
    "b",
    "bb",
    "bbb",
    "bbbb",
    "bbbb",
    "c",
    "cc",
    "ccc",
    "cccc",
    "cccc",
    "d",
    "dd",
    "ddd",
    "dddd",
    "dddd",
    "e",
    "ee",
    "eee",
    "eeee",
    "eeee",
    "f",
    "ff",
    "fff",
    "ffff",
    "ffff",
    "g",
    "gg",
    "ggg",
    "gggg",
    "gggg"
  ];
}

//SimpleAutoCompleteTextField(
//decoration: new InputDecoration(
//labelText: 'Drop off',
//labelStyle: textStyleLabel,
//focusedBorder: UnderlineInputBorder(
//borderSide: BorderSide(color: colorGrey)),
//enabledBorder: UnderlineInputBorder(
//borderSide: BorderSide(color: Colors.grey[200])),
//),
//controller: TextEditingController(text: ""),
//suggestions: [],
//textChanged: (text) => currentText2 = text,
//clearOnSubmit: true,
//textSubmitted: (text) => setState(() {
//if (text != "") {
//print("added.add($text);");
//}
//}),
//style: textStylePublish,
//),

//测试 silver scroll view.
