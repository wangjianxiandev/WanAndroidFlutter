import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/utils/utils.dart';
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
//        CommonUtils.push(
//            context,
//            WebViewPage(
//              title: title,
//              url: article.link,
//            ));
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
                            color: Colors.blue,
                          ),
                          Text(
                            "作者：${article.author.isNotEmpty ? article.author : article.shareUser}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: ColorConst.color_333,
                                fontSize: 12),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Offstage(
                                offstage: !article.fresh ?? true,
                                child: WidgetUtils.buildStrokeWidget(
                                    "新", Colors.redAccent)),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Offstage(
                                offstage: article.type == 0 ?? false,
                                child: WidgetUtils.buildStrokeWidget(
                                    "置顶", Colors.redAccent)),
                          )
                        ],
                      )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            color: Colors.grey,
                            size: 12,
                          ),
                          Text(
                            "${article.niceDate}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12),
                          ),
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
                              fontSize: 15.0),
                        )
                      : Html(
                          data: article.title,
                        ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${article.chapterName}/${article.superChapterName}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),

                  ),
                  !article.collect
                      ? IconButton(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.black45,
                          ),
                          onPressed: () => _collect(),
                        )
                      : IconButton(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () => _collect(),
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
    CommonUtils.showLoadingDialog(context);
    HttpRequest.singleton.post(url).whenComplete(() {
      Navigator.pop(context);
    }).then((result) {
      if (result != null) {
        setState(() {
          article.collect = !article.collect;
        });
      }
    });
  }
}
