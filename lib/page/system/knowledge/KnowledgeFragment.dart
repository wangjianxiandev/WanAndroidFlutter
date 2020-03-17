import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroidflutter/data/knowledge.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/system/knowledge/KnowledgeListFragment.dart';
import 'package:wanandroidflutter/utils/common.dart';

class KnowledgeFragment extends StatefulWidget {
  @override
  _KnowledgeFragmentState createState() => _KnowledgeFragmentState();
}

class _KnowledgeFragmentState extends State<KnowledgeFragment> {
  List<KnowledgeData> knowLedgeList = [];

  @override
  void initState() {
    super.initState();
    loadKnowledgeList();
  }

  void loadKnowledgeList() async {
    HttpRequest.getInstance().get(Api.TREE, successCallBack: (data) {
      List responseJson = json.decode(data);
      setState(() {
        knowLedgeList.addAll(
            responseJson.map((m) => KnowledgeData.fromJson(m)).toList());
      });
    }, errorCallBack: (code, msg) {});
  }

  List<Widget> getChild(KnowledgeData knowledgeData, int index,
      KnowledgeData childKnowledgeData) {
    List<Widget> childrenKnowList = [];
    if (childKnowledgeData.children.length > 0) {
      childrenKnowList.add(new Row(
        children: <Widget>[
          new Text(
            childKnowledgeData.name,
            style: TextStyle(fontSize: 15),
          )
        ],
      ));
      for (int i = 0; i < childKnowledgeData.children.length; i++) {
        childrenKnowList.addAll(
            getChild(childKnowledgeData, i, childKnowledgeData.children[i]));
      }
    } else {
      childrenKnowList.add(new InkWell(
        onTap: () => {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(knowledgeData.children[index].name.toString()),
                    centerTitle: true,
                  ),
                  body: KnowledgeListFragment(knowledgeData.children[index].id),
                );
              },
            ),
          )
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.transparent, width: 1),
              // 边色与边宽度
              color: Color(0xFFf5f5f5),
              borderRadius: new BorderRadius.circular(10), // 圆角度
            ),
            child: Text(
              childKnowledgeData.name,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 15, color: CommonUtils.getRandomColor()),
            )),
      ));
    }
    return childrenKnowList;
  }

  List<Widget> getChildren() {
    List<Widget> children = [];
    for (int i = 0; i < knowLedgeList.length; i++) {
      children.addAll(getChild(null, i, knowLedgeList[i]));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 10.0,
          runSpacing: 10.0,
          children: getChildren(),
        ),
      ),
    );
  }
}
