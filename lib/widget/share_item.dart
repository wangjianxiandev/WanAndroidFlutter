import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/webview_page.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/utils/refresh_event.dart';

import 'article_title.dart';

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
    var appTheme = Provider.of<ThemeModel>(context);
    var isDarkMode = Provider.of<DarkMode>(context).isDark;
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ArticleTitleWidget(article.title)),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text("${article.chapterName}",
                              style: TextStyle(
                                  color: !isDarkMode
                                      ? appTheme.themeColor
                                      : Colors.white.withAlpha(120),
                                  fontSize: 11.0)))),
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

  //删除分享
  _delete() {
    String url = "lg/user_article/delete/${article.id}/json";
    HttpRequest.getInstance().post(url, successCallBack: (data) {
      Application.eventBus.fire(RefreshEvent());
    }, errorCallBack: (code, msg) {}, context: context);
  }
}
