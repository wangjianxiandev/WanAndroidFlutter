import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanandroidflutter/widget/expand_button.dart';


class CommonUtils {
  //Dialog 封装
  static void showAlertDialog(BuildContext context,
      String contentText,{Function confirmCallback,
        Function dismissCallback,String confirmText = ""}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(contentText),
          actions: <Widget>[
            FlatButton(
              child: Text('我手滑了'),
              onPressed: () {
                if(dismissCallback!=null){
                  dismissCallback();
                }
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(confirmText == "" ? '注销':confirmText),
              onPressed: () {
                if(confirmCallback != null){
                  confirmCallback();
                }
                Navigator.of(context).pop();
              },
            )
          ],
          elevation: 20, //阴影
        );
      },
    );
  }

  //清除缓存
  static void clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    //清除图片缓存
    PaintingBinding.instance.imageCache.clear();
    //await loadCache();
    toast("清除缓存成功");
  }

  ///递归方式删除目录
  static Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
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
