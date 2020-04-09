import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/application.dart';
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


  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    var darkMode = Provider.of<DarkMode>(context);
    return MaterialApp(
      theme: getTheme(appTheme.themeColor, isDarkMode: darkMode.isDark),
      home: Tabs(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }

  getTheme(Color themeColor, {bool isDarkMode = false}) {
    return ThemeData(
      fontFamily: 'kuaile',
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}
