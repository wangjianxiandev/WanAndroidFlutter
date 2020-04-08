import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroidflutter/data/navigation.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/webview_page.dart';
import 'package:wanandroidflutter/utils/common.dart';

class NavigationFragment extends StatefulWidget {
  @override
  _NavigationFragmentState createState() => _NavigationFragmentState();
}

class _NavigationFragmentState extends State<NavigationFragment> {
  List<NavigationData> navigationList = [];

  @override
  void initState() {
    super.initState();
    loadNavigationList();
  }

  void loadNavigationList() async {
    HttpRequest.getInstance().get(Api.NAVIGATION, successCallBack: (data) {
      List responseJson = json.decode(data);
      setState(() {
        navigationList.addAll(
            responseJson.map((m) => NavigationData.fromJson(m)).toList());
      });
    }, errorCallBack: (code, msg) {});
  }

  List<Widget> getChildren() {
    List<Widget> children = [];
    for (int i = 0; i < navigationList.length; i++) {
      children.add(new Row(
        children: <Widget>[
          new Text(
            navigationList[i].name,
            style: TextStyle(fontSize: 15),
          )
        ],
      ));
      for (int j = 0; j < navigationList[i].articles.length; j++) {
        children.add(new GestureDetector(
          onTap: () => {
            CommonUtils.push(
                context,
                WebViewPage(
                  url: navigationList[i].articles[j].link,
                  title: navigationList[i].articles[j].title,
                  id: navigationList[i].articles[j].id,
                  isCollect: navigationList[i].articles[j].collect,
                ))
          },
          child: new Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.transparent, width: 1),
                // 边色与边宽度
                color: Color(0xFFf5f5f5),
                borderRadius: new BorderRadius.circular(10), // 圆角度
              ),
              child: new Text(
                navigationList[i].articles[j].title,
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 15, color: CommonUtils.getRandomColor()),
              )),
        ));
      }
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 10.0,
          runSpacing: 10.0,
          children: getChildren(),
        ),
      ),
    );
  }
}
