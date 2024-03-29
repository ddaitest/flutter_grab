import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/common/widget/page_title.dart';
import 'package:flutter_grab/create_map/ddai_map.dart';
import 'package:flutter_grab/manager/account_manager.dart';
import 'package:flutter_grab/pages/history.dart';
import 'package:flutter_grab/pages/publish.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_grab/manager/account_manager.dart';
import '../manager/main_model.dart';
import '../test.dart';
import 'about.dart';
import 'edit_profile.dart';
import 'first.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
//  HomeState createState() => HomeState();
  MyHomeState createState() => MyHomeState();
}

// SingleTickerProviderStateMixin is used for animation
class MyHomeState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Create a tab controller
  TabController controller;
  int page = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isForce;

  String version;
  num buildName;
  String message;
  String iosUrl;
  String androidUrl;
  String showCardUrl;
  String showCardGoto;
  String localVersionName;
  String localVersionCode;
  bool canClose;

  MainModel model;

  initValue() async {
    var dialogDataMap = await getDialogData();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      isForce = dialogDataMap["isForce"];
      version = dialogDataMap["version"];
      buildName = dialogDataMap["buildName"];
      message = dialogDataMap["message"];
      iosUrl = dialogDataMap["iosUrl"];
      androidUrl = dialogDataMap["androidUrl"];
      showCardUrl = dialogDataMap["showCardUrl"];
      showCardGoto = dialogDataMap["showCardGoto"];
    });

    ///弹窗延迟3s弹出
//    Timer(const Duration(seconds: 1), () {
//      if (compareVersion(version, packageInfo.version) > 0 &&
//          compareVersion(buildName.toString(), packageInfo.buildNumber) > 0) {
//        upgradeCard();
//      } else if (showCardUrl != null && showCardGoto != null) {
//        showAdDialogCard();
//      }
//    });
  }

  ///判断升级弹窗是否可关闭
  _canCloseUpdateCard() {
    if (isForce == true) {
      canClose = false;
    } else {
      canClose = true;
    }
    return canClose;
  }

  @override
  void initState() {
    super.initState();

    initValue();
    // Initialize the Tab Controller
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      print("DDAI= controller.index=${controller.index}");
      setState(() {
        page = controller.index;
      });
    });
    Future.delayed(Duration.zero, () {
      model = model ?? MainModel.of(context);
    });
  }

  String getTitle() {
    if (page == 0) {
      return "车找人";
    } else {
      return "人找车";
    }
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model = model ?? MainModel.of(context);
    print("avator = ${model.userInfo?.avatar ?? ""}");
    super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: getMyScaffold(
        getTitle(),
        key: _scaffoldKey,
        titleAlign: TextAlign.start,
        drawer: _getDrawer(),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            color: colorPrimary,
            icon: Icon(Icons.list),
            iconSize: 35,
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        body: _getBody(),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          backgroundColor: colorPrimary,
          icon: const Icon(Icons.add),
          label: const Text('发布'),
          onPressed: () {
            _gotoPublish();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          notchMargin: 4.0,
          child: TabBar(
            tabs: <Tab>[
              Tab(icon: Icon(Icons.directions_car, color: colorPrimary)),
              Tab(icon: Icon(Icons.record_voice_over, color: colorPrimary)),
            ],
            controller: controller,
          ),
        ),
      ),
    );
  }

  _getBody() {
    return TabBarView(
      children: <Widget>[
        Test ? TestPage() : FirstTab(),
        SecondTab(),
      ],
      controller: controller,
    );
  }

  Drawer _getDrawer() {
    return Drawer(
      //侧边栏按钮Drawer
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Stack(children: <Widget>[
              Align(
                alignment: FractionalOffset.bottomLeft,
                child: Container(
                    height: 70.0,
                    margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
                    child: _drawerHeader()),
              ),
            ]),
          ),
          ListTile(
              title: Text('发布历史'),
              trailing: Icon(Icons.history),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryPage(model.userInfo.id)));
              }),
          ListTile(
              title: Text('修改个人资料'),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              }),
          ListTile(
              title: Text('关于'),
              trailing: Icon(Icons.error_outline),
              onTap: () {
                _gotoAbout();
              }),
          Divider(), //分割线控件
          _drawerLoginInOut(),
        ],
      ),
    );
  }

  _drawerLoginInOut() {
    if (model.userInfo != null) {
      return ListTile(
        title: Text('退出登录'),
        trailing: Icon(Icons.exit_to_app),
        onTap: () {
          AccountManager.logout().then((_) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          });
        }, //点击后收起侧边栏
      );
    } else {
      return ListTile(
        title: Text('账号登陆'),
        trailing: Icon(Icons.assignment_ind),
        onTap: () {
          AccountManager.logout().then((_) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          });
        }, //点击后收起侧边栏
      );
    }
  }

  _drawerHeader() {
    if (model.userInfo != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
            child: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(model.userInfo?.avatar ?? ""),
              radius: 35,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
              mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
              children: <Widget>[
                Text(
                  model.userInfo?.nickName ?? '',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Text(
                  model.userInfo?.profile ?? '',
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('images/icon.jpeg'),
              radius: 35,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
              mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "点击登录",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  _comparePlatform() {
    if (Platform.isAndroid) {
      return androidUrl;
    } else if (Platform.isIOS) {
      return iosUrl;
    } else {
      return null;
    }
  }

  ///广告弹窗ui
  Future<void> showAdDialogCard() async {
    if (showCardUrl != null && showCardGoto != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: GestureDetector(
                onTap: () {
                  launchcaller(showCardGoto);
                },
                child: CachedNetworkImage(
                  imageUrl: showCardUrl,
                  fit: BoxFit.cover,
                  width: 500,
                  height: 300,
                ),
              ));
        },
      );
    }
  }

  ///升级弹窗ui
  Future<void> upgradeCard() async {
    if (androidUrl != null && iosUrl != null && message != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: _canCloseUpdateCard(), // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('images/Upgrade_Card.png'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 30.0, top: 180.0),
                      child: Text(
                        message,
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(15, 42, 15, 40),
                      child: MaterialButton(
                        minWidth: 250,
                        height: 50,
                        color: colorPrimary,
                        onPressed: () {
                          launchcaller(_comparePlatform());
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(
                          '立即更新',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      );
    }
  }

  ///主界面back弹窗
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('确定退出吗?'),
            content: Text('退出后将不能收到最新的拼车信息'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('是'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('否'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  bool get wantKeepAlive => true;

  _gotoPublish() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PublishPage(
              page == 0 ? PageType.FindPassenger : PageType.FindVehicle)));

  _gotoAbout() {
    Navigator.of(context).pop(null);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutPage()));
  }

//  _gotoSearch() => Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => SearchPage(pageType: type)),
//      );
}
