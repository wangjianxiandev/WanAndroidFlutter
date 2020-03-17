import 'package:flutter/material.dart';

import 'marquee_widget.dart';

class TitleBar extends StatefulWidget implements PreferredSizeWidget {
  Widget leftButton;
  String title = "";
  bool isShowBack = true;

  TitleBar({this.leftButton, this.isShowBack, this.title});

  @override
  _TitleBarState createState() => _TitleBarState();

  static Widget textButton(
    String text, {
    Color color = Colors.white,
    Function() press,
  }) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.all(5),
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
      onTap: press,
    );
  }

  static Widget iconButton(
      {IconData icon, Color color = Colors.white, Function() press}) {
    return IconButton(
        padding: EdgeInsets.all(2),
        icon: Icon(
          icon,
          color: color,
        ),
        onPressed: press);
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blueAccent, Colors.blue])),
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: !widget.isShowBack,
            child: Container(
              alignment: Alignment.centerLeft,
              child: widget.leftButton == null
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : widget.leftButton,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: MarqueeWidget(
                text: widget.title,
                height: 56,
                width: MediaQuery.of(context).size.width - 90,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
