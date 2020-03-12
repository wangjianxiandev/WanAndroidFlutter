import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/data/banner.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/httprequest.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

/// 首页
class _HomeFragmentState extends State<HomeFragment>
    with AutomaticKeepAliveClientMixin {
  List<Article> articleList = new List();
  int currentPage = 0;
  SwiperController _swiperController;
  List<BannerData> bannerList = [];

  loadTopArticle() async {
    HttpRequest.getInstance().get(Api.ARTICLE_TOP, successCallBack: (data) {
      List responseJson = json.decode(data);
      List<Article> topArticleList =
          responseJson.map((m) => new Article.fromJson(m)).toList();
      setState(() {
        articleList.addAll(topArticleList);
      });
    }, errorCallBack: (code, message) {});
  }

  loadHomeArticle() async {
    HttpRequest.getInstance().get(Api.HOME_ARTICLE_LIST,
        successCallBack: (data) {
      List responseJson = json.decode(data);
      List<Article> homeArticleList =
          responseJson.map((m) => new Article.fromJson(m)).toList();
      setState(() {
        articleList.addAll(homeArticleList);
      });
    }, errorCallBack: (code, message) {});
  }

  loadBanner() async {
    HttpRequest.getInstance().get(Api.BANNER_URL, successCallBack: (data) {
      List responseJson = json.decode(data);
      List<BannerData> bannerResponseList =
          responseJson.map((m) => new BannerData.fromJson(m)).toList();
      setState(() {
        bannerList.clear();
        bannerList.addAll(bannerResponseList);
      });
    }, errorCallBack: (code, message) {});
  }

  @override
  void initState() {
    super.initState();
    loadBanner();
    _swiperController = new SwiperController();
    _swiperController.startAutoplay();
    loadTopArticle();
  }

  @override
  void dispose() {
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    super.dispose();
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      bannerList[index].imagePath,
      fit: BoxFit.fill,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        child: ListView.builder(
          itemCount: articleList.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                height: 200,
                child: Swiper(
                  itemCount: bannerList.length,
                  itemBuilder: _swiperBuilder,
                  loop: false,
                  autoplay: false,
                  controller: _swiperController,
                  pagination: new SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                    color: Colors.black54,
                    activeColor: Colors.white,
                  )),
                  control: new SwiperControl(),
                  scrollDirection: Axis.horizontal,
                ),
              );
            } else {
              return renderRow(index - 1, context);
            }
          },
        ),
        onRefresh: () async {
          articleList.clear();
          currentPage = 0;
          loadTopArticle();
        },
        onLoad: () async {
          currentPage++;
          loadHomeArticle();
        },
      ),
    );
  }

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
            style: new TextStyle(
                fontSize: 32,
                color: const Color(0xFF4282f4)),
          )));
    }
    return tags;
  }

  //列表的item
  renderRow(index, context) {
    var article = articleList[index];
    print(articleList);
    return new Container(
        child: new InkWell(
//          onTap: () {
//            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
//              return new Browser(
//                url: article.link,
//                title: article.title,
//                id: article.id,
//              );
//            }));
//          },
      child: new Column(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(45),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    article.type == 1
                        ? new Text(
                            "置顶•",
                            style: new TextStyle(
                                fontSize: 32, color: const Color(0xFFf86734)),
                          )
                        : new Container(),
                    article.fresh == true
                        ? new Text(
                            "新•",
                            style: new TextStyle(
                                fontSize: 32, color: const Color(0xFF4282f4)),
                          )
                        : new Container(),
                    new Text(
                      article.author,
                      style: new TextStyle(
                          fontSize: 32, color: const Color(0xFF6e6e6e)),
                    ),
                    new Expanded(
                        child: article.tags.length == 0
                            ? new Container()
                            : new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                              children: getTags(article),
                              )),
                    new Text(
                      article.niceDate,
                      style: new TextStyle(
                          fontSize: 32, color: const Color(0xFF999999)),
                    )
                  ],
                ),
                new Divider(
                  height: 30,
                  color: Colors.transparent,
                ),
                new Row(
                  children: <Widget>[
                    article.envelopePic != ""
                        ? new Container(
                            child: new Image(
                                image: NetworkImage(article.envelopePic),
                                width: 330,
                                fit: BoxFit.fitWidth,
                                height: 220),
                            margin: EdgeInsets.only(right: 30),
                          )
                        : new Container(),
                    new Expanded(
                      child: new Text(
                        article.title,
                        maxLines: 2,
                        softWrap: false,
                        //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: 40, color: Color(0xFF333333)),
                      ),
                    ),
                  ],
                ),
                new Divider(
                  height: 30,
                  color: Colors.transparent,
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      article.superChapterName,
                      style: new TextStyle(
                          fontSize: 32, color: const Color(0xFF999999)),
                    ),
                    new Text(" • ",
                        style: new TextStyle(
                            fontSize: 32, color: const Color(0xFF999999))),
                    new Expanded(
                      child: new Text(article.chapterName,
                          style: new TextStyle(
                              fontSize: 32, color: const Color(0xFF999999))),
                    ),
                    new GestureDetector(
                      onTap: () => {
//                            HttpRequest.getInstance().post(
//                                article.collect == false
//                                    ? "${Api.COLLECT}${article.id}/json"
//                                    : "${Api.UN_COLLECT_ORIGIN_ID}${article.id}/json",
//                                successCallBack: (data) {
//                                  setState(() {
//                                    article.collect = !article.collect;
//                                  });
//                                }, errorCallBack: (code, msg) {}, context: context)
                      },
//                          child: new Image(
//                            image: article.collect == false
//                                ? AssetImage(R.assetsImgZan0)
//                                : AssetImage(R.assetsImgZan1),
//                            width: 66,
//                            height: 66,
//                          ),
                    )
                  ],
                )
              ],
            ),
          ),
          //分割线
          new Divider(height: 1)
        ],
      ),
    ));
  }

  /// with AutomaticKeepAliveClientMixin 切换Tabhou保留Tab状态，避免instance方法重复调用
  @override
  bool get wantKeepAlive => true;
}
