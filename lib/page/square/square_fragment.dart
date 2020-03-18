import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/widget/article_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class SquareFragment extends StatefulWidget {
  @override
  _SquareFragmentState createState() => _SquareFragmentState();
}

class _SquareFragmentState extends State<SquareFragment>
    with AutomaticKeepAliveClientMixin {
  List<Article> squareList = List();
  int currentPage = 0;
  ScrollController _scrollController;
  PageStateController _pageStateController;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 0;
      loadSquareList();
    } else {
      currentPage++;
      loadSquareList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageStateController = PageStateController();
    _scrollController = ScrollController();
    loadSquareList();
  }

  void loadSquareList() async {
    HttpRequest.getInstance().get("${Api.SQUARE_LIST}$currentPage/json",
        successCallBack: (data) {
      if (currentPage == 0) {
        squareList.clear();
      }
      _easyRefreshKey.currentState.callRefreshFinish();
      _easyRefreshKey.currentState.callLoadMoreFinish();
      if (data != null) {
        _pageStateController.changeState(PageState.LoadSuccess);
        Map<String, dynamic> dataJson = json.decode(data);
        List responseJson = json.decode(json.encode(dataJson["datas"]));
        setState(() {
          squareList
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
          loadSquareList();
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
                itemCount: squareList.length,
                itemBuilder: (context, index) {
                  return ArticleWidget(squareList[index]);
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
