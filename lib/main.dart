import 'package:flutter/cupertino.dart';
import 'components/QDRouters.dart';
import 'common/Global.dart';
import 'routes/QDTabController.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///主题
    // var themeData = ThemeData(
    //     //导航背景色
    //     primaryColor: Colors.white,
    //     //暗黑或者明亮模式
    //     brightness: Brightness.light,
    //     //下侧的按钮背景色
    //     accentColor: Colors.green[600],
    //     //下侧的按钮的阴影
    //     shadowColor: Colors.yellow);

    var themeData = CupertinoThemeData(
      primaryColor: Global.blackColor,
      brightness: Brightness.light,
    );

    return CupertinoApp(
      title: '青岛地铁 Flutter',
      routes: QDRouters.routes(),
      theme: themeData,
      home: QDTabController(),
    );
  }
}
