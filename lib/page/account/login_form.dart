import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/Config.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/utils/login_event.dart';

class LoginForm extends StatefulWidget {
  PageController _pageController;

  LoginForm(this._pageController);

  @override
  State<StatefulWidget> createState() {
    return LoginFormState(_pageController);
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
    var appTheme = Provider.of<AppTheme>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 40,
        ),
        GestureDetector(
          child: Row(
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
              Text(
                "去注册",
                style: TextStyle(
                    color: appTheme.themeColor,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                disabledColor: appTheme.themeColor,
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
        Container(
          margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
          child: Column(
            children: <Widget>[
              TextField(
                cursorColor: appTheme.themeColor,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入用户名",
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    prefixIcon:
                        Icon(Icons.account_circle, color: appTheme.themeColor)),
                onChanged: (val) {
                  _name = val;
                },
              ),
              Container(
                height: 30,
              ),
              TextField(
                cursorColor: appTheme.themeColor,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入密码",
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    prefixIcon:
                        Icon(Icons.lock_open, color: appTheme.themeColor)),
                onChanged: (val) {
                  _pwd = val;
                },
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(50),
                  height: 40,
                  child: RaisedButton(
                      onPressed: () {
                        if (_name == null || _name.isEmpty) {
                          CommonUtils.toast("请输入用户名");
                          return;
                        }
                        if (_pwd == null || _pwd.isEmpty) {
                          CommonUtils.toast("请输入密码");
                        }
                        doLogin();
                      },
                      textColor: Colors.white,
                      child: Text(
                        "登录",
                        style: TextStyle(fontSize: 20),
                      ),
                      color: appTheme.themeColor,
                      shape: StadiumBorder(
                          side: BorderSide(
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
      Application.eventBus.fire(LoginEvent());
      saveUserInfo(data);
      Navigator.of(context).pop();
    }, errorCallBack: (code, msg) {});
  }

  void saveUserInfo(data) {
    Application.sp.putString(Config.SP_USER_INFO, data);
    Application.sp.putString(Config.SP_PWD, _pwd);
  }

  @override
  bool get wantKeepAlive => true;
}
