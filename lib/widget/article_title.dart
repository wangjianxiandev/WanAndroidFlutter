import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleTitleWidget extends StatelessWidget {
  final String title;

  ArticleTitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Html(
      padding: EdgeInsets.symmetric(vertical: 5),
      data: title,
      defaultTextStyle: Theme.of(context).textTheme.subtitle,
    );
  }
}
