import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/main.dart';
import 'package:wanandroidflutter/utils/collect_event.dart';
import 'package:wanandroidflutter/widget/collect_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class CollectFragment extends StatefulWidget {
  @override
  _CollectFragmentState createState() => _CollectFragmentState();
}

class _CollectFragmentState extends State<CollectFragment> with AutomaticKeepAliveClientMixin{

  List<Article> collectList = List();
  int currentPage = 0;
  ScrollController _scrollController;
  PageStateController _pageStateController;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
  new GlobalKey<EasyRefreshState>();

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 0;
      loadCollectList();
    } else {
      currentPage++;
      loadCollectList();
    }
  }

  @override
  void initState() {
    super.initState();
    _pageStateController = PageStateController();
    _scrollController = ScrollController();
    loadCollectList();
    eventBus.on<CollectEvent>().listen((event) {
      setState(() {
        _onRefresh(true);
      });
    });
  }

  void loadCollectList() async {
    HttpRequest.getInstance().get("${Api.COLLECT_LIST}$currentPage/json",
        successCallBack: (data) {
          if (currentPage == 0) {
            collectList.clear();
          }
          _easyRefreshKey.currentState.callRefreshFinish();
          _easyRefreshKey.currentState.callLoadMoreFinish();
          if (data != null) {
            _pageStateController.changeState(PageState.LoadSuccess);
            Map<String, dynamic> dataJson = json.decode(data);
            List responseJson = json.decode(json.encode(dataJson["datas"]));
            setState(() {
              collectList
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
          loadCollectList();
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
                itemCount: collectList.length,
                itemBuilder: (context, index) {
                  return CollectWidget(collectList[index]);
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
