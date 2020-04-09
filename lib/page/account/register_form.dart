import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/utils/common.dart';

class RegisterForm extends StatefulWidget {
  PageController _pageController;

  RegisterForm(this._pageController);

  @override
  State<StatefulWidget> createState() {
    return RegisterFormState(_pageController);
  }
}

class RegisterFormState extends State<RegisterForm>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;

  RegisterFormState(this._pageController);

  String _name;
  String _pwd;
  String _pwd2;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
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
                "去登录",
                style: TextStyle(
                    color: appTheme.themeColor,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),
              IconButton(
                icon: Icon(Icons.arrow_left),
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
                height: 30,
              ),
              TextField(
                cursorColor: appTheme.themeColor,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入密码",
                    fillColor: Colors.transparent,
                    focusColor: appTheme.themeColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    prefixIcon:
                        Icon(Icons.lock_open, color: appTheme.themeColor)),
                onChanged: (val) {
                  _pwd2 = val;
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
                        if (_pwd == null ||
                            _pwd.isEmpty ||
                            _pwd2 == null ||
                            _pwd2.isEmpty) {
                          CommonUtils.toast("请输入密码");
                        }
                        doRegister();
                      },
                      textColor: Colors.white,
                      child: Text(
                        "注册",
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

  void doRegister() {
    var data;
    data = {'username': _name, 'password': _pwd, "repassword": _pwd2};
    HttpRequest.getInstance().post(Api.REGISTER, data: data,
        successCallBack: (data) {
      _pageController.animateToPage(0,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }, errorCallBack: (code, msg) {});
  }

  @override
  bool get wantKeepAlive => true;
}
