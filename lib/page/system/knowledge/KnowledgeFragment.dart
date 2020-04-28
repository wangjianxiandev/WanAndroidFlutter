import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/knowledge.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/http_request.dart';
import 'package:wanandroidflutter/page/system/knowledge/KnowledgeListFragment.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/utils/common.dart';
import 'package:wanandroidflutter/widget/load_fail_widget.dart';

class KnowledgeFragment extends StatefulWidget {
  @override
  _KnowledgeFragmentState createState() => _KnowledgeFragmentState();
}

class _KnowledgeFragmentState extends State<KnowledgeFragment> {
  List<KnowledgeData> knowLedgeList = [];
  var appTheme;
  bool isNetWorkError = false;

  @override
  void initState() {
    super.initState();
    loadKnowledgeList();
  }

  void loadKnowledgeList() async {
    HttpRequest.getInstance().get(Api.TREE, successCallBack: (data) {
      if (data != null) {
        List responseJson = json.decode(data);
        setState(() {
          isNetWorkError = false;
          knowLedgeList.addAll(
              responseJson.map((m) => KnowledgeData.fromJson(m)).toList());
        });
      } else {
        setState(() {
          isNetWorkError = true;
        });
      }
    }, errorCallBack: (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    appTheme = Provider.of<ThemeModel>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).iconTheme.color.withAlpha(0),
      ),
      child: isNetWorkError
          ? Scaffold(
            body: LoadFailWidget(
                onTap: () {
                  loadKnowledgeList();
                },
              ),
          )
          : Scrollbar(
              child: ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: knowLedgeList.length,
                  itemBuilder: (context, index) {
                    return KnowledgeCategoryWidget(
                      knowledgeData: knowLedgeList[index],
                    );
                  }),
            ),
    );
  }
}

class KnowledgeCategoryWidget extends StatelessWidget {
  final KnowledgeData knowledgeData;

  KnowledgeCategoryWidget({Key key, this.knowledgeData});

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            knowledgeData.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
          Wrap(
            spacing: 10,
            children: List.generate(
                knowledgeData.children.length,
                (index) => ActionChip(
                      onPressed: () {
                        CommonUtils.push(
                            context,
                            Scaffold(
                              appBar: AppBar(
                                title: Text(knowledgeData.children[index].name
                                    .toString()),
                                backgroundColor: appTheme.themeColor,
                                centerTitle: true,
                              ),
                              body: KnowledgeListFragment(
                                  knowledgeData.children[index].id),
                            ));
                      },
                      backgroundColor:
                          Theme.of(context).iconTheme.color.withAlpha(20),
                      label: Text(
                        knowledgeData.children[index].name,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 13, color: CommonUtils.getRandomColor()),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
