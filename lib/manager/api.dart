import 'dart:async';

import 'package:dio/dio.dart';

class API {
  static Dio dio = Dio(BaseOptions(
      baseUrl: "http://39.96.16.125:8082/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      responseType: ResponseType.plain));

  static InterceptorsWrapper _interceptorsWrapper = InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      print(">> ${options.hashCode} ${options.uri.toString()}");
      return options;
    },
    onResponse: (Response response) {
      print("<< ${response.data}");
      return response; // continue
    },
    onError: (DioError e) {
      print("xx ${e.message}");
      return e; //continue
    },
  );

  static init() {
    if (!dio.interceptors.contains(_interceptorsWrapper)) {
      dio.interceptors.add(_interceptorsWrapper);
    }
  }

  static queryEvents(num pageType, {num afterId, num pageSize}) {
    var params = Map<String, dynamic>();
    params['page_type'] = pageType;

    if (afterId != null && afterId > 1) {
      params['after_id'] = afterId;
    }
    if (pageSize != null) {
      params['page_size'] = pageSize;
    }
    return dio.get("api/event/news", queryParameters: params);
  }

  static searchEvents(num pageType,
      {num afterId,
      num afterTime,
      String pickup,
      String dropOff,
      num time,
      num pageSize}) {
    var params = Map<String, dynamic>();
    params['page_type'] = pageType;

    if (afterId != null && afterId > 1) {
      params['after_id'] = afterId;
    }

    if (afterTime != null && afterTime > 1) {
      params['after_time'] = afterTime;
    }
    if (pickup != null) {
      params['s_pickup'] = pickup;
    }
    if (dropOff != null) {
      params['s_drop_off'] = dropOff;
    }
    if (time != null && time > 1) {
      params['s_time'] = time;
    }
    if (pageSize != null) {
      params['page_size'] = pageSize;
    }
    return dio.get("api/event/search", queryParameters: params);
  }

  static queryBanners(num pageType) {
    return dio.get("api/banner/", queryParameters: {
      "page_type": pageType,
    });
  }

  ///广告相关
  static queryAD() {
    return dio.get("api/ad/");
  }

  ///升级信息
  static queryUpgrade(String version, String buildNumber) {
    return dio
        .get("api/config/", queryParameters: {"v": version, "n": buildNumber});
  }

  ///发布
  static Future<Response> publish(Map<String, String> body) {
    return dio.post("api/event/publish", queryParameters: body);
  }
}

class API2 {
  static Dio dio = Dio(BaseOptions(
      baseUrl: "https://www.51sfc.top/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      responseType: ResponseType.plain));

  static InterceptorsWrapper _interceptorsWrapper = InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      print(">> ${options.hashCode} ${options.uri.toString()}");
      return options;
    },
    onResponse: (Response response) {
      print("<< ${response.data}");
      return response; // continue
    },
    onError: (DioError e) {
      print("xx ${e.message}");
      return e; //continue
    },
  );

  static init() {
    if (!dio.interceptors.contains(_interceptorsWrapper)) {
      dio.interceptors.add(_interceptorsWrapper);
    }
  }

  static sendCode(String phone) {
    var params = Map<String, dynamic>();
    params['mobileno'] = phone;
    params['platformId'] = 999999;
    return dio.post("user/sms/send", queryParameters: params);
  }

  static login(String phone,String code) {
    var params = Map<String, dynamic>();
    params['mobileno'] = phone;
    params['vcode'] = code;
    params['platformId'] = 999999;
    return dio.post("user/logined", queryParameters: params);
  }

  static getUserInfo(int uid) {
    var params = Map<String, dynamic>();
    params['userId'] = uid;
    return dio.post("user/back/getMsgByUserId", queryParameters: params);
  }


}
