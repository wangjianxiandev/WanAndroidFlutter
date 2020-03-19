import 'package:flutter/material.dart';
import 'package:wanandroidflutter/page/drawer/draw_page.dart';
import 'package:wanandroidflutter/page/home/home_fragment.dart';
import 'package:wanandroidflutter/page/home/search_fragment.dart';
import 'package:wanandroidflutter/page/project/project_fragment.dart';
import 'package:wanandroidflutter/page/system/system_fragment.dart';
import 'package:wanandroidflutter/page/wechat/wechat_fragment.dart';

class Tabs extends StatefulWidget {
  final index;

  Tabs({Key key, this.index = 0}) : super(key: key);

  _TabsState createState() => _TabsState(this.index);
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;

  _TabsState(index) {
    this._currentIndex = index;
  }

  List _pageList = [
    HomeFragment(),
    SystemFragment(),
    WeChatFragment(),
    ProjectFragment()
  ];

  List _titleList = ["首页", " 体系", "公众号", "项目"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(
                title: Text(_titleList[_currentIndex]),
                backgroundColor: Colors.blue,
                actions: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(right: 10),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchFragment();
                          },
                        ),
                      );
                    },
                  )
                ],
              )
            : null,
        body: this._pageList[this._currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: this._currentIndex,
          //配置对应的索引值选中
          onTap: (int index) {
            setState(() {
              //改变状态
              this._currentIndex = index;
            });
          },
          fixedColor: Colors.blue,
          //选中的颜色
          type: BottomNavigationBarType.fixed,
          //配置底部tabs可以有多个按钮
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: Text("体系")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("公众号")),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: Text("项目"))
          ],
        ),
        drawer: Drawer(
          child: DrawerPage(),
        ));
  }
}
