import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/webview_page.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/widget_utils.dart';

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
    var appTheme = Provider.of<AppTheme>(context);
    article = widget.article;
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
              url: article.link, title: article.title, id: article.id,isCollect: article.collect,);
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
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 10),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Offstage(
                                offstage: !article.fresh ?? true,
                                child: WidgetUtils.buildStrokeWidget("新",
                                    appTheme.themeColor, FontWeight.w400, 9.0)),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Offstage(
                                offstage: article.type == 0 ?? false,
                                child: WidgetUtils.buildStrokeWidget("置顶",
                                    appTheme.themeColor, FontWeight.w400, 9.0)),
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
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Text(
                              "${article.niceDate}",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10.0),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: !isHighLight(article.title)
                      ? Text(
                          "${article.title}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0),
                        )
                      : Html(
                          data: article.title,
                        ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: WidgetUtils.buildStrokeWidget(
                            "${article.chapterName}/${article.superChapterName}",
                            Colors.grey,
                            FontWeight.w400,
                            10.0),
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
                            onPressed: () => _collect(),
                          )
                        : IconButton(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 5),
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () => _collect(),
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
  _collect() {
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
