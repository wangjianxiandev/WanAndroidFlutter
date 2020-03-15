import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/widget/article_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class WeChatListFragment extends StatefulWidget {
  int _Id;

  WeChatListFragment(this._Id);

  @override
  WeChatListFragmentState createState() => WeChatListFragmentState(_Id);
}

class WeChatListFragmentState extends State<WeChatListFragment>
    with AutomaticKeepAliveClientMixin {
  int _Id;
  int currentPage = 1;
  List<Article> weChatArticleList = List();

  WeChatListFragmentState(this._Id);

  ScrollController _scrollController;
  PageStateController _pageStateController;

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  @override
  void initState() {
    super.initState();
    _pageStateController = PageStateController();
    _scrollController = ScrollController();
    loadWeChatArticleList();
  }

  void loadWeChatArticleList() async {
    HttpRequest.getInstance().get("${Api.WECHAT_LIST}$_Id/$currentPage/json",
        successCallBack: (data) {
      if (currentPage == 1) {
        weChatArticleList.clear();
      }
      _easyRefreshKey.currentState.callRefreshFinish();
      _easyRefreshKey.currentState.callLoadMoreFinish();
      if (data != null) {
        _pageStateController.changeState(PageState.LoadSuccess);
        Map<String, dynamic> dataJson = json.decode(data);
        List responseJson = json.decode(json.encode(dataJson["datas"]));
        print(responseJson);
        setState(() {
          weChatArticleList
              .addAll(responseJson.map((m) => Article.fromJson(m)).toList());
        });
      }
    }, errorCallBack: (code, msg) {});
  }

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 1;
      loadWeChatArticleList();
    } else {
      currentPage++;
      loadWeChatArticleList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        controller: _pageStateController,
        reload: () {
          loadWeChatArticleList();
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
                itemCount: weChatArticleList.length,
                itemBuilder: (context, index) {
                  return ArticleWidget(weChatArticleList[index]);
                })),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor.withAlpha(180),
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
