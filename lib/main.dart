import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidflutter/page/tabs.dart';
import 'package:wanandroidflutter/routes/routes.dart';
import 'package:wanandroidflutter/splash.dart';

EventBus eventBus = EventBus();

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          platform: TargetPlatform.iOS//添加这个属性即可
      ),
    );
  }
}
