import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidflutter/page/tabs.dart';

// 增加要跳转的页面只需要在此处添加
final routes = {
  // 配置根路由
  '/': (context, {argumment}) => Tabs(),
};

// 配置路由， 在官方代码上的优化，为固定写法
var onGenerateRoute = (RouteSettings settings) {
  // ignore: missing_return
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    // 路由配置不为空
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
        // 进行跳转，传参
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
      MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
