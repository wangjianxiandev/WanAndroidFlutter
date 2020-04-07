import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/webview_page.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/widget_utils.dart';

import 'favourite_animation.dart';

//项目item
class ProjectArticleWidget extends StatefulWidget {
  Article article;

  ProjectArticleWidget(this.article);

  @override
  State<StatefulWidget> createState() {
    return _ProjectArticleWidgetState();
  }
}

class _ProjectArticleWidgetState extends State<ProjectArticleWidget> {
  Article article;

  @override
  Widget build(BuildContext context) {
    article = widget.article;
    UniqueKey uniqueKey = UniqueKey();
    var appTheme = Provider.of<AppTheme>(context);
    return GestureDetector(
      onTap: () {
        String title = "";
        if (!isHighLight(article.title)) {
          title = article.title;
        } else {
          title = article.title
              .replaceAll("<em class='highlight'>", "")
              .replaceAll("</em>", "");
        }
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new WebViewPage(
            url: article.link,
            title: article.title,
            id: article.id,
            isCollect: article.collect,
          );
        }));
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
                            color: appTheme.themeColor,
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
                                    appTheme.themeColor,
                                    FontWeight.w400,
                                    11.0)),
                          ),
                        ],
                      )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.access_time,
                              color: Colors.grey,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ArticleTitleWidget(article.title),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          article.desc,
                          style: Theme.of(context).textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.network(
                    article.envelopePic,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
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
                                color: appTheme.themeColor, fontSize: 11.0),
                          ))),
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

  //判断title是否有文字需要加斜体
  bool isHighLight(String title) {
    RegExp exp = new RegExp(r"<em class='highlight'>([\s\S]*?)</em>");
    return exp.hasMatch(title);
  }

  //收藏/取消收藏
  _collect(UniqueKey uniqueKey) {
    Navigator.push(
        context,
        HeroDialogRoute(
            builder: (_) => FavouriteAnimation(
              tag: uniqueKey,
              isAdded: !article.collect,
            )));
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
        article.collect = !article.collect;
      });
    }, errorCallBack: (code, msg) {}, context: context);
  }
}

class ArticleTitleWidget extends StatelessWidget {
  final String title;

  ArticleTitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Html(
      padding: EdgeInsets.symmetric(vertical: 5),
      data: title,
      defaultTextStyle: Theme.of(context).textTheme.subtitle,
    );
  }
}
