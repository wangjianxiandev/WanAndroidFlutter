import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/webview_page.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/refresh_event.dart';
import 'package:wanandroidflutter/utils/widget_utils.dart';

//文章item
class ShareWidget extends StatefulWidget {
  Article article;

  ShareWidget(this.article);

  @override
  State<StatefulWidget> createState() {
    return _ShareWidgetState();
  }
}

class _ShareWidgetState extends State<ShareWidget> {
  Article article;
  @override
  Widget build(BuildContext context) {
    article = widget.article;
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
            url: article.link, title: article.title, id: article.id, isCollect: article.collect,);
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
                            "${article.chapterName}",
                            Colors.grey,
                            FontWeight.w400,
                            10.0),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 5),
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      onPressed: () => _delete(),
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

  bool isHighLight(String title) {
    RegExp exp = new RegExp(r"<em class='highlight'>([\s\S]*?)</em>");
    return exp.hasMatch(title);
  }

  //删除分享
  _delete() {
    String url = "lg/user_article/delete/${article.id}/json";
    HttpRequest.getInstance().post(url,
        successCallBack: (data) {
          Application.eventBus.fire(RefreshEvent());
        }, errorCallBack: (code, msg) {}, context: context);
  }
}
