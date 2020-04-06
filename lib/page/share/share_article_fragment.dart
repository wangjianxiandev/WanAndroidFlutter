import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/refresh_event.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';
import 'package:wanandroidflutter/widget/share_item.dart';

class ShareArticleFragment extends StatefulWidget {
  @override
  _ShareArticleFragmentState createState() => _ShareArticleFragmentState();
}

class _ShareArticleFragmentState extends State<ShareArticleFragment>
    with AutomaticKeepAliveClientMixin {
  int currentPage = 1;
  List<Article> shareArticleList = List();
  ScrollController _scrollController;
  PageStateController _pageStateController;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 1;
      loadShareArticleList();
    } else {
      currentPage++;
      loadShareArticleList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageStateController = PageStateController();
    _scrollController = ScrollController();
    Application.eventBus.on<RefreshEvent>().listen((event) {
      setState(() {
        _onRefresh(true);
      });
    });
    loadShareArticleList();
  }

  void loadShareArticleList() async {
    HttpRequest.getInstance().get("${Api.SHARE_ARTICLE_LIST}$currentPage/json",
        successCallBack: (data) {
      if (currentPage == 1) {
        shareArticleList.clear();
      }
      _easyRefreshKey.currentState.callRefreshFinish();
      _easyRefreshKey.currentState.callLoadMoreFinish();
      if (data != null) {
        _pageStateController.changeState(PageState.LoadSuccess);
        Map<String, dynamic> dataJson = json.decode(data);
        List responseJson =
            json.decode(json.encode(dataJson["shareArticles"]["datas"]));
        print(responseJson);
        setState(() {
          shareArticleList
              .addAll(responseJson.map((m) => Article.fromJson(m)).toList());
        });
      } else {
        _pageStateController.changeState(PageState.NoData);
      }
    }, errorCallBack: (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      body: PageWidget(
        controller: _pageStateController,
        reload: () {
          loadShareArticleList();
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
                itemCount: shareArticleList.length,
                itemBuilder: (context, index) {
                  return ShareWidget(shareArticleList[index]);
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
