import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/widget/article_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class SearchResultFragment extends StatefulWidget {
  String keyWord = "";

  SearchResultFragment(this.keyWord);

  @override
  _SearchResultFragmentState createState() => _SearchResultFragmentState();
}

class _SearchResultFragmentState extends State<SearchResultFragment> with AutomaticKeepAliveClientMixin{
  int currentPage = 0;
  List<Article> searchResultList = List();
  ScrollController _scrollController;
  PageStateController _pageStateController;

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageStateController = PageStateController();
    loadSearchList();
  }
  void loadSearchList() {
    var data = {'k': widget.keyWord};
    HttpRequest.getInstance().post("${Api.SEARCH_RESULT_LIST}$currentPage/json",
        data: data, successCallBack: (data) {
          if (currentPage == 0) {
            searchResultList.clear();
          }
          _easyRefreshKey.currentState.callRefreshFinish();
          _easyRefreshKey.currentState.callLoadMoreFinish();
          if (data != null) {
            _pageStateController.changeState(PageState.LoadSuccess);
            Map<String, dynamic> dataJson = json.decode(data);
            List responseJson = json.decode(json.encode(dataJson["datas"]));
            print("sear" + responseJson.toString());
            setState(() {
              searchResultList
                  .addAll(
                  responseJson.map((m) => Article.fromJson(m)).toList());
            });
          }else {
            _pageStateController.changeState(PageState.NoData);
          }
        }, errorCallBack: (code, msg) {});
  }

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 0;
      loadSearchList();
    } else {
      currentPage++;
      loadSearchList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        controller: _pageStateController,
        reload: () {
          loadSearchList();
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
                itemCount: searchResultList.length,
                itemBuilder: (context, index) {
                  return ArticleWidget(searchResultList[index]);
                })),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.withAlpha(180),
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
