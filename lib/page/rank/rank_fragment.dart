import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/rank.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/widget/coin_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class RankFragment extends StatefulWidget {
  @override
  _RankFragmentState createState() => _RankFragmentState();
}

class _RankFragmentState extends State<RankFragment>
    with AutomaticKeepAliveClientMixin {
  List<RankData> rankList = List();
  int currentPage = 1;
  ScrollController _scrollController;
  PageStateController _pageStateController;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  RankData coinData;

  void getCoinCount() async {
    HttpRequest.getInstance().get(Api.COIN_INFO, successCallBack: (data) {
      if (data != null && data.isNotEmpty) {
        Map coinMap = json.decode(data);
        setState(() {
          coinData = RankData.fromJson(coinMap);
        });
      }
    }, errorCallBack: (code, msg) {});
  }

  @override
  void initState() {
    super.initState();
    _pageStateController = PageStateController();
    _scrollController = ScrollController();
    loadRankList();
    getCoinCount();
  }

  void _onRefresh(bool up) {
    if (up) {
      currentPage = 1;
      loadRankList();
    } else {
      currentPage++;
      loadRankList();
    }
  }

  void loadRankList() async {
    HttpRequest.getInstance().get("${Api.RANK_LIST}$currentPage/json",
        successCallBack: (data) {
      if (currentPage == 1) {
        rankList.clear();
      }
      _easyRefreshKey.currentState.callRefreshFinish();
      _easyRefreshKey.currentState.callLoadMoreFinish();
      if (data != null) {
        _pageStateController.changeState(PageState.LoadSuccess);
        Map<String, dynamic> dataJson = json.decode(data);
        List responseJson = json.decode(json.encode(dataJson["datas"]));
        setState(() {
          rankList
              .addAll(responseJson.map((m) => RankData.fromJson(m)).toList());
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
        body: Stack(children: <Widget>[
      PageWidget(
        controller: _pageStateController,
        reload: () {
          loadRankList();
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
                itemCount: rankList.length,
                itemBuilder: (context, index) {
                  return CoinRankWidget(rankList[index]);
                })),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: CoinRankWidget(coinData),
          color: Color(0xFFCDCDCD),
        ),
      )
    ]));
  }

  @override
  bool get wantKeepAlive => true;
}
