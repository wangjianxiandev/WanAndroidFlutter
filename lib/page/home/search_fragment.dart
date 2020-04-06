import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/data/hot_key.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/home/search_result_fragment.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/utils/Config.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/widget/icon_text.dart';

class SearchFragment extends StatefulWidget {
  @override
  _SearchFragmentState createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  var isSearch = false;
  var appTheme;

  List<String> hotKeyList = List();
  List<String> searchHistory = List();
  String searchKey = null;
  int currentPage = 0;
  List<Article> searchResultList = List();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initHotKey();
    initSearchHistory();
  }

  void initHotKey() {
    HttpRequest.getInstance().get(Api.HOT_KEY, successCallBack: (data) {
      List responseJson = json.decode(data);
      List<HotKey> hotKeyListResponse =
          responseJson.map((m) => HotKey.fromJson(m)).toList();
      setState(() {
        hotKeyList.clear();
        for (var i = 0; i < hotKeyListResponse.length; i++) {
          hotKeyList.add(hotKeyListResponse[i].name);
        }
      });
    }, errorCallBack: (code, msg) {});
  }

  void initSearchHistory() {
    String history = Application.sp.getString(Config.SP_SEARCH_HISTORY);
    if (history != null && history.isNotEmpty) {
      setState(() {
        searchHistory = history.split(",");
      });
    }
  }

  void addSearchHistory(String key) {
    if (searchHistory.contains(key)) {
      searchHistory.remove(key);
    }
    searchHistory.add(key);
    String result = "";
    for (var i = 0; i < searchHistory.length; i++) {
      result += searchHistory[i];
      if (i + 1 != searchHistory.length) {
        result += ",";
      }
    }
    Application.sp.putString(Config.SP_SEARCH_HISTORY, result);
  }

  void clearHistory() async {
    await Application.sp.remove(Config.SP_SEARCH_HISTORY);
    setState(() {
      searchHistory.clear();
    });
  }

  _goToSearchResultPage(String name) async {
    addSearchHistory(name);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(name),
              backgroundColor: appTheme.themeColor,
              centerTitle: true,
            ),
            body: SearchResultFragment(name),
          );
        },
      ),
    );
  }

  _buildWrapItem() {
    List<Widget> items = List();
    for (var hotWord in hotKeyList) {
      Widget item = InkWell(
          onTap: () {
            _goToSearchResultPage(hotWord);
          },
          child: Container(
            constraints: BoxConstraints(minHeight: 30),
            padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: CommonUtils.getRandomColor(),
            ),
            child: Text(
              hotWord,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ));
      items.add(item);
    }
    return items;
  }

  Widget _buildHistoryItem(String name) {
    return InkWell(
      onTap: () {
        _goToSearchResultPage(name);
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.history,
              color: appTheme.themeColor,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  name,
                  textAlign: TextAlign.start,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(context),
          Expanded(
            flex: 1,
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                //ListView控件有默认padding，默认为mediaQuery.padding
                itemCount: searchHistory.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "热门搜索",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          hotKeyList.length > 0
                              ? Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: _buildWrapItem(),
                                )
                              : SizedBox(),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text("搜索记录",
                                      style: TextStyle(color: Colors.blue)),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("清空",
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                  onTap: () {
                                    clearHistory();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return _buildHistoryItem(searchHistory[index - 1]);
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0)),
              child: IconTextWidget(
                icon: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.white,
                ),
                text: TextField(
                    controller: controller,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    obscureText: false,
                    style: TextStyle(fontSize: 15, color: appTheme.themeColor),
                    decoration: InputDecoration(
                        hintText: "请输入搜索关键字",
                        contentPadding: EdgeInsets.all(6.0),
                        border: InputBorder.none)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 60,
              height: 30,
              child: RaisedButton(
                elevation: 0,
                highlightElevation: 0,
                color: appTheme.themeColor,
                child: Text(
                  "搜索",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  maxLines: 1,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  var key = controller.text.toString();
                  if (key.isEmpty) {
                    CommonUtils.toast("输入字段为空");
                    return;
                  }
                  _goToSearchResultPage(key);
                  controller.text = "";
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
