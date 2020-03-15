import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:wanandroidflutter/data/project_tab.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/page/project/project_list_fragment.dart';

class ProjectFragment extends StatefulWidget {
  @override
  ProjectFragmentState createState() => ProjectFragmentState();
}

class ProjectFragmentState extends State<ProjectFragment>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController mTabController;
  List<ProjectTab> mTabDatas = [];
  int mCurrentIndex = 0;
  var mPageController = new PageController(initialPage: 0);
  var isPageChanged = true;

  @override
  void initState() {
    super.initState();
    loadWeChatTab();
  }

  void loadWeChatTab() async {
    HttpRequest.getInstance().get(Api.PROJECT_TAB, successCallBack: (data) {
      List responseJson = json.decode(data);
      setState(() {
        mTabDatas = responseJson.map((m) => ProjectTab.fromJson(m)).toList();
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
    List<ProjectListFragment> pages = List();
    for (ProjectTab item in mTabDatas) {
      var page = ProjectListFragment(item.id);
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
          backgroundColor: Colors.red,
          title: TabBar(
            controller: mTabController,
            tabs: initTabs(),
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelColor: Colors.grey,
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
