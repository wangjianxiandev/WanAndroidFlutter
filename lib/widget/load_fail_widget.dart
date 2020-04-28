import 'package:flutter/material.dart';
import 'package:wanandroidflutter/generated/l10n.dart';

//加载失败widget
class LoadFailWidget extends StatelessWidget {
  Function onTap;

  LoadFailWidget({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage("assets/img/load_fail.png"),
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).network_error,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
