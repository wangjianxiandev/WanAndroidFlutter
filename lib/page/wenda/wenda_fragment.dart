import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/widget/article_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class WenDaFragment extends StatefulWidget {
  @override
  _WenDaFragmentState createState() => _WenDaFragmentState();
}

class _WenDaFragmentState extends State<WenDaFragment>
    with AutomaticKeepAliveClientMixin {
  List<Article> wendaList = List();
  int currentPage = 0;
  ScrollController _scrollController;
  PageStateController _pageStateController;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 0;
      loadWenDaList();
    } else {
      currentPage++;
      loadWenDaList();
    }
  }

  @override
  void initState() {
    super.initState();
    _pageStateController = PageStateController();
    _scrollController = ScrollController();
    loadWenDaList();
  }

  void loadWenDaList() async {
    HttpRequest.getInstance().get("${Api.WENDA_LIST}$currentPage/json",
        successCallBack: (data) {
          if (currentPage == 0) {
            wendaList.clear();
          }
          _easyRefreshKey.currentState.callRefreshFinish();
          _easyRefreshKey.currentState.callLoadMoreFinish();
          if (data != null) {
            _pageStateController.changeState(PageState.LoadSuccess);
            Map<String, dynamic> dataJson = json.decode(data);
            List responseJson = json.decode(json.encode(dataJson["datas"]));
            setState(() {
              wendaList
                  .addAll(responseJson.map((m) => Article.fromJson(m)).toList());
            });
          } else {
            _pageStateController.changeState(PageState.NoData);
          }
        }, errorCallBack: (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        controller: _pageStateController,
        reload: () {
          loadWenDaList();
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
                itemCount: wendaList.length,
                itemBuilder: (context, index) {
                  return ArticleWidget(wendaList[index]);
                })),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.withAlpha(180),
          child: Icon(Icons.add),
          onPressed: () {
            _scrollController.animateTo(0,
                duration: Duration(milliseconds: 1000), curve: Curves.linear);
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
