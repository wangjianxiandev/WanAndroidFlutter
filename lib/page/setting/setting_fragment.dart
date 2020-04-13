import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/constant/Constants.dart';
import 'package:wanandroidflutter/generated/l10n.dart';
import 'package:wanandroidflutter/theme/font_model.dart';
import 'package:wanandroidflutter/theme/locale_model.dart';
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
        title: Text(S.of(context).setting),
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
                S.of(context).night_mode,
                style: Theme.of(context).textTheme.title,
              ),
              trailing: Switch(
                  activeColor: appTheme.themeColor,
                  value: Provider.of<DarkMode>(context).isDark,
                  onChanged: (value) {
                    print("value = $value");
                    Provider.of<DarkMode>(context).updateDarkMode(value);
                    appTheme.updateThemeColor(
                        value ? Color(0xff323638) : beforeChangeColor);
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
                S.of(context).switching_fonts,
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
                        },
                        groupValue: Provider.of<FontModel>(context).fontIndex,
                        title: Text(index == 0? S.of(context).normol_font : S.of(context).kuaile_font),
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
            child: ExpansionTile(
              leading: Icon(
                Icons.public,
                color: appTheme.themeColor,
              ),
              title: Text(
                S.of(context).language_setting,
                style: Theme.of(context).textTheme.title,
              ),
              trailing: Icon(Icons.keyboard_arrow_down,
                color: appTheme.themeColor,),
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: Constants.LocaleList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        activeColor: appTheme.themeColor,
                        value: index,
                        onChanged: (index) {
                          print("index = $index");
                          Provider.of<LocaleModel>(context).updateLocaleIndex(index);
                        },
                        groupValue: Provider.of<LocaleModel>(context).localeIndex,
                        title: Text(LocaleModel.localeName(index, context)),
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
                leading: Icon(Icons.delete,
                color: appTheme.themeColor,),
                title: Text(
                  S.of(context).clear_cache,
                  style: Theme.of(context).textTheme.title,
                ),
                onTap: () {
                  CommonUtils.showAlertDialog(context, S.of(context).clear_cache_tip, cancelText: S.of(context).cancel,
                      confirmText: S.of(context).confirm, confirmCallback: () {
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
                  S.of(context).about,
                  style: Theme.of(context).textTheme.title,
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return new WebViewPage(
                      url: "https://blog.csdn.net/qq_39424143",
                      title: S.of(context).my_blog,
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

  void saveBeforeChangeTheme(Color color) async {
    Application.sp.putInt(Config.SP_BEFORE_CHANGE_DARK_MODE, color.value);
  }

  getBeforeChangeColorIndex() async {
    int themeColorIndex = Application.sp.getInt(Config.SP_BEFORE_CHANGE_DARK_MODE) ?? 0;
    return themeColorIndex;
  }
}
