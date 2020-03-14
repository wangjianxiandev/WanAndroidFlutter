import 'dart:async';

import 'package:flutter/material.dart';

//跑马灯效果  参考 https://github.com/baoolong/MarqueeWidget/blob/master/lib/marquee_flutter.dart
class MarqueeWidget extends StatefulWidget {
  var width = 200.0;
  var height = 20.0;
  TextStyle style;
  String text;

  MarqueeWidget({this.width, this.height, @required this.text, style})
      : style = style == null ? TextStyle(fontSize: 16) : style;

  @override
  State<StatefulWidget> createState() {
    return _MarqueeWidgetState();
  }
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  var _controller = ScrollController();
  double position = 0.0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    if (getCenterWidgetWidth() > widget.width) {
      timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        double pixels = _controller.position.pixels;
        double maxScrollExtent = _controller.position.maxScrollExtent;
        if (pixels + 3.0 >= maxScrollExtent) {
          position = 0;
          _controller.jumpTo(position);
        }
        position += 3.0;
        _controller.animateTo(position,
            duration: new Duration(milliseconds: 90), curve: Curves.linear);
      });
    }
  }

  Widget getStartEndWidget() {
    return Container(
      width: widget.width,
    );
  }

  Widget getCenterWidget() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        widget.text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: widget.style,
      ),
    );
  }

  double getCenterWidgetWidth() {
    return widget.text.length * widget.style.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: getCenterWidgetWidth() > widget.width
          ? ListView(
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: <Widget>[
                getStartEndWidget(),
                getCenterWidget(),
                getStartEndWidget(),
              ],
            )
          : Text(
              widget.text,
              maxLines: 1,
              style: widget.style,
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }
}
