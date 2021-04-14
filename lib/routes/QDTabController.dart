import 'package:flutter/cupertino.dart';
import '../common/QDGlobal.dart';

/// 子界面
import 'QDMainIndexView.dart';
import 'QDNewsIndexView.dart';
import 'QDMineIndexView.dart';
import 'QDMapIndexView.dart';

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
            {"title": "主页", "icon_url": "tab_home"},
            {"title": "出行", "icon_url": "tab_station"},
            {"title": "资讯", "icon_url": "tab_home"},
            {"title": "我的", "icon_url": "tab_mine"}
          ]
              .map((e) => BottomNavigationBarItem(
                    icon: Image(
                      image: e["icon_url"]?.qdImage(),
                    ),
                    activeIcon: Image(
                      image: "${e["icon_url"]}_selected".qdImage(),
                    ),
                    label: e["title"],
                  ))
              .toList(),
        ),
        // ignore: missing_return
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return QDMainIndexView();
            case 1:
              return QDMapIndexView();
            case 2:
              return QDNewsIndexView();
            case 3:
              return QDMineIndexView();
              return Container();
          }
        });
  }
}
