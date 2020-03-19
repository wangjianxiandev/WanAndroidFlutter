import 'package:flutter/material.dart';

class IconTextWidget extends StatelessWidget {
  Widget icon;
  Widget text;
  double padding;

  IconTextWidget({@required this.icon, @required this.text, this.padding=0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: padding),
            child: icon,
          ),
          Expanded(
            flex: 1,
            child: text,
          ),
        ],
      ),
    );
  }
}
