import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/input/share_fragment.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/utils/common.dart';
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
    var appTheme = Provider.of<ThemeModel>(context);
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
          backgroundColor: appTheme.themeColor.withAlpha(180),
          child: Icon(Icons.add),
          onPressed: () {
            _inAddShare();
          }),
    );
  }

  //分享文章
  void _inAddShare() {
      showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return SimpleInputDialogLayout(
              isCollectArticle: false,
              isDIYText: true,
              themeText: "分享",
              dialogTitleText: "分享文章",
              confirmCallback2: (collectTitle,collectUrl) async{
                //收藏文章
                var data;
                data = {'title': collectTitle, 'link': collectUrl};
                HttpRequest.getInstance().post(Api.SHARE_ARTICLE, data: data, successCallBack: (data) {
                  CommonUtils.toast("分享文章成功");
                  _onRefresh(true);
                });
              },
            );
          }
      );
  }

  @override
  bool get wantKeepAlive => true;
}
