import 'dart:convert';
import 'package:intl/intl.dart';

main() {
//  var aa = Map();
//  var bb = {"aa": "xxxx"};
//  print(jsonEncode(bb));
//  test1("start", (Map map) {
//    print("work = $map");
//  });
  final time = 1551876960000;
  final dt = new DateTime.fromMillisecondsSinceEpoch(time);
  print("result1 = ${DateFormat("HH:mm  y年M月d日").format(dt)}");
  print("result2 = ${DateFormat.yMEd().format(dt)}");
  print("result2 = ${DateFormat.yMMMd().format(dt)}");
  double x = 50;

  for (var i = 1; i < 11; i++) {
    x = x * 1.05;
    print("@$i = $x");
  }
}

//void test1(String start, Function(Map) callback) {
//  print("test1");
//  callback({"xxx": start});
//  print("test2");
//}
//
//void work(Map map) {
//  print("work = $map");
//}
