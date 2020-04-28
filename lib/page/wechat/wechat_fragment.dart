import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/wechat_tab.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/page/wechat/wechat_list_fragment.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/widget/load_fail_widget.dart';

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
  bool isNetWorkError = false;

  @override
  void initState() {
    super.initState();
    isNetWorkError = false;
    loadWeChatTab();
  }

  void loadWeChatTab() async {
    HttpRequest.getInstance().get(Api.WECHAT_TAB, successCallBack: (data) {
      if (data != null) {
        List responseJson = json.decode(data);
        setState(() {
          isNetWorkError = false;
          mTabDatas = responseJson.map((m) => WeChatTab.fromJson(m)).toList();
          mTabController = TabController(
              initialIndex: 0, length: mTabDatas.length, vsync: this);
        });
      } else {
        setState(() {
          isNetWorkError = true;
        });
      }
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
    var appTheme = Provider.of<ThemeModel>(context);
    return DefaultTabController(
      length: mTabDatas.length,
      child: isNetWorkError
          ? Scaffold(
              body: LoadFailWidget(
                onTap: () {
                  loadWeChatTab();
                },
              ),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: appTheme.themeColor,
                title: TabBar(
                  controller: mTabController,
                  tabs: initTabs(),
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  labelStyle: Theme.of(context).textTheme.subtitle,
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: Theme.of(context).textTheme.caption,
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
