import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/date_time_picker.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/manager/account_manager.dart';
import 'package:flutter_grab/manager/beans2.dart';
import 'package:flutter_grab/manager/main_model.dart';

class EditProfilePage extends StatelessWidget {
//  UserInfo info;

  EditProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "编辑个人信息",
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
        body: MyCustomForm());
  }
}

class MyCustomForm extends StatefulWidget {
//  UserInfo info;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
//  UserInfo info;

  final _formKey = GlobalKey<FormState>();

  final nickController = TextEditingController();
  int gender = 0;

//  final mailController = TextEditingController();
  final profileController = TextEditingController();

  MainModel model;

  @override
  void dispose() {
    nickController.dispose();
//    mailController.dispose();
    profileController.dispose();
    super.dispose();
  }

  _search() {
    showLoadingDialog(context, "提交中...");
    model.update(nickController.text, gender, profileController.text).then(
        (result) {
      if (result) {
        closeLoadingDialog(context);
        Navigator.pop(context);
      } else {
        closeLoadingDialog(context);
        showSnackBar(context, "提交失败");
      }
    }, onError: (e) {
      closeLoadingDialog(context);
      showSnackBar(context, "提交失败");
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      model = model ?? MainModel.of(context);
      setState(() {
        final info = model.userInfo;
        gender = info.gender;
        nickController.text = info.nickName;
        profileController.text = info.profile;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
//          _getDropdown(),
//          SizedBox(height: 30),
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
                TextFormField(
                  decoration: getDecoration("昵称"),
                  controller: nickController,
                ),
                SizedBox(height: 20),
                _getDropdown(),
                SizedBox(height: 20),
                TextFormField(
                  decoration: getDecoration("简介"),
                  controller: profileController,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          getButtonBig("确认", onPressed: () {
            if (_formKey.currentState.validate()) {
              _search();
            }
          }),
        ],
      ),
    );
  }

  _getDropdown() {
    return DropdownButton<int>(
      value: gender,
      onChanged: (int newValue) {
        setState(() {
          gender = newValue;
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
      items: <int>[1, 2, 0].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(getxxx(value)),
        );
      }).toList(),
    );
  }

  String getxxx(int x) {
    String result = "男";
    if (x == 1) {
      result = "男";
    } else if (x == 0) {
      result = "女";
    }
    return result;
  }
}
