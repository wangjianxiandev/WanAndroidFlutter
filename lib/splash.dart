import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidflutter/data/login.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/Config.dart';

import 'main_page.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString(Config.SP_USER_INFO);
    if (null != info && info.isNotEmpty) {
      Map userMap = json.decode(info);
      LoginData userEntity = new LoginData.fromJson(userMap);
      String _name = userEntity.username;
      String _pwd = prefs.getString(Config.SP_PWD);
      if (null != _pwd && _pwd.isNotEmpty) {
        doLogin(_name, _pwd);
      }
    }
  }

//  登录
  doLogin(String _name, String _pwd) {
    var data;
    data = {'username': _name, 'password': _pwd};
    HttpRequest.getInstance().post(Api.LOGIN, data: data,
        successCallBack: (data) {
      saveInfo(data);
      Navigator.of(context).pop();
    }, errorCallBack: (code, msg) {});
  }

//  保存用户信息
  void saveInfo(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.SP_USER_INFO, data);
  }

  void countdown() {
    Timer timer = new Timer(new Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => new MainPage()),
        (route) => route == null,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    countdown();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return new Scaffold(
        body: new Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: appTheme.themeColor,
      ),
      child: Icon(Icons.android),
    ));
  }
}
