import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidflutter/data/coin.dart';
import 'package:wanandroidflutter/data/login.dart';
import 'package:wanandroidflutter/main.dart';
import 'package:wanandroidflutter/page/account/login_fragment.dart';
import 'package:wanandroidflutter/utils/Config.dart';
import 'package:wanandroidflutter/utils/login_event.dart';
import 'package:wanandroidflutter/utils/loginout_event.dart';
import 'package:wanandroidflutter/utils/widget_utils.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool isLogin = false;
  LoginData loginData;
  CoinData coinData;
  final TextStyle textStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  void goLogin() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: LoginPage(),
          );
        },
      ),
    );
  }

  void getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String localInfo = sharedPreferences.getString(Config.SP_USER_INFO);
    if (localInfo != null && localInfo.isNotEmpty) {
      Map userMap = json.decode(localInfo);
      setState(() {
        loginData = LoginData.fromJson(userMap);
      });
    }
  }

  void getCoinCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String coinInfo = sharedPreferences.getString(Config.SP_COIN);
    if (coinInfo != null && coinInfo.isNotEmpty) {
      Map coinMap = json.decode(coinInfo);
      setState(() {
        coinData = CoinData.fromJson(coinMap);
        print(coinData);
      });
    }
  }

  void clearSharedPreferences()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(Config.SP_COIN, null);
      await prefs.setString(Config.SP_USER_INFO, null);
  }

  @override
  void initState() {
    super.initState();
    isLogin = loginData != null && coinData != null;
    if (!isLogin) {
      getUserInfo();
      getCoinCount();
    }
    eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        getUserInfo();
        getCoinCount();
      });
    });
    eventBus.on<LoginOutEvent>().listen((event) {
      setState(() {

      });
    });
  }

  List<Widget> buildCoinWidget(bool isLogin) {
    List<Widget> list = [];
    if (isLogin) {
      list.add(Padding(
        child: StrokeWidget(
          strokeWidth: 2,
          edgeInsets: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          color: Colors.white,
          childWidget: Text(
              isLogin ? "lv " + coinData.level.toString() : "lv --",
              style: TextStyle(
                  fontSize: 11.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        padding: EdgeInsets.only(right: 10.0),
      ));
      list.add(Text(
        isLogin ? "积分：" + coinData.coinCount.toString() : "积分：-- ",
        style: TextStyle(color: Colors.white, fontSize: 15.0),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            loginData != null ? loginData.nickname : "点击头像登录",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          accountEmail: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: buildCoinWidget(loginData != null),
            ),
          ),
          currentAccountPicture: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: CircleAvatar(
              backgroundColor: Colors.white, //显示头像
              backgroundImage: AssetImage(loginData == null
                  ? "assets/img/ic_default_avatar.webp"
                  : "assets/img/ic_launcher_foreground.png"),
            ),
            onTap: () {
              if (loginData == null) {
                // 没有登录 跳转登录页面
                goLogin();
              } else {
                //登录则跳转用户中心
                print("点击跳转用户中心");
              }
            },
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.surround_sound,
            size: 27.0,
          ),
          title: Text(
            '广场',
            style: textStyle,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.favorite,
            size: 27.0,
          ),
          title: Text(
            '我的收藏',
            style: textStyle,
          ),
          onTap: () {

          },
        ),
        ListTile(
          leading: Icon(
            Icons.question_answer,
            size: 27.0,
          ),
          title: Text(
            '问答',
            style: textStyle,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.timer,
            size: 27.0,
          ),
          title: Text(
            'TODO',
            style: textStyle,
          ),
          onTap: () {},
        ),
        new Divider(),
        ListTile(
          leading: Icon(
            Icons.looks_one,
            size: 27.0,
          ),
          title: Text(
            '积分排行榜',
            style: textStyle,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.card_giftcard,
            size: 27.0,
          ),
          title: Text(
            '我的积分',
            style: textStyle,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            size: 27.0,
          ),
          title: Text(
            '退出',
            style: textStyle,
          ),
          onTap: () {
            ///显示主题 dialog
            eventBus.fire(LoginOutEvent());
            clearSharedPreferences();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            size: 27.0,
          ),
          title: Text(
            '设置',
            style: textStyle,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
