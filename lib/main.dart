import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/splash.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Application.sp = await SpUtil.getInstance();
  final appTheme = AppTheme();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  // Permission check
  Future<void> getPermission() async {
    //请求权限
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.storage,
    ].request();
    //校验权限
    if (statuses[Permission.notification] != PermissionStatus.granted) {
      Fluttertoast.showToast(
          msg: "需要打开通知权限",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      openAppSettings();
    }
    if (statuses[Permission.storage] != PermissionStatus.granted) {
      Fluttertoast.showToast(
          msg: "需要打开允许访问存储权限",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      openAppSettings();
    }
  }

  Future.wait([getPermission()]).then((result) {
    runApp(
      MultiProvider(
        // 接受监听
        providers: [
          ChangeNotifierProvider.value(value: appTheme),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Application.eventBus = EventBus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Application.eventBus.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: SplashView(),
    );
  }
}
