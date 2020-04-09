import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/theme/theme_colors.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/utils/Config.dart';
import 'package:wanandroidflutter/utils/common.dart';

import '../webview_page.dart';

class SettingFragment extends StatefulWidget {
  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  Color beforeChangeColor;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    if (!Provider.of<DarkMode>(context).isDark) {
      saveBeforeChangeTheme(appTheme.themeColor);
    }
    getBeforeChangeColorIndex().then((index) {
      beforeChangeColor = Color(index);
      print("~beforeChangeColor" + beforeChangeColor.toString());
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        backgroundColor: appTheme.themeColor,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            clipBehavior: Clip.antiAlias,
            semanticContainer: false,
            child: ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text(
                "夜间模式",
                style: Theme.of(context).textTheme.title,
              ),
              trailing: Switch(
                  activeColor: appTheme.themeColor,
                  value: Provider.of<DarkMode>(context).isDark,
                  onChanged: (value) {
                    print("value = $value");
                    Provider.of<DarkMode>(context).setDark(value);
                    appTheme.updateThemeColor(
                        value ? Color(0xff323638) : beforeChangeColor);
                    saveDarkMode(value);
                  }),
            ),
          ),
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text(
                  "清除缓存",
                  style: Theme.of(context).textTheme.title,
                ),
                onTap: () {
                  CommonUtils.showAlertDialog(context, "确定清除缓存吗？",
                      confirmText: "确定", confirmCallback: () {
                    //清除缓存
                    CommonUtils.clearCache();
                  });
                },
              )),
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              child: ListTile(
                leading: Icon(Icons.send),
                title: Text(
                  "关于作者",
                  style: Theme.of(context).textTheme.title,
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return new WebViewPage(
                      url: "https://blog.csdn.net/qq_39424143",
                      title: "我的博客",
                      id: null,
                      isCollect: false,
                    );
                  }));
                },
              )),
        ],
      ),
    );
  }

  void saveDarkMode(bool value) async {
    print("dark  = $value");
    Application.sp.putBool(Config.SP_DARK_MODEL, value);
  }

  void saveBeforeChangeTheme(Color color) async {
    Application.sp.putInt(Config.SP_BEFORE_CHANGE_DARK_MODE, color.value);
  }

  getBeforeChangeColorIndex() async {
    int themeColorIndex = Application.sp.getInt(Config.SP_BEFORE_CHANGE_DARK_MODE) ?? 0;
    return themeColorIndex;
  }
}
