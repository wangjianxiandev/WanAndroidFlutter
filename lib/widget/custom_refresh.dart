import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroidflutter/generated/l10n.dart';

///自定义刷新控件头部尾部
class CustomRefresh extends StatefulWidget {
  Widget child;
  GlobalKey<EasyRefreshState> easyRefreshKey;

  Function onRefresh;
  Function loadMore;

  CustomRefresh({
    @required this.child,
    this.onRefresh,
    this.loadMore,
    @required this.easyRefreshKey,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomRefreshState();
  }
}

class _CustomRefreshState extends State<CustomRefresh> {
  GlobalKey<RefreshHeaderState> headerKey;
  GlobalKey<RefreshFooterState> footerKey;

  @override
  void initState() {
    super.initState();
    headerKey = new GlobalKey<RefreshHeaderState>();

    footerKey = new GlobalKey<RefreshFooterState>();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      key: widget.easyRefreshKey,
      autoLoad: false,
      onRefresh: widget.onRefresh,
      loadMore: widget.loadMore,
      behavior: ScrollOverBehavior(),
      refreshHeader: ClassicsHeader(
        key: headerKey,
        refreshText: S.of(context).down_refresh,
        refreshReadyText:  S.of(context).release_refresh,
        refreshingText: S.of(context).refreshing,
        refreshedText:  S.of(context).complete_refresh,
        moreInfo: S.of(context).update_time + "%T",
        bgColor: Colors.transparent,
        textColor: Colors.black87,
        moreInfoColor: Colors.black54,
        isFloat: false,
        showMore: true,
      ),
      refreshFooter: ClassicsFooter(
        key: footerKey,
        loadText: S.of(context).up_refresh,
        loadReadyText: S.of(context).release_refresh,
        loadingText: S.of(context).refreshing,
        loadedText: S.of(context).complete_refresh,
        noMoreText: S.of(context).complete_refresh,
        moreInfo: S.of(context).update_time + "%T",
        bgColor: Colors.transparent,
        textColor: Colors.black87,
        moreInfoColor: Colors.black54,
        isFloat: false,
        showMore: true,
      ),
      child: widget.child,
    );
  }
}
