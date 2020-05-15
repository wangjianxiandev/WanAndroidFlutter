import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/data/article.dart';
import 'package:wanandroidflutter/data/hot_key.dart';
import 'package:wanandroidflutter/generated/l10n.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/home/search_result_fragment.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
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

  void clearHistoryByContent(String deleteText) async {
    String longHistory =
        await Application.sp.getString(Config.SP_SEARCH_HISTORY);
    var tempHistory = longHistory.split(",");
    if (tempHistory.length > 0) {
      for (var i = 0; i < tempHistory.length; i++) {
        if (deleteText == tempHistory[i]) {
          setState(() {
            searchHistory.removeAt(i);
          });
          break;
        }
      }
      String result = "";
      for (var i = 0; i < tempHistory.length; i++) {
        result += tempHistory[i];
        if (i + 1 != tempHistory.length) {
          result += ",";
        }
      }
      Application.sp.putString(Config.SP_SEARCH_HISTORY, result);
    }
  }

  void clearHistory() async {
    await Application.sp.remove(Config.SP_SEARCH_HISTORY);
    setState(() {
      searchHistory.clear();
    });
  }

  _goToSearchResultPage(String name) async {
    addSearchHistory(name);
    CommonUtils.push(
        context,
        Scaffold(
          appBar: AppBar(
            title: Text(name),
            backgroundColor: appTheme.themeColor,
            centerTitle: true,
          ),
          body: SearchResultFragment(name),
        ));
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.history,
                  color: Theme.of(context).iconTheme.color.withAlpha(120),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    name,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () {
                  clearHistoryByContent(name);
                },
                child: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).iconTheme.color.withAlpha(120),
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
    appTheme = Provider.of<ThemeModel>(context);
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
                              S.of(context).hot_search,
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
                                  child: Text(S.of(context).search_history,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(S.of(context).clear_history,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
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
      color: Theme.of(context).iconTheme.color.withAlpha(0),
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
                        hintText: S.of(context).input_search,
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
                  S.of(context).search,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  maxLines: 1,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  var key = controller.text.toString();
                  if (key.isEmpty) {
                    CommonUtils.toast(S.of(context).search_tip);
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
