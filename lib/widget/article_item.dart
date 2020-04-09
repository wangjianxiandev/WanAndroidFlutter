import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/webview_page.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/utils/widget_utils.dart';

import 'article_title.dart';
import 'favourite_animation.dart';

//文章item
class ArticleWidget extends StatefulWidget {
  Article article;

  ArticleWidget(this.article);

  @override
  State<StatefulWidget> createState() {
    return _ArticleWidgetState();
  }
}

class _ArticleWidgetState extends State<ArticleWidget> {
  Article article;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    var isDarkMode = Provider.of<DarkMode>(context).isDark;
    UniqueKey uniqueKey = UniqueKey();
    article = widget.article;
    return GestureDetector(
      onTap: () {
        CommonUtils.push(
            context,
            WebViewPage(
              url: article.link,
              title: article.title,
              id: article.id,
              isCollect: article.collect,
            ));
      },
      child: Card(
        elevation: 15.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        margin: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            article.author == ""
                                ? Icons.folder_shared
                                : Icons.person,
                            size: 20.0,
                            color: !isDarkMode
                                ? appTheme.themeColor
                                : Colors.white.withAlpha(120),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                                "${article.author.isNotEmpty ? article.author : article.shareUser}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.caption),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Offstage(
                                offstage: !article.fresh ?? true,
                                child: WidgetUtils.buildStrokeWidget(
                                    "新",
                                    !isDarkMode
                                        ? appTheme.themeColor
                                        : Colors.white.withAlpha(120),
                                    FontWeight.w400,
                                    11.0)),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Offstage(
                                offstage: article.type == 0 ?? false,
                                child: WidgetUtils.buildStrokeWidget(
                                    "置顶",
                                    !isDarkMode
                                        ? appTheme.themeColor
                                        : Colors.white.withAlpha(120),
                                    FontWeight.w400,
                                    11.0)),
                          )
                        ],
                      )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.access_time,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  .withAlpha(120),
                              size: 20,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Text("${article.niceDate}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.caption),
                          )
                        ],
                      )),
                ],
              ),
              if (article.envelopePic.isEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ArticleTitleWidget(article.title),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          ArticleTitleWidget(article.title),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            article.desc,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.network(
                        article.envelopePic,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${article.chapterName}/${article.superChapterName}",
                          style: TextStyle(
                              color: !isDarkMode
                                  ? appTheme.themeColor
                                  : Colors.white.withAlpha(120),
                              fontSize: 11.0),
                        ),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: !article.collect
                        ? IconButton(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 5),
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.black45,
                            ),
                            onPressed: () => _collect(uniqueKey),
                          )
                        : IconButton(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 5),
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () => _collect(uniqueKey),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //收藏/取消收藏
  _collect(UniqueKey uniqueKey) {
    String url = "";
    if (!article.collect) {
      url = "lg/collect/${article.id}/json";
    } else {
      url = "lg/uncollect_originId/${article.id}/json";
    }
    HttpRequest.getInstance().post(
        article.collect == false
            ? "${Api.COLLECT}${article.id}/json"
            : "${Api.UN_COLLECT_ORIGIN_ID}${article.id}/json",
        successCallBack: (data) {
      setState(() {
        Navigator.push(
            context,
            HeroDialogRoute(
                builder: (_) => FavouriteAnimation(
                      tag: uniqueKey,
                      isAdded: article.collect,
                    )));
        article.collect = !article.collect;
      });
    }, errorCallBack: (code, msg) {}, context: context);
  }
}
