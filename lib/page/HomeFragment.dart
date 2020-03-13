import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroidflutter/data/ArticleResponse.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/data/banner.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/base_response.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/utils/color.dart';
import 'package:wanandroidflutter/utils/textsize.dart';
import 'package:wanandroidflutter/widget/article_item.dart';
import 'package:wanandroidflutter/widget/custom_refresh.dart';
import 'package:wanandroidflutter/widget/page_widget.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

/// 首页
class _HomeFragmentState extends State<HomeFragment>
    with AutomaticKeepAliveClientMixin {
  List<Article> articleList = new List();
  int currentPage = 0;
  SwiperController _swiperController = SwiperController();
  List<BannerData> bannerList = List();
  ScrollController _scrollController;
  PageStateController _pageStateController;

  void loadArticleList(bool isRefresh) {
    HttpRequest.singleton.get(Api.ARTICLE_TOP).then((top) {
      _easyRefreshKey.currentState.callRefreshFinish();
      _easyRefreshKey.currentState.callLoadMoreFinish();
      if (currentPage == 0) {
        articleList.clear();
      }
      if (top != null) {
        _pageStateController.changeState(PageState.LoadSuccess);
        for (var topArticle in top.data) {
          articleList.add(Article.fromJson(topArticle));
        }
      }
      HttpRequest.singleton
          .get("article/list/${currentPage}/json")
          .then((result) {
        if (result != null) {
          ArticleResponse homeArticleList =
              ArticleResponse.fromJson(result.data);
          setState(() {
            articleList.addAll(Article.parseList(homeArticleList.datas));
          });
          if (articleList.length == 0) {
            _pageStateController.changeState(PageState.NoData);
          }
        } else {
          _pageStateController.changeState(PageState.LoadFail);
        }
      });
    });
  }

  loadBanner() async {
    BaseResponse baseResponse = await HttpRequest.singleton.get(Api.BANNER_URL);
    setState(() {
      bannerList.clear();
      for (var i in baseResponse.data) {
        bannerList.add(BannerData.fromJson(i));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadBanner();
    _pageStateController = PageStateController();
    _swiperController.autoplay = true;
    _scrollController = ScrollController();
    loadArticleList(true);
  }

  @override
  void dispose() {
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    super.dispose();
  }

  void _onRefresh(bool up) {
    if (up) {
      loadBanner();
      currentPage = 0;
      loadArticleList(true);
    } else {
      currentPage++;
      loadArticleList(false);
    }
  }

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageWidget(
        controller: _pageStateController,
        reload: () {
          loadArticleList(true);
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
                itemCount: articleList.length + 1,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Container(
                          height: 200,
                          child: bannerList.length != 0
                              ? Swiper(
                                  autoplayDelay: 5000,
                                  controller: _swiperController,
                                  itemHeight: 200,
                                  pagination: pagination(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return new Image.network(
                                      bannerList[index].imagePath,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  itemCount: bannerList.length,
                                  onTap: (index) {
                                    var item = bannerList[index];
//                                    CommonUtils.push(
//                                        context,
//                                        WebViewPage(
//                                          title: item.title,
//                                          url: item.url,
//                                        ));
                                  },
                                )
                              : SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                        )
                      : ArticleWidget(articleList[index - 1]);
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

  SwiperPagination pagination() => SwiperPagination(
      margin: EdgeInsets.all(0.0),
      builder: SwiperCustomPagination(
          builder: (BuildContext context, SwiperPluginConfig config) {
        return Container(
          color: Color(0x599E9E9E),
          height: 40,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            children: <Widget>[
              Text(
                "${bannerList[config.activeIndex].title}",
                style: TextStyle(
                    fontSize: TextSizeConst.smallTextSize,
                    color: ColorConst.color_white),
              ),
              Expanded(
                flex: 1,
                child: new Align(
                  alignment: Alignment.centerRight,
                  child: new DotSwiperPaginationBuilder(
                          color: Colors.black12,
                          activeColor: ColorConst.color_primary,
                          size: 6.0,
                          activeSize: 6.0)
                      .build(context, config),
                ),
              )
            ],
          ),
        );
      }));

  List<Widget> getTags(Article entity) {
    List<Widget> tags = [];
    for (int i = 0; i < entity.tags.length; i++) {
      tags.add(new Container(
          margin: EdgeInsets.only(left: 15),
          decoration: new BoxDecoration(
            border: new Border.all(color: Color(0xFF4282f4), width: 1),
            // 边色与边宽度
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular((2.0)), // 圆角度
          ),
          child: new Text(
            entity.tags[i].name,
            style: new TextStyle(fontSize: 32, color: const Color(0xFF4282f4)),
          )));
    }
    return tags;
  }

  /// with AutomaticKeepAliveClientMixin 切换Tabhou保留Tab状态，避免instance方法重复调用
  @override
  bool get wantKeepAlive => true;
}
