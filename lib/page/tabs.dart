import 'package:flutter/material.dart';
import 'package:wanandroidflutter/page/home_fragment.dart';
import 'package:wanandroidflutter/page/projectf_ragment.dart';
import 'package:wanandroidflutter/page/system_fragment.dart';
import 'package:wanandroidflutter/page/wechat_fragment.dart';

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

  List _pageList = [HomeFragment(), SystemFragment(), WeChatFragment(), ProjectFragment()];

  List _titleList = ["首页", " 体系", "公众号", "项目"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleList[_currentIndex]),
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.category), title: Text("项目"))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: UserAccountsDrawerHeader(
                      accountName:Text("wjxbless"),
                      accountEmail: Text("xxx@qq.com"),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage("https://profile.csdnimg.cn/B/0/A/1_qq_39424143"),
                      ),
                      decoration:BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("http://pic2.sc.chinaz.com/Files/pic/pic9/202002/zzpic23269_s.jpg"),
                            fit:BoxFit.cover,
                          )

                      ),
                    )
                )
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                  child: Icon(Icons.home)
              ),
              title: Text("我的空间"),

            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                  child: Icon(Icons.people)
              ),
              title: Text("用户中心"),
              onTap: (){
                Navigator.of(context).pop();  // 点击后收起抽屉
                Navigator.pushNamed(context, '/user');
              },
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                  child: Icon(Icons.settings)
              ),
              title: Text("设置中心"),
            ),
            Divider(),
          ],
        ),


      ),
    );
  }
}
