import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/splash.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';

EventBus eventBus = EventBus();

void main() {
  final appTheme = new AppTheme();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(
    MultiProvider(
      // 接受监听
      providers: [
        ChangeNotifierProvider.value(value: appTheme),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: SplashView(),
    );
  }
}
