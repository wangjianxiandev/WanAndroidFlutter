import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/constant/Constants.dart';
import 'package:wanandroidflutter/theme/font_model.dart';
import 'package:wanandroidflutter/theme/theme_colors.dart';
import 'package:wanandroidflutter/page/tabs.dart';
import 'package:wanandroidflutter/routes/routes.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';
import 'package:wanandroidflutter/utils/Config.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    queryThemeColor().then((index) {
      Provider.of<ThemeModel>(context).updateThemeColor(getThemeColors()[index]);
    });
    queryDark().then((value) {
      Provider.of<DarkMode>(context).setDark(value);
      if (value) {
        Provider.of<ThemeModel>(context).updateThemeColor(Color(0xff323638));
      }
    });
    queryFontIndex().then((index) {
      Provider.of<FontModel>(context).updateFontIndex(index);
    });
  }

  queryThemeColor() async {
    int themeColorIndex = Application.sp.getInt(Config.SP_THEME_COLOR) ?? 0;
    return themeColorIndex;
  }

  /// 查询暗黑模式
  queryDark() async {
    bool isDark = Application.sp.getBool(Config.SP_DARK_MODEL) ?? false;
    return isDark;
  }

  /// 查询字体模式
  queryFontIndex() async {
    int fontIndex = Application.sp.getInt(Config.SP_FONT_INDEX) ?? 0;
    return fontIndex;
  }


  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    var darkMode = Provider.of<DarkMode>(context);
    var fontMode = Provider.of<FontModel>(context);
    return MaterialApp(
      theme: getTheme(appTheme.themeColor, isDarkMode: darkMode.isDark, fontIndex: fontMode.fontIndex),
      home: Tabs(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }

  getTheme(Color themeColor, {bool isDarkMode = false, int fontIndex = 0}) {
    return ThemeData(
      fontFamily: Constants.FontList[fontIndex],
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}
