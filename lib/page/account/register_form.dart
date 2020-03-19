import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/utils/common.dart';


class RegisterForm extends StatefulWidget {
  PageController _pageController;

  RegisterForm(this._pageController);

  @override
  State<StatefulWidget> createState() {
    return new RegisterFormState(_pageController);
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
                "去登录",
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),
              IconButton(
                icon: Icon(Icons.arrow_left),
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
                height: 30,
              ),
              new TextField(
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入密码",
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.lock_open)),
                onChanged: (val) {
                  _pwd2 = val;
                },
              ),
              new Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(50),
                  height: 40,
                  child: new RaisedButton(
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
                      child: new Text(
                        "注册",
                        style: TextStyle(fontSize: 20),
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
