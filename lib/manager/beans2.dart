///用户信息
class UserInfo {
  UserInfo();

  num followCount;
  num gender;
  String nickName;
  String profile;
  num fans;
  num noticeType;
  String mobile;
  String avatar;
  num id;
  String auth;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo()
      ..followCount = json["followCount"]
      ..gender = json['gender']
      ..nickName = json['nickName']
      ..profile = json['profile']
      ..fans = json['fansCount']
      ..noticeType = json['noticeType']
      ..mobile = json['mobileNo']
      ..avatar = json['aratarurl']
      ..id = json['id']
      ..auth = json['ciphertext'];
  }
}

///用户信息
class Event2 {
  Event2();

  num publishState;
  String start;
  String startCity;
  String end;
  String endCity;
  String nickName;
  String mobile;
  num userId;
  num time;
  num money;
  num publishType;
  String avatar;
  num id;
  num seat;
  String startAt;
  String endAt;
  String remark;

  factory Event2.fromSimpleJson(Map<String, dynamic> json) {
    return Event2()
      ..publishState = json["publishState"]
      ..start = json["startName"]
      ..startCity = json["startTypecode"]
      ..end = json["endName"]
      ..endCity = json["endTypecode"]
      ..nickName = json["nickName"]
      ..mobile = json["mobileNo"]
      ..userId = json["userId"]
      ..time = json["setoutTime"]
      ..money = json["money"]
      ..publishType = json["publishType"]
      ..avatar = json["aratarurl"]
      ..startAt = json["startLocation"]
      ..endAt = json["endLocation"]
      ..seat = json["seatNum"]
      ..id = json["id"]
      ..remark = json["remark"];
  }

  factory Event2.fromJson(Map<String, dynamic> json) {
    return Event2()
      ..publishState = json["publishState"]
      ..start = json["startName"]
      ..startCity = json["startTypecode"]
      ..end = json["endName"]
      ..endCity = json["endTypecode"]
      ..nickName = json["nickName"]
      ..mobile = json["mobileNo"]
      ..userId = json["userId"]
      ..time = json["setoutTime"]
      ..money = json["money"]
      ..publishType = json["publishType"]
      ..avatar = json["aratarurl"]
      ..startAt = json["startLocation"]
      ..endAt = json["endLocation"]
      ..seat = json["seatNum"]
      ..id = json["id"]
      ..remark = json["remark"];
  }
}
