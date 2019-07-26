import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/pages/publish.dart';
import 'package:package_info/package_info.dart';

import '../test.dart';
import 'about.dart';
import 'first.dart';

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
    Timer(const Duration(seconds: 1), () {
      print(
          "INFO.  upgrade info :${packageInfo.version} + ${packageInfo.buildNumber} >> $version + $buildName");
      if (compareVersion(version, packageInfo.version) > 0 &&
          compareVersion(buildName.toString(), packageInfo.buildNumber) > 0) {
        upgradeCard();
      } else if (showCardUrl != null && showCardGoto != null) {
        showAdDialogCard();
      }
    });
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
    controller = new TabController(length: 2, vsync: this);
    controller.addListener(() {
      print("DDAI= controller.index=${controller.index}");
      setState(() {
        page = controller.index;
      });
    });
  }

  String getTitle() {
    if (page == 0) {
      return "车找人";
    } else if (page == 1) {
      return "人找车";
    } else {
      return "关于无忧车道";
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
    super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        // Appbar
        appBar: AppBar(
          title: Text(
            getTitle(),
            style: textStyle1,
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _gotoAbout();
              },
              icon: Icon(
                Icons.error_outline,
                size: 30,
                color: colorPrimary,
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        drawer: Drawer(
          //侧边栏按钮Drawer
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                //Material内置控件
                accountName: Text('CYC'), //用户名
                accountEmail: Text('example@126.com'), //用户邮箱
                currentAccountPicture: GestureDetector(
                  //用户头像
                  onTap: () => print('current user'),
                  child: CircleAvatar(
                    //圆形图标控件
                    backgroundImage: NetworkImage(
                        'https://upload.jianshu.io/users/upload_avatars/7700793/dbcf94ba-9e63-4fcf-aa77-361644dd5a87?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'), //图片调取自网络
                  ),
                ),
                otherAccountsPictures: <Widget>[
                  //粉丝头像
                  GestureDetector(
                    //手势探测器，可以识别各种手势，这里只用到了onTap
                    onTap: () => print('other user'), //暂且先打印一下信息吧，以后再添加跳转页面的逻辑
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://upload.jianshu.io/users/upload_avatars/10878817/240ab127-e41b-496b-80d6-fc6c0c99f291?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('other user'),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://upload.jianshu.io/users/upload_avatars/8346438/e3e45f12-b3c2-45a1-95ac-a608fa3b8960?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
                    ),
                  ),
                ],
                decoration: BoxDecoration(
                  //用一个BoxDecoration装饰器提供背景图片
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    // image: new NetworkImage('https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg')
                    //可以试试图片调取自本地。调用本地资源，需要到pubspec.yaml中配置文件路径
                    image: ExactAssetImage('images/lake.jpg'),
                  ),
                ),
              ),
              ListTile(
                  //第一个功能项
                  title: Text('First Page'),
                  trailing: Icon(Icons.arrow_upward),
                  onTap: () {
                    Navigator.of(context).pop();
//                    Navigator.of(context).push(new MaterialPageRoute(
//                        builder: (BuildContext context) => new SidebarPage()));
                  }),
              ListTile(
                  //第二个功能项
                  title: Text('Second Page'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
//                    Navigator.of(context).push(new MaterialPageRoute(
//                        builder: (BuildContext context) => new SidebarPage()));
                  }),
              ListTile(
                  //第二个功能项
                  title: Text('Second Page'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/a');
                  }),
              Divider(), //分割线控件
              ListTile(
                //退出按钮
                title: Text('Close'),
                trailing: Icon(Icons.cancel),
                onTap: () => Navigator.of(context).pop(), //点击后收起侧边栏
              ),
            ],
          ),
        ),

        // Set the TabBar view as the body of the Scaffold
        body: new TabBarView(
          // Add tabs as widgets
          children: <Widget>[
//            new FirstTab(),
            Test ? TestPage() : FirstTab(),
            new SecondTab(),
//            new ThirdTab(),
          ],
          // set the controller
          controller: controller,
        ),
        // Set the bottom navigation bar
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
//          shape: CircularNotchedRectangle(),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          notchMargin: 4.0,
          child: new TabBar(
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
                        color: Colors.blue,
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
                child: new Text('是'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('否'),
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

  _gotoAbout() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => AboutPage()));

//  _gotoSearch() => Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => SearchPage(pageType: type)),
//      );
}
