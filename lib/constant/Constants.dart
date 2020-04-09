import 'package:wanandroidflutter/page/input/page.dart';

class Constants {
  /// 网络错误
  static const NETWORK_ERROR = -1;

  /// 网络超时
  static const NETWORK_TIMEOUT = -2;

  /// 返回数据格式化
  static const NETWORK_JSON_EXCEPTION = -3;

  /// 成功
  static const SUCCESS = 200;

  //主题颜色
  static const String THEME_COLOR_KEY = 'theme_color_key';

  //是否为夜间模式
  static const String THEME_DARK_MODE_KEY = 'theme_dark_mode_key';


  static final List<Page> todoTypes = [
    Page('只用这一个', 0),
    Page('工作', 1),
    Page('学习', 2),
    Page('生活', 3)
  ];
}
