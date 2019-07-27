import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      backgroundColor: Colors.white,
//      unselectedWidgetColor: Colors.grey,
      textTheme: TextTheme(subhead: textStyleLabel));
}

const Color colorPrimaryDark = const Color(0xff203152);
const Color colorPrimary = const Color(0xff5680fa);
const Color colorGrey = const Color(0xff7C8698);
const Color colorGrey2 = const Color(0xffD6D6D6);
const Color colorPick = Color(0xFF13D3CE);
const Color colorDrop = Color(0xFFFF7200);

const TextStyle textStyle1 = const TextStyle(
  fontSize: 30.0,
  color: colorPrimaryDark,
);

const TextStyle textStyle2 = const TextStyle(
  fontSize: 14.0,
  color: const Color(0xff7C8698),
);

const TextStyle textStyle3 = const TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: colorPrimary,
);

const TextStyle textStyleLabel = const TextStyle(
  fontSize: 14.0,
  color: colorGrey,
);

const TextStyle textStylePublish = const TextStyle(
  fontSize: 20.0,
  color: colorPrimaryDark,
);

const TextStyle textButtonSmall = const TextStyle(
  fontSize: 14.0,
  color: Colors.white,
);

///发布 和 搜索中 输入框的样式，主要是下划线和label
InputDecoration getDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: textStyleLabel,
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: colorGrey)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
    counterText: '',
  );
}

///发布 和 搜索中 Container 背景的样式
BoxDecoration getContainerBg(double radius) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey[200],
          blurRadius: 10.0,
          spreadRadius: 5.0,
        )
      ]);
}
