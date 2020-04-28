import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/navigation.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/webview_page.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/widget/load_fail_widget.dart';

class NavigationFragment extends StatefulWidget {
  @override
  _NavigationFragmentState createState() => _NavigationFragmentState();
}

class _NavigationFragmentState extends State<NavigationFragment> {
  List<NavigationData> navigationList = [];
  var appTheme;
  bool isNetWorkError = false;

  @override
  void initState() {
    super.initState();
    isNetWorkError = false;
    loadNavigationList();
  }

  void loadNavigationList() async {
    HttpRequest.getInstance().get(Api.NAVIGATION, successCallBack: (data) {
      if (data != null) {
        List responseJson = json.decode(data);
        setState(() {
          isNetWorkError = false;
          navigationList.addAll(
              responseJson.map((m) => NavigationData.fromJson(m)).toList());
        });
      } else {
        setState(() {
          isNetWorkError = true;
        });
      }
    }, errorCallBack: (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    appTheme = Provider.of<ThemeModel>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).iconTheme.color.withAlpha(0),
      ),
      child: isNetWorkError
          ? Scaffold(
              body: LoadFailWidget(
                onTap: () {
                  loadNavigationList();
                },
              ),
            )
          : Scrollbar(
              child: ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: navigationList.length,
                  itemBuilder: (context, index) {
                    return NavigationCategoryWidget(
                      navigationData: navigationList[index],
                    );
                  }),
            ),
    );
  }
}

class NavigationCategoryWidget extends StatelessWidget {
  final NavigationData navigationData;

  NavigationCategoryWidget({Key key, this.navigationData});

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            navigationData.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
          Wrap(
            spacing: 10,
            children: List.generate(
                navigationData.articles.length,
                (index) => ActionChip(
                      onPressed: () {
                        CommonUtils.push(
                            context,
                            WebViewPage(
                              url: navigationData.articles[index].link,
                              title: navigationData.articles[index].title,
                              id: navigationData.articles[index].id,
                              isCollect: navigationData.articles[index].collect,
                            ));
                      },
                      backgroundColor:
                          Theme.of(context).iconTheme.color.withAlpha(20),
                      label: Text(
                        navigationData.articles[index].title,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 13, color: CommonUtils.getRandomColor()),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
