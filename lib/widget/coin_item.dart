import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/data/rank.dart';
import 'package:wanandroidflutter/theme/dark_model.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';

class CoinRankWidget extends StatefulWidget {
  RankData rankData;

  CoinRankWidget(this.rankData);

  @override
  _CoinRankWidgetState createState() => _CoinRankWidgetState();
}

class _CoinRankWidgetState extends State<CoinRankWidget> {
  RankData rankData;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    var isDarkMode = Provider.of<DarkMode>(context).isDark;
    rankData = widget.rankData;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      onTap: () {},
      leading: buildIcon(rankData, !isDarkMode),
      title: Text(
        rankData == null ? "--" : (rankData.username),
        style: TextStyle(fontSize: 16),
      ),
      trailing: Text(
        rankData == null ? "--" : rankData.coinCount.toString(),
        style: TextStyle(color: appTheme.themeColor),
      ),
    );
  }

  Widget buildIcon(RankData rankData, bool isDarkMode) {
    if (rankData == null) {
      return Padding(
        padding: EdgeInsets.only(left: 8),
        child: Text(
          "--",
          style: TextStyle(
              color: !isDarkMode ? Colors.black : Colors.white.withAlpha(120), fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      );
    }
    if (rankData.rank == 1 || rankData.rank == 2 || rankData.rank == 3) {
      switch (rankData.rank) {
        case 1:
          return Icon(Icons.looks_one, color: Colors.yellow);
          break;
        case 2:
          return Icon(Icons.looks_two, color: Colors.blueGrey);
          break;
        case 3:
          return Icon(Icons.looks_3, color: Colors.orangeAccent);
          break;
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 8),
        child: Text(
          rankData.rank.toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}
