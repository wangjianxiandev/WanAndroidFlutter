//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:play_android/http/HttpRequest.dart';
//import 'package:play_android/widget/T.dart';
//
//import '../../Api.dart';
//
////注册页面
//class RegisterForm extends StatefulWidget {
//  PageController _pageController;
//
//  RegisterForm(this._pageController);
//
//  @override
//  State<StatefulWidget> createState() {
//    return RegisterFormState(_pageController);
//  }
//}
//
//class RegisterFormState extends State<RegisterForm>
//    with AutomaticKeepAliveClientMixin {
//  PageController _pageController;
//  String name;
//  String pwd;
//  String pwd2;
//
//  RegisterFormState(this._pageController);
//
//  @override
//  Widget build(BuildContext context) {
//    return new Column(
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: <Widget>[
//        new Container(
//          height: ScreenUtil.getInstance().setHeight(110),
//        ),
//        new GestureDetector(
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Visibility(
//                visible: true,
//                child: IconButton(
//                  icon: Icon(Icons.arrow_left),
//                  tooltip: 'Increase volume by 10',
//                  disabledColor: Colors.lightBlue,
//                  onPressed: null,
//                ),
//              ),
//              new Text(
//                "去登录",
//                style: TextStyle(
//                    color: Colors.lightBlue,
//                    fontSize: ScreenUtil.getInstance().setSp(40),
//                    decoration: TextDecoration.none),
//              ),
//              IconButton(
//                icon: Icon(Icons.arrow_right),
//                tooltip: 'Increase volume by 10',
//                disabledColor: Color(int.parse("0x00000000")),
//                onPressed: null,
//              ),
//            ],
//          ),
//          onTap: () {
//            _pageController.animateToPage(0,
//                duration: const Duration(milliseconds: 300),
//                curve: Curves.ease);
//          },
//        ),
//        new Container(
//          margin: EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(110)),
//          width: ScreenUtil.getInstance().setWidth(750),
//          child: new Column(
//            children: <Widget>[
//              new TextField(
//                decoration: InputDecoration(
//                  filled: true,
//                  hintText: "请输入用户名",
//                  fillColor: Colors.transparent,
//                  prefixIcon: Icon(Icons.account_circle),
//                ),
//                onChanged: (val) {
//                  name = val;
//                },
//              ),
//              new Container(
//                height: ScreenUtil.getInstance().setWidth(30),
//              ),
//              new TextField(
//                decoration: InputDecoration(
//                    filled: true,
//                    hintText: "请输入密码",
//                    fillColor: Colors.transparent,
//                    prefixIcon: Icon(Icons.lock_open)),
//                obscureText: true,
//                onChanged: (val) {
//                  pwd = val;
//                },
//              ),
//              new Container(
//                height: ScreenUtil.getInstance().setWidth(30),
//              ),
//              new TextField(
//                decoration: InputDecoration(
//                    filled: true,
//                    hintText: "请输入密码",
//                    fillColor: Colors.transparent,
//                    prefixIcon: Icon(Icons.lock_open)),
//                obscureText: true,
//                onChanged: (val) {
//                  pwd2 = val;
//                },
//              ),
//              new Container(
//                  width: double.infinity,
//                  margin: EdgeInsets.only(
//                      top: ScreenUtil.getInstance().setWidth(85)),
//                  height: ScreenUtil.getInstance().setWidth(120),
//                  child: new RaisedButton(
//                      onPressed: () {
//                        doRegister();
//                      },
//                      textColor: Colors.white,
//                      child: new Text(
//                        "注册",
//                        style: TextStyle(
//                            fontSize: ScreenUtil.getInstance().setSp(40)),
//                      ),
//                      color: Colors.lightBlue,
//                      shape: new StadiumBorder(
//                          side: new BorderSide(
//                        style: BorderStyle.solid,
//                        color: Colors.transparent,
//                      ))))
//            ],
//          ),
//        ),
//      ],
//    );
//  }
//
//  //注册
//  void doRegister() {
//    var data;
//    data = {'username': name, 'password': pwd, "repassword": pwd2};
//    HttpRequest.getInstance().post(Api.REGISTER, data: data,
//        successCallBack: (data) {
//      T.showToast("注册成功,去登录吧^_^");
//      _pageController.animateToPage(0,
//          duration: const Duration(milliseconds: 300),
//          curve: Curves.ease);
//    }, errorCallBack: (code, msg) {
//      T.showToast(msg);
//    });
//  }
//
//  @override
//  bool get wantKeepAlive => true;
//}
