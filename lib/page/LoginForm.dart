import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidflutter/data/login.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/main.dart';
import 'package:wanandroidflutter/utils/Config.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/utils/event_bus.dart';

class LoginForm extends StatefulWidget {
  PageController _pageController;

  LoginForm(this._pageController);

  @override
  State<StatefulWidget> createState() {
    return new LoginFormState(_pageController);
  }
}

class LoginFormState extends State<LoginForm>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;

  LoginFormState(this._pageController);

  String _name;
  String _pwd;

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: 70,
        ),
        new GestureDetector(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: true,
                child: IconButton(
                  icon: Icon(Icons.arrow_right),
                  disabledColor: Color(int.parse("0x00000000")),
                  onPressed: null,
                ),
              ),
              new Text(
                "去注册",
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                disabledColor: Colors.lightBlue,
                onPressed: null,
              ),
            ],
          ),
          onTap: () {
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          },
        ),
        new Container(
          margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
          child: new Column(
            children: <Widget>[
              new TextField(
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入用户名",
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.account_circle)),
                onChanged: (val) {
                  _name = val;
                },
              ),
              new Container(
                height: 30,
              ),
              new TextField(
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入密码",
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.lock_open)),
                onChanged: (val) {
                  _pwd = val;
                },
              ),
              new Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(50),
                  height: 40,
                  child: new RaisedButton(
                      onPressed: () {
                        if (null == _name || _name.isEmpty) {
                          CommonUtils.toast("请输入用户名");
                          return;
                        }
                        if (null == _pwd || _pwd.isEmpty) {
                          CommonUtils.toast("请输入密码");
                        }
                        doLogin();
                      },
                      textColor: Colors.white,
                      child: new Text(
                        "登录",
                        style: TextStyle(
                            fontSize: 20),
                      ),
                      color: Colors.lightBlue,
                      shape: new StadiumBorder(
                          side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.transparent,
                      ))))
            ],
          ),
        ),
      ],
    );
  }

  void doLogin() {
    var data;
    data = {'username': _name, 'password': _pwd};
    HttpRequest.getInstance().post(Api.LOGIN, data: data,
        successCallBack: (data) {
      eventBus.fire(LoginEvent());
      saveInfo(data);
      Navigator.of(context).pop();
    }, errorCallBack: (code, msg) {});
  }

  void saveInfo(data) async {
    Map userMap = json.decode(data);
    LoginData entity = new LoginData.fromJson(userMap);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.SP_USER_INFO, data);
    await prefs.setString(Config.SP_PWD, _pwd);
  }

  @override
  bool get wantKeepAlive => true;
}
