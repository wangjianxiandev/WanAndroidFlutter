import 'package:flutter/material.dart';
import 'package:wanandroidflutter/page/HomeFragment.dart';
import 'package:wanandroidflutter/page/tabs.dart';
import 'package:wanandroidflutter/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tabs(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
