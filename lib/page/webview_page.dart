import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/main.dart';
import 'package:wanandroidflutter/utils/clipboard_utils.dart';
import 'package:wanandroidflutter/utils/collect_event.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/widget/title_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key key, this.url, this.title, this.id, this.isCollect})
      : super(key: key);

  final String url;
  final String title;
  final int id;
  final bool isCollect;

  @override
  State<StatefulWidget> createState() {
    return WebViewPageState(url, title, id, isCollect);
  }
}

class WebViewPageState extends State<WebViewPage>
    with TickerProviderStateMixin {
  final String url;
  String title;
  int id;
  bool isCollect;
  WebViewController webViewController = null;

  //是否可以后退
  bool canGoBack = false;

  //是否可以前进
  bool canGoForward = false;

  //回到主页
  bool goHome = false;

  //是否正在加载
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;

  WebViewPageState(this.url, this.title, this.id, this.isCollect);

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 2.0).animate(controller);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        if (loading) {
          controller.forward();
        }
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
          appBar: TitleBar(
            isShowBack: true,
            title: title,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController controller) {
                    webViewController = controller;
                  },
                  onPageFinished: (String value) {
                    if (goHome) {
                      if (url != value) {
                        webViewController.goBack();
                      } else {
                        goHome = false;
                      }
                    }
                    loading = false;
                    if (controller.isAnimating) {
                      controller.reset();
                    }
                    webViewController.canGoBack().then((res) {
                      canGoBack = res;
                      setState(() {});
                    });
                    webViewController.canGoForward().then((res) {
                      canGoForward = res;
                      setState(() {});
                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                ),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.close),
                        ),
                        onTap: () {
                          webViewController.canGoBack().then((res) {
                            canGoBack = res;
                            if (res) {
                              webViewController.goBack();
                            } else {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_forward),
                        ),
                        onTap: () {
                          webViewController.canGoForward().then((res) {
                            canGoBack = res;
                            if (res) {
                              webViewController.goForward();
                            }
                          });
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.menu),
                        ),
                        onTap: () {
                          showBottomMenu();
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: RotationTransition(
                              turns: animation,
                              child: Icon(Icons.refresh),
                            )),
                        onTap: () {
                          loading = true;
                          webViewController.reload();
                          controller.forward();
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.open_in_browser),
                        ),
                        onTap: () {
                          launch(url);
                        },
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              )
            ],
          )),
      onWillPop: _requestPop,
    );
  }

  ///弹出框
  void showBottomMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Container(
          height: 90,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: Colors.transparent, width: 0),
                              // 边色与边宽度
                              color: Color(0xFFf5f5f5),
                              // 底色
                              shape: BoxShape.circle, // 默认值也是矩形
                            ),
                            width: 40,
                            height: 40,
                            child: Center(
                                child: Icon(
                                  Icons.share,
                                  size: 30,
                                )),
                          ),
                          Text(
                            "分享到广场",
                            style: TextStyle(fontSize: 8,
                                color: Color(0xff333333)),
                          )
                        ],
                      )),
                  Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.transparent, width: 0),
                                // 边色与边宽度
                                color: Color(0xFFf5f5f5),
                                // 底色
                                shape: BoxShape.circle, // 默认值也是矩形
                              ),
                              width: 40,
                              height: 40,
                              child: Center(
                                  child: isCollect ? Icon(
                                    Icons.favorite,
                                    size: 30,
                                  ) : Icon(Icons.favorite_border,
                                    size: 30,)),
                            ),
                            onTap: () => _collect(),
                          ),
                          Text(
                            "收藏",
                            style: TextStyle(fontSize: 8,
                                color: Color(0xff333333)),
                          )
                        ],
                      )),
                  Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.transparent, width: 0),
                                // 边色与边宽度
                                color: Color(0xFFf5f5f5),
                                // 底色
                                shape: BoxShape.circle, // 默认值也是矩形
                              ),
                              width: 40,
                              height: 40,
                              child: Center(
                                  child: Icon(
                                    Icons.content_copy,
                                    size: 30,
                                  )),
                            ),
                            onTap: () {
                              webViewController.currentUrl().then((curl) {
                                ClipboardUtil.saveData2Clipboard(url);
                                CommonUtils.toast("复制成功");
                                Navigator.pop(context);
                              });
                            },
                          ),
                          Text(
                            "复制链接",
                            style: TextStyle(fontSize: 8,
                                color: Color(0xff333333)),
                          )
                        ],
                      )),
                  Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.transparent, width: 0),
                                // 边色与边宽度
                                color: Color(0xFFf5f5f5),
                                // 底色
                                shape: BoxShape.circle, // 默认值也是矩形
                              ),
                              width: 40,
                              height: 40,
                              child: Center(
                                  child: Icon(
                                    Icons.exit_to_app,
                                    size: 30,
                                  )),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "退出",
                            style: TextStyle(fontSize: 8,
                                color: Color(0xff333333)),
                          )
                        ],
                      )),
                ],
              )
            ],
          ),
        );
      },
    ).then((val) {
      print(val);
    });
  }

  _collect() {
    String url = "";
    if (!isCollect) {
      url = "lg/uncollect_originId/$id/json";
    } else {
      url = "lg/collect/$id/json";
    }
    HttpRequest.getInstance().post(
        isCollect == false
            ? "${Api.COLLECT}$id/json"
            : "${Api.UN_COLLECT_ORIGIN_ID}$id/json",
        successCallBack: (data) {
          eventBus.fire(CollectEvent());
          setState(() {
           isCollect = !isCollect;
          });
        }, errorCallBack: (code, msg) {}, context: context);
  }
}
