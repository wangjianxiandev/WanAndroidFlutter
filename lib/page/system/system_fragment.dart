import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/generated/l10n.dart';
import 'package:wanandroidflutter/page/system/knowledge/KnowledgeFragment.dart';
import 'package:wanandroidflutter/page/system/navigation/NavigationFragment.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';

class SystemFragment extends StatefulWidget {
  @override
  _SystemFragmentState createState() => _SystemFragmentState();
}

class _SystemFragmentState extends State<SystemFragment>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController mTabController;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mTabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.themeColor,
        centerTitle: true,
        title: TabBar(
          controller: mTabController,
          //可以和TabBarView使用同一个TabController
          tabs: [
            Tab(
              text: S.of(context).tab_system,
            ),
            Tab(
              text: S.of(context).tab_navigation,
            )
          ],
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
        children: <Widget>[KnowledgeFragment(), NavigationFragment()],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
