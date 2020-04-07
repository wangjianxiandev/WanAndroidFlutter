import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class FavouriteAnimation extends StatefulWidget {
  // hero动画唯一标识
  final Object tag;

  final bool isAdded;

  const FavouriteAnimation({Key key, this.tag, this.isAdded}) : super(key: key);

  @override
  _FavouriteAnimationState createState() => _FavouriteAnimationState();
}

class _FavouriteAnimationState extends State<FavouriteAnimation> {
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // addPostFrameCallback 是 StatefulWidge 渲染结束的回调，只会被调用一次，
    // 之后 StatefulWidget 需要刷新 UI 也不会被调用，addPostFrameCallback 的使用方法是在 initState 里添加回调
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isPlaying = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: FlareActor(
        "assets/flrs/like.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: widget.isAdded ? 'like' : 'unLike',
        shouldClip: false,
        isPaused: !isPlaying,
        callback: (name) {
          Navigator.pop(context);
          isPlaying = false;
        },
      ),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  HeroDialogRoute({this.builder}) : super();

  @override
  Color get barrierColor => Colors.black12;

  @override
  String get barrierLabel => null;

  // barrierDismissible若为false，点击对话框周围，对话框不会关闭；若为true，点击对话框周围，对话框自动关闭
  @override
  bool get barrierDismissible => true;

  // 是否透明
  @override
  bool get opaque => false;

  //  创建转场动画
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  bool get maintainState => true;

  // 转场动画持续时间
  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);
}
