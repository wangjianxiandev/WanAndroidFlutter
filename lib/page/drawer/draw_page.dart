import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidflutter/data/coin.dart';
import 'package:wanandroidflutter/data/login.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/main.dart';
import 'package:wanandroidflutter/page/account/login_fragment.dart';
import 'package:wanandroidflutter/page/collect/collect_fragment.dart';
import 'package:wanandroidflutter/page/rank/rank_fragment.dart';
import 'package:wanandroidflutter/page/setting/setting_fragment.dart';
import 'package:wanandroidflutter/page/share/share_article_fragment.dart';
import 'package:wanandroidflutter/page/square/square_fragment.dart';
import 'package:wanandroidflutter/page/wenda/wenda_fragment.dart';
import 'package:wanandroidflutter/utils/Config.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/utils/login_event.dart';
import 'package:wanandroidflutter/utils/loginout_event.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  LoginData loginData;
  CoinData coinData;
  int rank = 0;
  int coinCount = 0;
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

  void getCoinCount() {
    HttpRequest.getInstance().get(Api.COIN_INFO, successCallBack: (data) {
      if (data != null && data.isNotEmpty) {
        Map coinMap = json.decode(data);
        setState(() {
          coinData = CoinData.fromJson(coinMap);
          rank = coinData.rank;
          coinCount = coinData.coinCount;
          print(rank.toString() + "" + coinCount.toString());
        });
      }
    }, errorCallBack: (code, msg) {});
  }

  void loginOut() async {
    HttpRequest.getInstance().get(Api.LOGIN_OUT_JSON, successCallBack: (data) {
      eventBus.fire(LoginOutEvent());
      CommonUtils.toast("登出成功");
    }, errorCallBack: (code, msg) {});
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.SP_COIN, null);
    await prefs.setString(Config.SP_USER_INFO, null);
  }

  @override
  void initState() {
    super.initState();
    if (loginData == null) {
      getUserInfo();
    }
    getCoinCount();
    eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        getUserInfo();
        getCoinCount();
      });
    });
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
              children: <Widget>[
                Text(loginData != null ? "排名 " + rank.toString() : "排名--",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  loginData != null ? "积分：" + coinCount.toString() : "积分：-- ",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                )
              ],
            ),
          ),
          currentAccountPicture: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: CircleAvatar(
              backgroundColor: Colors.white,
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("广场"),
                      centerTitle: true,
                    ),
                    body: SquareFragment(),
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.share,
            size: 27.0,
          ),
          title: Text(
            '我的分享',
            style: textStyle,
          ),
          onTap: () {
            loginData != null
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ShareArticleFragment();
                      },
                    ),
                  )
                : goLogin();
          },
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
            loginData != null
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text("我的收藏"),
                            centerTitle: true,
                          ),
                          body: CollectFragment(),
                        );
                      },
                    ),
                  )
                : goLogin();
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("问答"),
                      centerTitle: true,
                    ),
                    body: WenDaFragment(),
                  );
                },
              ),
            );
          },
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("积分排行"),
                      centerTitle: true,
                    ),
                    body: RankFragment(),
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            size: 27.0,
          ),
          title: Text(
            '退出登录',
            style: textStyle,
          ),
          onTap: () {
            loginOut();
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("设置"),
                      centerTitle: true,
                    ),
                    body: SettingFragment(),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
