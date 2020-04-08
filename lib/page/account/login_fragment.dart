import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/page/account/login_form.dart';
import 'package:wanandroidflutter/page/account/register_form.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/widget/login_widget.dart';

class LoginPage extends StatelessWidget {
  var _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.themeColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            Expanded(
              flex: 2,
              child:
              Stack(
                children: <Widget>[
                  LoginTopPanel(),
                  Align(
                    alignment: Alignment.center,
                    child: LoginLogo(),
                  )
                ],
              ),
            ),
            Expanded(
              child: new PageView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index == 0
                      ? new LoginForm(_pageController)
                      : new RegisterForm(_pageController);
                },
                itemCount: 2,
                controller: _pageController,
              ),
              flex: 4,
            )
          ]),
        ]));
  }
}
