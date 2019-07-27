import 'dart:convert';
import 'package:intl/intl.dart';

main() {
//  var aa = Map();
//  var bb = {"aa": "xxxx"};
//  print(jsonEncode(bb));
//  test1("start", (Map map) {
//    print("work = $map");
//  });
//  final time = 1551876960000;
//  final dt = new DateTime.fromMillisecondsSinceEpoch(time);
//  print("result1 = ${DateFormat("HH:mm  y年M月d日").format(dt)}");
//  print("result2 = ${DateFormat.yMEd().format(dt)}");
//  print("result2 = ${DateFormat.yMMMd().format(dt)}");
//  double x = 50;
//
//  for (var i = 1; i < 11; i++) {
//    x = x * 1.05;
//    print("@$i = $x");
//  }
  f1(1).then((x) => f2(x)).then((x) => f3(x));
}

Future<int> f1(int x) async {
  print("F1 $x");
  return x;
}

Future<int> f2(int x) async {
  x++;
  print("F1 $x");
  return x;
}

Future<int> f3(int x) async {
  x += 2;
  print("F1 $x");
  return x;
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
