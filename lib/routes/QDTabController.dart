import 'package:flutter/cupertino.dart';

/// 子界面
import "QDMainPage.dart";
import "QDNewsPage.dart";

/// tabBarController
class QDTabController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QDTabControllerState();
  }
}

class _QDTabControllerState extends State<QDTabController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: Color.fromRGBO(100, 181, 116, 1),
          inactiveColor: Color.fromRGBO(109, 109, 109, 1),
          items: [
            {"title": "主页", "icon_url": "images/tab_home"},
            {"title": "出行", "icon_url": "images/tab_station"},
            {"title": "资讯", "icon_url": "images/tab_home"},
            {"title": "我的", "icon_url": "images/tab_mine"}
          ]
              .map((e) => BottomNavigationBarItem(
                    icon: Image(
                      image: AssetImage(e["icon_url"] + ".png"),
                    ),
                    activeIcon: Image(
                      image: AssetImage("${e["icon_url"]}_selected.png"),
                    ),
                    label: e["title"],
                  ))
              .toList(),
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return QDMainPage();
            case 2:
              return QDNewsPage();
              return Container();
          }
        });
  }
}
