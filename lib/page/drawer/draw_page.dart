import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/data/rank.dart';
import 'package:wanandroidflutter/data/login.dart';
import 'package:wanandroidflutter/generated/l10n.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/account/login_fragment.dart';
import 'package:wanandroidflutter/page/collect/collect_fragment.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/theme/theme_colors.dart';
import 'package:wanandroidflutter/page/rank/rank_fragment.dart';
import 'package:wanandroidflutter/page/setting/setting_fragment.dart';
import 'package:wanandroidflutter/page/share/share_article_fragment.dart';
import 'package:wanandroidflutter/page/square/square_fragment.dart';
import 'package:wanandroidflutter/page/wenda/wenda_fragment.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
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
  RankData coinData;
  int rank = 0;
  int coinCount = 0;
  String avatarPath = null;

  List<Color> themeColors = List();

  int curSelectedIndex = 0;
  int clickedIndex = 0;

  final TextStyle textStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  void goLogin() {
    CommonUtils.push(
        context,
        Scaffold(
          body: LoginPage(),
        ));
  }

  void getUserInfo() async {
    String localInfo = Application.sp.getString(Config.SP_USER_INFO);
    String localAvatar = Application.sp.getString(Config.SP_AVATAR);
    if (localInfo != null && localInfo.isNotEmpty) {
      Map userMap = json.decode(localInfo);
      setState(() {
        loginData = LoginData.fromJson(userMap);
      });
    }
    if (localAvatar != null && localAvatar.isNotEmpty) {
      setState(() {
        avatarPath = Application.sp.getString(Config.SP_AVATAR);
      });
    }
  }

  void getCoinCount() async {
    HttpRequest.getInstance().get(Api.COIN_INFO, successCallBack: (data) {
      if (data != null && data.isNotEmpty) {
        Map coinMap = json.decode(data);
        setState(() {
          coinData = RankData.fromJson(coinMap);
          rank = coinData.rank;
          coinCount = coinData.coinCount;
          print(rank.toString() + "" + coinCount.toString());
        });
      }
    }, errorCallBack: (code, msg) {});
  }

  void loginOut() async {
    HttpRequest.getInstance().get(Api.LOGIN_OUT_JSON, successCallBack: (data) {
      Application.eventBus.fire(LoginOutEvent());
      CommonUtils.toast(S.of(context).loginoutTip);
    }, errorCallBack: (code, msg) {});
  }

  void clearSharedPreferences() async {
    await Application.sp.putString(Config.SP_COIN, null);
    await Application.sp.putString(Config.SP_USER_INFO, null);
  }

  void showThemeChooserDialog(
      BuildContext context, int selectIndex, ThemeModel appTheme) {
    var result = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("主题颜色选择"),
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
                    "确认",
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
    Application.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        getUserInfo();
        getCoinCount();
      });
    });
  }

  void saveThemeColor(int curIndex) {
    Application.sp.putInt(Config.SP_THEME_COLOR, curIndex);
  }

  getSelectedColorIndex() async {
    return await Application.sp.getInt(Config.SP_THEME_COLOR);
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    bool isDarkMode = Provider.of<DarkMode>(context).isDark;
    return new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: appTheme.themeColor,
          ),
          accountName: Text(
            loginData != null ? loginData.nickname : S.of(context).login_tip,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          accountEmail: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: <Widget>[
                Text(
                    loginData != null
                        ? S.of(context).level + rank.toString()
                        : S.of(context).level + "--",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  loginData != null
                      ? S.of(context).integral + coinCount.toString()
                      : S.of(context).integral + "-- ",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                )
              ],
            ),
          ),
          currentAccountPicture: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: loginData == null ? AssetImage("assets/img/ic_default.png")
                  : avatarPath == null ? AssetImage("assets/img/ic_avatar.png") : FileImage(File(avatarPath)),
            ),
            onTap: () async {
              if (loginData == null) {
                goLogin();
              } else {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                File srcFile = await ImageCropper.cropImage(
                  sourcePath: image.path,
                  aspectRatioPresets: [CropAspectRatioPreset.square],
                  androidUiSettings: AndroidUiSettings(
                      toolbarTitle: S.of(context).crop_image,
                      toolbarColor: appTheme.themeColor,
                      toolbarWidgetColor: Colors.white,
                      initAspectRatio: CropAspectRatioPreset.square,
                      hideBottomControls: true,
                      lockAspectRatio: true),
                );
                if (srcFile != null) {
                  Application.sp.putString(Config.SP_AVATAR, srcFile.path);
                  setState(() {
                    avatarPath = srcFile.path;
                  });
                }
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
            S.of(context).square,
            style: textStyle,
          ),
          onTap: () {
            CommonUtils.push(
                context,
                Scaffold(
                  appBar: AppBar(
                    title: Text(S.of(context).square),
                    backgroundColor: appTheme.themeColor,
                    centerTitle: true,
                  ),
                  body: SquareFragment(),
                ));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.share,
            size: 27.0,
          ),
          title: Text(
            S.of(context).me_share,
            style: textStyle,
          ),
          onTap: () {
            loginData != null
                ? CommonUtils.push(
                    context,
                    Scaffold(
                      appBar: AppBar(
                        title: Text(S.of(context).me_share),
                        backgroundColor: appTheme.themeColor,
                        centerTitle: true,
                      ),
                      body: ShareArticleFragment(),
                    ))
                : goLogin();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.favorite,
            size: 27.0,
          ),
          title: Text(
            S.of(context).me_collect,
            style: textStyle,
          ),
          onTap: () {
            loginData != null
                ? CommonUtils.push(
                    context,
                    Scaffold(
                      appBar: AppBar(
                        title: Text(S.of(context).me_collect),
                        backgroundColor: appTheme.themeColor,
                        centerTitle: true,
                      ),
                      body: CollectFragment(),
                    ))
                : goLogin();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.question_answer,
            size: 27.0,
          ),
          title: Text(
            S.of(context).wenda,
            style: textStyle,
          ),
          onTap: () {
            CommonUtils.push(
                context,
                Scaffold(
                  appBar: AppBar(
                    title: Text(S.of(context).wenda),
                    backgroundColor: appTheme.themeColor,
                    centerTitle: true,
                  ),
                  body: WenDaFragment(),
                ));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.timer,
            size: 27.0,
          ),
          title: Text(
            S.of(context).theme,
            style: textStyle,
          ),
          onTap: () {
            isDarkMode
                ? CommonUtils.toast(S.of(context).theme_tips)
                : showThemeChooserDialog(context, curSelectedIndex, appTheme);
          },
        ),
        new Divider(),
        ListTile(
          leading: Icon(
            Icons.looks_one,
            size: 27.0,
          ),
          title: Text(
            S.of(context).rank,
            style: textStyle,
          ),
          onTap: () {
            CommonUtils.push(
                context,
                Scaffold(
                  appBar: AppBar(
                    title: Text(S.of(context).integral_rank),
                    backgroundColor: appTheme.themeColor,
                    centerTitle: true,
                  ),
                  body: RankFragment(),
                ));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            size: 27.0,
          ),
          title: Text(
            S.of(context).loginout,
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
            S.of(context).setting,
            style: textStyle,
          ),
          onTap: () {
            CommonUtils.push(
              context,
              SettingFragment(),
            );
          },
        ),
      ],
    );
  }
}
