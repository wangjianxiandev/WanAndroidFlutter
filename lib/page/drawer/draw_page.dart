import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidflutter/data/coin.dart';
import 'package:wanandroidflutter/data/login.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/main.dart';
import 'package:wanandroidflutter/page/account/login_fragment.dart';
import 'package:wanandroidflutter/page/collect/collect_fragment.dart';
import 'package:wanandroidflutter/page/home/theme_colors.dart';
import 'package:wanandroidflutter/page/rank/rank_fragment.dart';
import 'package:wanandroidflutter/page/setting/setting_fragment.dart';
import 'package:wanandroidflutter/page/share/share_article_fragment.dart';
import 'package:wanandroidflutter/page/square/square_fragment.dart';
import 'package:wanandroidflutter/page/wenda/wenda_fragment.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
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

  List<Color> themeColors = new List();

  int curSelectedIndex = 0;
  int clickedIndex = 0;

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

  void showThemeChooserDialog(
      BuildContext context, int selectIndex, AppTheme appTheme) {
    var result = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(
              "主题颜色选择",
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 250,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: themeColors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            clickedIndex = index;
                            print("clickindex = $clickedIndex");
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeColors[index],
                            shape: BoxShape.circle,
                          ),
                          width: 30,
                          height: 30,
                          child: Visibility(
                            visible: clickedIndex == index,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectIndex);
                  },
                  child: Text(
                    "取消",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: 20,
                  top: 0,
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(clickedIndex);
                  },
                  child: Text(
                    "确定",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    // 选择的结果回调
    result.then((colorSelectedIndex) {
      print("colorSelectedIndex = $colorSelectedIndex");
      curSelectedIndex = colorSelectedIndex;
      saveThemeColor(curSelectedIndex);
      appTheme.updateThemeColor(themeColors[curSelectedIndex]);
    });
  }

  @override
  void initState() {
    super.initState();
    themeColors = getThemeColors();
    getSelectedColorIndex().then((index) {
      curSelectedIndex = index ?? 0;
      clickedIndex = curSelectedIndex;
    });
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

  void saveThemeColor(int curIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Config.SP_THEME_COLOR, curIndex);
  }

  getSelectedColorIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(Config.SP_THEME_COLOR);
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: appTheme.themeColor,
          ),
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
                  ? "assets/img/ic_default.png"
                  : "assets/img/ic_avatar.png"),
            ),
            onTap: () {
              if (loginData == null) {
                goLogin();
              } else {
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
                      backgroundColor: appTheme.themeColor,
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
                        return Scaffold(
                          appBar: AppBar(
                            title: Text("我的分享"),
                            backgroundColor: appTheme.themeColor,
                            centerTitle: true,
                          ),
                          body: ShareArticleFragment(),
                        );
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
                            backgroundColor: appTheme.themeColor,
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
                      backgroundColor: appTheme.themeColor,
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
            '主题',
            style: textStyle,
          ),
          onTap: () {
            showThemeChooserDialog(context, curSelectedIndex, appTheme);
          },
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
                      backgroundColor: appTheme.themeColor,
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
                      backgroundColor: appTheme.themeColor,
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
