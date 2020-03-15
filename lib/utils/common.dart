import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroidflutter/widget/expand_button.dart';
import 'const.dart';


class CommonUtils {
  //加载弹窗
  static Future showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => Future.value(false),
                child: Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: SpinKitCubeGrid(
                            color: Colors.white,
                          ),
                        ),
                        Container(height: 10.0),
                        Container(
                            child: Text(
                          "加载中...",
                          style: TextStyle(color: Colors.white),
                        )),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  //普通弹窗
  static Future<Null> showCommitOptionDialog(
    BuildContext context,
    String title,
    String content,
    List<String> commitMaps,
    ValueChanged<int> onTap, {
    width = 0,
    height = 200.0,
    List<Color> bgColorList, //按钮背景
    List<Color> colorList, //按钮文字颜色
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: width == 0
                    ? MediaQuery.of(context).size.width * 3 / 4
                    : width,
                height: height,
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        title ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(content,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0)),
                      )),
                    ),
                    Row(
                      children: commitMaps.map((str) {
                        var index = commitMaps.indexOf(str);
                        return ExpandButton(
                          maxLines: 1,
                          mainAxisAlignment: MainAxisAlignment.start,
                          fontSize: 14.0,
                          color: bgColorList.length > 0
                              ? bgColorList[index]
                              : Theme.of(context).primaryColor,
                          text: str,
                          textColor: colorList != null
                              ? colorList[index]
                              : Colors.white,
                          onPress: () {
                            Navigator.pop(context);
                            onTap(index);
                          },
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future push(BuildContext context, Widget widget) {
    Future result = Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
    return result;
  }

  static Future pushIOS(BuildContext context, Widget widget) {
    Future result = Navigator.push(
        context, CupertinoPageRoute(builder: (context) => widget));
    return result;
  }

  static toast(String msg) {
    Fluttertoast.showToast(msg: msg, fontSize: 14);
  }

  static Color getRandomColor() {
    Random random = Random();
    var temp = random.nextInt(6);
    List<Color> colors = [
      Colors.blueAccent,
      Colors.grey ,
      Colors.redAccent,
      Colors.purpleAccent,
      Colors.lightGreen,
      Colors.deepOrangeAccent,
    ];
    return colors[temp];
  }
}
