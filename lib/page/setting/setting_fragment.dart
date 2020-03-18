import 'package:flutter/material.dart';
import 'package:wanandroidflutter/utils/common.dart';

import '../webview_page.dart';

class SettingFragment extends StatefulWidget {
  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              child: ListTile(
                title: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "夜间模式",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                onTap: () {
                  CommonUtils.showAlertDialog(context, "确定清除缓存吗？",
                      confirmText: "确定", confirmCallback: () {
                    //清除缓存
                    CommonUtils.clearCache();
                  });
                },
              )),
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              child: ListTile(
                title: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "清除缓存",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                onTap: () {
                  CommonUtils.showAlertDialog(context, "确定清除缓存吗？",
                      confirmText: "确定", confirmCallback: () {
                    //清除缓存
                    CommonUtils.clearCache();
                  });
                },
              )),
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              child: ListTile(
                title: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "关于作者",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return new WebViewPage(
                      url: "https://blog.csdn.net/qq_39424143",
                      title: "我的博客",
                      id: null,
                      isCollect: false,
                    );
                  }));
                },
              )),
        ],
      ),
    );
  }
}
