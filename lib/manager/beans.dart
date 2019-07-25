class Event {
  Event({this.id, this.time, this.start, this.end, this.phone, this.remark});

  num id;
  num time;
  String start = "";
  String end = "";
  String phone = "";
  String remark = "";
  num type; //0:car 1:passenger
  num publishTime;
  String publisherId;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      time: json['time'],
      start: json['start'],
      end: json['end'],
      phone: json['phone'],
      remark: json['remark'],
    );
  }
}

class BannerInfo {
  BannerInfo({this.id, this.image, this.action});

  String id = "";
  String image = "";
  String action = "";

  factory BannerInfo.fromJson(Map<String, dynamic> json) {
    return BannerInfo(
      id: json['id'].toString(),
      image: json['image'],
      action: json['action'],
    );
  }
}

class AdInfo {
  AdInfo({this.id, this.image, this.action, this.type});

  num id;

  String image = "";
  String action = "";
  num type;

  factory AdInfo.fromJson(Map<String, dynamic> json) {
    return AdInfo(
      id: json['id'],
      image: json['image'],
      action: json['action'],
      type: json['type'],
    );
  }
}

///广告数据映射
//class AdInfo {
//  AdInfo({
//    this.splashUrl,
//    this.splashGoto,
//    this.showCardUrl,
//    this.showCardGoto,
//    this.listUrl,
//    this.listGoto,
//    this.cardIndex,
//  });
//
//  String splashUrl = "";
//  String splashGoto = "";
//  String showCardUrl = "";
//  String showCardGoto = "";
//  String listUrl = "";
//  String listGoto = "";
//  int cardIndex = 1;
//
//  factory AdInfo.fromJson(Map<String, dynamic> json) {
//    return AdInfo(
//      splashUrl: json['splash_url'],
//      splashGoto: json['splash_goto'],
//      showCardUrl: json['showCard_url'],
//      showCardGoto: json['showCard_goto'],
//      cardIndex: json['card_index'],
//      listUrl: json['list_url'],
//      listGoto: json['list_goto'],
//    );
//  }
//}

///升级数据映射
class UpdateInfo {
  UpdateInfo(
      {this.code,
      this.isForce,
      this.version,
      this.buildName,
      this.message,
      this.iosUrl,
      this.androidUrl});
  num code;
  bool isForce;
  String version;
  num buildName;
  String message;
  String iosUrl;
  String androidUrl;

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      code: json["code"],
      isForce: json["data"]['is_force'],
      version: json["data"]['version'],
      buildName: json["data"]['build_name'],
      message: json["data"]['message'],
      iosUrl: json["data"]['ios_url'],
      androidUrl: json["data"]['android_url'],
    );
  }
}
