import 'package:flutter/material.dart';
import 'package:wanandroidflutter/data/rank.dart';

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
    rankData = widget.rankData;
    return Card(
        elevation: 15.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: buildIcon(rankData),
                      ),
                      Text((rankData.username),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                          maxLines: 1, // title 只显示一行
                          overflow: TextOverflow.ellipsis //超出一行 显示 ...
                          ),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(("  积分：" + rankData.coinCount.toString()),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                        maxLines: 1, // title 只显示一行
                        overflow: TextOverflow.ellipsis //超出一行 显示 ...
                        )),
              ],
            )));
  }

  Widget buildIcon(RankData rankData) {
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
