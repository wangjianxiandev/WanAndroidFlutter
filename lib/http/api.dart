class Api {
  static const String BASE_URL = "https://www.wanandroid.com/";

  //首页banner
  static const String BANNER_URL = "banner/json";

  //置顶文章
  static const String ARTICLE_TOP = "article/top/json";

  //首页文章
  static const String HOME_ARTICLE_LIST = "article/list/";

  //搜索热词
  static const String HOT_KEY = "hotkey/json";

  //搜索
  static const String SEARCH_RESULT_LIST = "article/query/";

  //收藏站内文章
  static const String COLLECT = "lg/collect/";

  //取消收藏-文章列表
  static const String UN_COLLECT_ORIGIN_ID = "lg/uncollect_originId/";

  //登录
  static const String LOGIN = "user/login";

  //退出登录
  static const String LOGIN_OUT_JSON = 'user/logout/json';

  //注册
  static const String REGISTER = "user/register";

  //获取公众号Tab
  static const String WECHAT_TAB = "wxarticle/chapters/json";

  //获取公众号文章
  static const String WECHAT_LIST = "wxarticle/list/";

  //获取项目分类
  static const String PROJECT_TAB = "project/tree/json";

  //获取项目列表数据
  static const String PROJECT_LIST = "project/list/";

  //获取体系数据
  static const String TREE = "tree/json";

  //获取导航数据
  static const String NAVIGATION = "navi/json";

  //获取用户积分数据
  static const String COIN_INFO = "lg/coin/userinfo/json";

  //获取收藏文章列表
  static const String COLLECT_LIST = "lg/collect/list/";

  //取消收藏
  static const String UN_COLLECT = "lg/uncollect/";

  //添加站外收藏
  static const String ADD_COLLECT_ARTICLE = "lg/collect/add/json";

  //获取广场数据
  static const String SQUARE_LIST = "user_article/list/";

  //获取积分列表
  static const String RANK_LIST = "coin/rank/";

  //获取问答列表
  static const String WENDA_LIST = "wenda/list/";

  //分享文章
  static const String SHARE_ARTICLE = "lg/user_article/add/json";

  //分享文章列表
  static const String SHARE_ARTICLE_LIST = "user/lg/private_articles/";
}
