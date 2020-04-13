import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/generated/l10n.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
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
    var appTheme = Provider.of<ThemeModel>(context);
    bool isDarkMode = Provider.of<DarkMode>(context).isDark;
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
                S.of(context).register,
                style: TextStyle(
                    color: !isDarkMode
                        ? appTheme.themeColor
                        : Colors.white.withAlpha(120),
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                disabledColor: !isDarkMode
                    ? appTheme.themeColor
                    : Colors.white.withAlpha(120),
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
                    hintText: S.of(context).username,
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: !isDarkMode
                          ? appTheme.themeColor
                          : Colors.white.withAlpha(120),
                    )),
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
                    hintText: S.of(context).password,
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.themeColor),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_open,
                      color: !isDarkMode
                          ? appTheme.themeColor
                          : Colors.white.withAlpha(120),
                    )),
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
                          CommonUtils.toast(S.of(context).username);
                          return;
                        }
                        if (_pwd == null || _pwd.isEmpty) {
                          CommonUtils.toast(S.of(context).password);
                        }
                        doLogin();
                      },
                      textColor: Colors.white,
                      child: Text(
                        S.of(context).login,
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
