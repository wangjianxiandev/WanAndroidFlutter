import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroidflutter/data/wechat_tab.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/page/wechat/wechat_list_fragment.dart';

class WeChatFragment extends StatefulWidget {
  @override
  WeChatFragmentState createState() => WeChatFragmentState();
}

class WeChatFragmentState extends State<WeChatFragment>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController mTabController;
  List<WeChatTab> mTabDatas = [];
  int mCurrentIndex = 0;
  var mPageController = new PageController(initialPage: 0);
  var isPageChanged = true;

  @override
  void initState() {
    super.initState();
    loadWeChatTab();
  }

  void loadWeChatTab() async {
    HttpRequest.getInstance().get(Api.WECHAT_TAB, successCallBack: (data) {
      List responseJson = json.decode(data);
      setState(() {
        mTabDatas = responseJson.map((m) => WeChatTab.fromJson(m)).toList();
        mTabController = TabController(
            initialIndex: 0, length: mTabDatas.length, vsync: this);
      });
    }, errorCallBack: (code, msg) {});
  }

  List<Tab> initTabs() {
    List<Tab> temps = [];
    for (var i = 0; i < mTabDatas.length; i++) {
      temps.add(Tab(
        text: mTabDatas[i].name,
      ));
    }
    return temps;
  }

  initPages() {
    List<WeChatListFragment> pages = List();
    for (WeChatTab item in mTabDatas) {
      var page = WeChatListFragment(item.id);
      pages.add(page);
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mTabDatas.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            controller: mTabController,
            tabs: initTabs(),
            isScrollable: true,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelColor: Colors.blueGrey,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: TabBarView(
          controller: mTabController,
          children: initPages(),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
