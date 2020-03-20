import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidflutter/page/home/theme_colors.dart';
import 'package:wanandroidflutter/page/tabs.dart';
import 'package:wanandroidflutter/routes/routes.dart';
import 'package:wanandroidflutter/theme/app_theme.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/utils/Config.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryThemeColor().then((index) {
      Provider.of<AppTheme>(context).updateThemeColor(getThemeColors()[index]);
    });
    queryDark().then((value) {
      Provider.of<DarkMode>(context).setDark(value);
    });
  }

  queryThemeColor() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int themeColorIndex = sp.getInt(Config.SP_THEME_COLOR) ?? 0;
    return themeColorIndex;
  }

  /// 查询暗黑模式
  queryDark() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isDark = sp.getBool("dark") ?? false;
    return isDark;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Tabs(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
