import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  TextStyle listTitleStyle = TextStyle(fontSize: 18);
  TextStyle listSubTitleStyle = TextStyle(fontSize: 13);
  String localVersionName = '';
  String mobileTelphoneNum = '15801040555';
  String telphoneNum = '010-56422595';

//  initValue() async {
//    var dialogDataMap = await getDialogData();
//    setState(() {
//      thirdMessage = dialogDataMap["message"];
//    });
//  }

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "关于我们",
            style: textStyle1,
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.arrow_back,
                color: colorPrimaryDark,
              ),
              onPressed: () => Navigator.of(context).pop(null)),
        ),
        body: _getBody());
  }

  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      localVersionName = packageInfo.version;
    });
    print('#########$localVersionName');
  }

  _getBody() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.asset(
              'images/icon.jpeg',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '无忧车道',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Version $localVersionName',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
                dense: true,
//                contentPadding: const EdgeInsets.all(5),
                title: Text(
                  '商务合作',
                  style: listTitleStyle,
                ),
                subtitle: Text(
                  '$mobileTelphoneNum  $telphoneNum',
                  style: listSubTitleStyle,
                ),
                onTap: _showPhoneCard,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 3.0),
              color: Colors.white,
              child: ListTile(
                title: Text('官方微信'),
                subtitle: Text('wycdkf'),
                onLongPress: () {
                  Clipboard.setData(new ClipboardData(text: 'wycdkf'));
                  Fluttertoast.showToast(
                      msg: "已复制，打开微信直接粘贴即可添加",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 2,
                      backgroundColor: Colors.black12,
                      textColor: Colors.black,
                      fontSize: 14.0);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 3.0),
              color: Colors.white,
              child: ListTile(
                title: Text('用户须知'),
                onTap: _showUserNotice,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 3.0),
              color: Colors.white,
              child: ListTile(
                title: Text('关于我们'),
                onTap: _showAboutMsg,
              ),
            )
          ],
        )
      ],
    ));
  }

  Future<bool> _showPhoneCard() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: Text(telphoneNum),
            onTap: () {
              launchcaller('tel:' + telphoneNum);
            },
          ),
          ListTile(
            title: Text(mobileTelphoneNum),
            onTap: () {
              launchcaller('tel:' + mobileTelphoneNum);
            },
          ),
        ],
      )),
    );
  }

  Future<bool> _showUserNotice() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Column(
        children: <Widget>[
          Text(
            '1、平台是信息发布平台，平台为用户提供相应的展示信息推广和特定位置展示，平台发布的所有信息平台只负责发布、展示。\n2、平台里所有信息、资料，平台管理员有责任保证其准确性、完整性、有效性、时效性，但不一定能全部正确，请依据情况自行判断，私下通过本站私信或其他网络、电话等工具，寻求捐助行为，请大家自行进行判断，若因判断实物造成的随时和责任自己负责，本站不负任何责任。\n3、本平台如因系统维护或升级而需要暂停服务时，将事先公告，若因线路及非本站控制范围内的硬件故障或其他不可抗力而导致的暂停服务，于暂停服务而造成的一切不便与损失，平台不负责任何责任。\n4、会员对自己的言论和行为负责，完全承担发表内容的责任，所持立场与平台无关，平台使用者因为任何行为而触犯中华人民共和国法律或相关法规的，一切后果自己负责，平台不承担任何责任。凡以任何方式登录本站或直接、间接使用系统资料者，视为自愿接受平台声明的约束。\n本平台声明未涉及的问题参见国家有关法律法规，当本声明与国家法律法规冲突时，以国家法律法规为准',
            style: TextStyle(fontSize: 14),
          )
        ],
      )),
    );
  }

  Future<bool> _showAboutMsg() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Column(
        children: <Widget>[
          Text(
            '平台始终秉持“低碳环保、绿色出行”的创办理念，积极响应国家的号召，致力于解决每一位用户的出行问题。平台希望能为广大用户提供一个便捷、实用、安全的共享顺风车信息服务。平台定位十分明确，只做“共享型顺风车”网络信息服务平台，始终以“共享型”为原则，通过平台强大的信息优势，开车的用户可以分享车辆的空余座位，在回家的途中搭载顺路的乘客。不开车的用户可以通过平台来找到与自己行程顺路的车主\n自古以来，出行是每个人日常生活中的一部分，而随着社会的进步，交通拥堵称为我们共同面临的问题，我们积极响应国家号召，通过使用平台来达到为公路减压、为地球减压的目的。在不增加道路负担的情况下提升交通运力。随着平台日渐成熟，交通拥堵、限行带来的不便还有公共交通工具的拥挤等问题都得到缓解。',
            style: TextStyle(fontSize: 14),
          )
        ],
      )),
    );
  }
}
