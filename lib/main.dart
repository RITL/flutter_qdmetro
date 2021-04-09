import 'package:flutter/cupertino.dart';
import 'components/QDRouters.dart';
import 'common/Global.dart';
import 'routes/QDTabController.dart';
import 'common/QDLocationManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoThemeData(
      primaryColor: Global.blackColor,
      brightness: Brightness.light,
    );

    //注册高德地图
    QDLocationManager.initAMap();

    return CupertinoApp(
      title: '青岛地铁 Flutter',
      routes: QDRouters.routes(),
      theme: themeData,
      home: QDTabController(),
    );
  }
}
