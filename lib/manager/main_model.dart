import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/manager/api.dart';
import 'package:flutter_grab/manager/beans.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:amap_base/src/search/model/poi_item.dart';

import 'account_manager.dart';
import 'beans2.dart';

typedef DaiListener = int Function(bool hasMore);

class MainModel extends Model {
  /// Wraps [ScopedModel.of] for this [Model].
  static MainModel of(BuildContext context) =>
      ScopedModel.of<MainModel>(context, rebuildOnChange: true);

  //Search begin.
  ///人找车的筛选条件
  SearchCondition _findVehicle;

  ///车找人的筛选条件
  SearchCondition _findPassenger;

  ///获取筛选条件
  SearchCondition getSearchCondition(PageType type) {
    return (type == PageType.FindVehicle) ? _findVehicle : _findPassenger;
  }

  final PAGE_SIZE = 10;

  PageDataStatus _passengerStatus = PageDataStatus.LOADING;

  PageDataStatus _vehicleStatus = PageDataStatus.LOADING;

  getPageStatus(PageType type) =>
      (type == PageType.FindVehicle) ? _vehicleStatus : _passengerStatus;

  bool _passengerHasMore = true;

  bool _vehicleHasMore = true;

  int _vehiclePage = 0;

  int _passengerPage = 0;

  getHasMore(PageType type) =>
      (type == PageType.FindVehicle) ? _vehicleHasMore : _passengerHasMore;

  ///更新筛选条件
  updateSearchCondition(PageType type, SearchCondition newCondition) {
    if (type == PageType.FindVehicle) {
      //如果条件改变，根据新的条件，刷新数据
      if (_findVehicle != newCondition) {
        _findVehicle = newCondition;
        queryVehicleList(true, done: () {});
      }
    } else {
      //如果条件改变，根据新的条件，刷新数据
      if (_findPassenger != newCondition) {
        _findPassenger = newCondition;
        queryPassengerList(true, done: () {});
      }
    }
    notifyListeners();
  }

  //List Data
  ///人找车的数据
  List<Event2> _vehicleList = new List();

  ///车找人的数据
  List<Event2> _passengerList = new List();

  ///banner的数据
  List<BannerInfo> _bannerList = new List();

  List<Event2> getListData(PageType type) =>
      (type == PageType.FindVehicle) ? _vehicleList : _passengerList;

  getBannerInfoList() => _bannerList;

  queryList(PageType type, bool refresh, {Function done}) {
    if (type == PageType.FindVehicle) {
      queryVehicleList(refresh, done: done);
    } else {
      queryPassengerList(refresh, done: done);
    }
  }

  /// 请求 Passenger List, num after 表示从哪个timestamp 开始load more.
  queryPassengerList(bool refresh, {Function done}) async {
    int findType = 2;
    if (!refresh && !_passengerHasMore) {
      print("ERROR. NO MORE, NO REQUEST");
      return;
    }
    if (refresh) {
      _passengerPage = 0;
    }
    Response response;
    int pageNo = refresh ? 1 : _passengerPage + 1;
    if (_findPassenger == null) {
      response = await API2.queryEvents(
        findType,
        pageNo: pageNo,
        pageSize: PAGE_SIZE,
      );
    } else {
      response = await API2.searchEvents(
        findType,
        pickup: _findPassenger.pickup.adCode,
        dropOff: _findPassenger.dropoff.adCode,
        time: _findPassenger.time,
        pageNo: pageNo,
        pageSize: PAGE_SIZE,
      );
    }
    final parsed = json.decode(response.data);
    final resultCode = parsed["code"] ?? 0;
    final resultData = parsed["data"];
    if (resultCode == 200 && resultData != null) {
      _passengerPage++;
      final dataList = resultData["list"];
      num total = resultData["totalCount"] ?? 0;
      if (dataList != null) {
        final newData =
            dataList.map<Event2>((json) => Event2.fromJson(json)).toList();
        if (refresh) {
          //refresh
          _passengerList.clear();
        }
        _passengerList.addAll(newData);
      }
      _passengerHasMore = _passengerList.length < total;
    }
    _passengerStatus = _passengerList.length > 0
        ? PageDataStatus.READY
        : PageDataStatus.ERROR_EMPTY;
    done();
    notifyListeners();
  }

