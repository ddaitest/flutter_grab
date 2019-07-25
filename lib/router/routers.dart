import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/pages/home.dart';
import 'package:flutter_grab/pages/search.dart';

class Routers {
  static Router router;

  static String pageHome = "/";
  static String pageSearch = "/search";
  static String pagePublish = "/publish";

  static void config(Router router) {
    router.define(pageHome,
        handler: Handler(handlerFunc: (context, params) => HomePage()));
    router.define(pageSearch,
        handler: Handler(handlerFunc: (context, params) => SearchPage()));
//    router.define(pagePublish,
//        handler: Handler(handlerFunc: (context, params) => PublishPage()));
    Routers.router = router;
  }

  static void showSearch(BuildContext context, Function(Map) callback,
      {String start, String end, num timeStart, num timeEnd}) {
//    var query = Map();
//    query["start"] = start ?? "";
//    query["end"] = end ?? "";
//    query["time_start"] = timeStart ?? -1;
//    query["time_end"] = timeEnd ?? -1;
//    var json = jsonEncode(query);
    router
        .navigateTo(
          context,
          "${Routers.pageSearch}?start=$start&end=$end&timeStart=$timeStart&timeEnd=$timeEnd",
          transition: TransitionType.inFromRight,
        )
        .then(callback);
  }
}

//typedef void afterSearchFn();
