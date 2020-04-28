import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/widget/article_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class KnowledgeListFragment extends StatefulWidget {
  int _Id;

  KnowledgeListFragment(this._Id);

  @override
  _KnowledgeListFragmentState createState() => _KnowledgeListFragmentState(_Id);
}

class _KnowledgeListFragmentState extends State<KnowledgeListFragment>
    with AutomaticKeepAliveClientMixin {
  int _Id;
  int currentPage = 0;
  List<Article> knowledgeList = List();
  ScrollController _scrollController;
  PageStateController _pageStateController;

  _KnowledgeListFragmentState(this._Id);

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 0;
      loadKnowledgeData();
    } else {
      currentPage++;
      loadKnowledgeData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageStateController = PageStateController();
    _scrollController = ScrollController();
    loadKnowledgeData();
  }

  void loadKnowledgeData() async {
    var params = {"cid": _Id};
    HttpRequest.getInstance().get("${Api.HOME_ARTICLE_LIST}$currentPage/json",
        data: params, successCallBack: (data) {
      if (currentPage == 0) {
        knowledgeList.clear();
      }
      _easyRefreshKey.currentState.callRefreshFinish();
      _easyRefreshKey.currentState.callLoadMoreFinish();
      if (data != null) {
        _pageStateController.changeState(PageState.LoadSuccess);
        Map<String, dynamic> dataJson = json.decode(data);
        List responseJson = json.decode(json.encode(dataJson["datas"]));
        setState(() {
          knowledgeList
              .addAll(responseJson.map((m) => Article.fromJson(m)).toList());
        });
        if (knowledgeList.length == 0) {
          _pageStateController.changeState(PageState.NoData);
        }
      } else {
        _pageStateController.changeState(PageState.LoadFail);
      }
    }, errorCallBack: (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    return Scaffold(
      body: PageWidget(
        controller: _pageStateController,
        reload: () {
          loadKnowledgeData();
        },
        child: CustomRefresh(
            easyRefreshKey: _easyRefreshKey,
            onRefresh: () {
              _onRefresh(true);
            },
            loadMore: () {
              _onRefresh(false);
            },
            child: ListView.builder(
                controller: _scrollController,
                itemCount: knowledgeList.length,
                itemBuilder: (context, index) {
                  return ArticleWidget(knowledgeList[index]);
                })),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: appTheme.themeColor.withAlpha(180),
          child: Icon(Icons.arrow_upward),
          onPressed: () {
            _scrollController.animateTo(0,
                duration: Duration(milliseconds: 1000), curve: Curves.linear);
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