  queryVehicleList(bool refresh, {Function done}) async {
    int findType = 1;
    if (!refresh && !_vehicleHasMore) {
      print("ERROR. NO MORE, NO REQUEST");
      return;
    }
    if (refresh) {
      _vehiclePage = 0;
    }
    Response response;
    int pageNo = refresh ? 1 : _vehiclePage + 1;
    if (_findVehicle == null) {
      response = await API2.queryEvents(
        findType,
        pageNo: pageNo,
        pageSize: PAGE_SIZE,
      );
    } else {
      response = await API2.searchEvents(
        findType,
        pickup: _findPassenger.pickup.adCode,
        dropOff: _findPassenger.dropoff.adCode,
        time: _findPassenger.time,
        pageNo: pageNo,
        pageSize: PAGE_SIZE,
      );
    }
    final parsed = json.decode(response.data);
    final resultCode = parsed["code"] ?? 0;
    final resultData = parsed["data"];
    if (resultCode == 200 && resultData != null) {
      _vehiclePage++;
      final dataList = resultData["list"];
      num total = resultData["totalCount"] ?? 0;
      if (dataList != null) {
        final newData =
            dataList.map<Event2>((json) => Event2.fromJson(json)).toList();
        if (refresh) {
          //refresh
          _vehicleList.clear();
        }
        _vehicleList.addAll(newData);
      }
      _vehicleHasMore = _vehicleList.length < total;
    }
    _vehicleStatus = _vehicleList.length > 0
        ? PageDataStatus.READY
        : PageDataStatus.ERROR_EMPTY;
    done();
    notifyListeners();
  }

  //Search end.
  queryBanner(PageType pageType) async {
    Response response = await API.queryBanners(0);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    var resultData = parsed['data'];
    if (resultCode == 200 && resultData != null) {
      final newData = resultData
          .map<BannerInfo>((json) => BannerInfo.fromJson(json))
          .toList();
      _bannerList.clear();
      _bannerList.addAll(newData);
      notifyListeners();
    }
  }

  Future<int> publish(Map<String, String> body) {
    return API2.publish(body).then((response) {
      final parsed = json.decode(response.data);
      var resultCode = parsed['code'] ?? 0;
      var resultData = parsed['data'];
      print("DDAI= code=${response.statusCode} ;end=${response.data}");
      return resultCode;
    }, onError: (error) {
      print("DDAI= onError");
      return -1;
    });
  }

  UserInfo _userInfo;

  updateUserInfo() {
    if (_userInfo != null) {
      getUserInfo(_userInfo.id).then((e) {
        print("_updateUserInfo 2 $e");
        if (e)
          AccountManager.getAccount().then((i) {
            print("_updateUserInfo 3");
            if (i != null) {
              _userInfo = i;
              notifyListeners();
            }
          });
      });
    }
  }

  init() {
    AccountManager.getAccount().then((info) {
      print("_updateUserInfo 1 $info");
      _userInfo = info;
      updateUserInfo();
    });
  }

  ///  WUYOU 相关
  ///接受到的最新的短信验证码。
  String _code = "";

  String get code => _code;

  UserInfo get userInfo => _userInfo;

  Future<bool> sendCode(String phone) async {
    Response response = await API2.sendCode(phone);
    final parsed = json.decode(response.data);
    var resultData = parsed['data'];
    var resultCode = parsed['code'] ?? 0;
    if (resultCode == 200 && resultData != null) {
      _code = "${resultData['randomNum']}";
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<int> login(String phone, String code) async {
    if (code != _code) return -1;
    Response response = await API2.login(phone, code);
    final parsed = json.decode(response.data);
    var resultData = parsed['data'];
    var resultCode = parsed['code'] ?? 0;
    if (resultCode == 200 && resultData != null) {
      return resultData['userId'] ?? -1;
    }
    return -1;
  }

  Future<bool> getUserInfo(int uid) async {
    if (uid == null || uid < 0) return null;
    Response response = await API2.getUserInfo(uid);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    var resultData = parsed['data'];
    if (resultCode == 200 && resultData != null) {
      print("getUserInfo 1");
      _userInfo = UserInfo.fromJson(resultData);
      return AccountManager.saveAccount(json.encode(resultData));
    }
    print("getUserInfo 2");
    return false;
  }

  Future<bool> update(String nick, int gender, String profile) async {
    Response response =
        await API2.updateUserInfo(_userInfo.id, nick, gender, profile);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    bool result = (resultCode == 200);
    if (result) {
      _userInfo.nickName = nick;
      _userInfo.gender = gender;
      _userInfo.profile = profile;
    }
    return result;
  }

  static Future<Event2> getEventDetail(num eventID) async {
    Response response = await API2.eventDetail(eventID);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    var resultData = parsed['data'] ?? 0;
    bool result = (resultCode == 200 && resultData != null);
    if (result) {
      return Event2.fromJson(resultData);
    }
    return null;
  }

  static Future<List<Event2>> history(num uid) async {
    Response response = await API2.history(uid);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    final resultData = parsed["data"];
    if (resultCode == 200 && resultData != null) {
      final dataList = resultData["list"];
      if (dataList != null) {
        return dataList.map<Event2>((json) => Event2.fromJson(json)).toList();
      }
    }
    return null;
  }
}

///搜索条件
class SearchCondition extends Equatable {
  SearchCondition({this.time, this.pickup, this.dropoff})
      : super([time, pickup, dropoff]);

  ///时间
  num time;

  ///起点
  PoiItem pickup;

  ///终点
  PoiItem dropoff;
}

int intFromPageType(PageType type) => (type == PageType.FindVehicle) ? 1 : 2;
