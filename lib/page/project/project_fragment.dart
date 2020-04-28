import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:wanandroidflutter/data/project_tab.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/page/project/project_list_fragment.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/widget/load_fail_widget.dart';

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
  bool isNetWorkError = false;

  @override
  void initState() {
    super.initState();
    loadProjectTab();
  }

  void loadProjectTab() async {
    HttpRequest.getInstance().get(Api.PROJECT_TAB, successCallBack: (data) {
      if (data != null) {
        List responseJson = json.decode(data);
        setState(() {
          isNetWorkError = false;
          mTabDatas = responseJson.map((m) => ProjectTab.fromJson(m)).toList();
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
    List<ProjectListFragment> pages = List();
    for (ProjectTab item in mTabDatas) {
      var page = ProjectListFragment(item.id);
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
                  loadProjectTab();
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
