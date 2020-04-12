import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/constant/Constants.dart';
import 'package:wanandroidflutter/theme/font_model.dart';
import 'package:wanandroidflutter/theme/locale_model.dart';
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
    bool isDarkMode = Provider.of<DarkMode>(context).isDark;
    if (!isDarkMode) {
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
              leading: Icon(!isDarkMode ? Icons.brightness_6 : Icons.brightness_2,
              color: !isDarkMode ? Color(0xFFFFC400) : Colors.yellow,),
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
            child: ExpansionTile(
              leading: Icon(
                Icons.font_download,
                color: appTheme.themeColor,
              ),
              title: Text(
                "切换字体",
                style: Theme.of(context).textTheme.title,
              ),
              trailing: Icon(Icons.keyboard_arrow_down,
              color: appTheme.themeColor,),
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: Constants.FontList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        activeColor: appTheme.themeColor,
                        value: index,
                        onChanged: (index) {
                          print("index = $index");
                          Provider.of<FontModel>(context).updateFontIndex(index);
                          saveFontMode(index);
                        },
                        groupValue: Provider.of<FontModel>(context).fontIndex,
                        title: Text(index == 0? "正常字体" : "喵趣字体"),
                      );
                    })
              ],
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
              leading: Icon(
                Icons.public,
                color: appTheme.themeColor,
              ),
              title: Text(
                "语言设置",
                style: Theme.of(context).textTheme.title,
              ),
              trailing: Text("中文" ,style: Theme.of(context).textTheme.subtitle,),
//              children: <Widget>[
//                ListView.builder(
//                    shrinkWrap: true,
//                    itemCount: Constants.LocaleList.length,
//                    itemBuilder: (context, index) {
//                      return ListTile(
//                        activeColor: appTheme.themeColor,
//                        value: index,
//                        onChanged: (index) {
//                          print("index = $index");
//                          Provider.of<LocaleModel>(context).updateLocaleIndex(index);
//                        },
//                        groupValue: Provider.of<LocaleModel>(context).localeIndex,
//
//                      );
//                    })
//              ],
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
                leading: Icon(Icons.delete,
                color: appTheme.themeColor,),
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
                leading: Icon(Icons.send,
                color: appTheme.themeColor,),
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

  void saveFontMode(int index) async {
    print("fontIndex  = $index");
    Application.sp.putInt(Config.SP_FONT_INDEX, index);
  }

  void saveBeforeChangeTheme(Color color) async {
    Application.sp.putInt(Config.SP_BEFORE_CHANGE_DARK_MODE, color.value);
  }

  getBeforeChangeColorIndex() async {
    int themeColorIndex = Application.sp.getInt(Config.SP_BEFORE_CHANGE_DARK_MODE) ?? 0;
    return themeColorIndex;
  }
}
