import 'package:flutter/material.dart';
import 'routes/NewsPage.dart';
import 'common/Global.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// 配置路由
    Map<String, WidgetBuilder> routes = {
      '/newsIndex': (BuildContext context) => NewsPage()
    };

    ///主题
    var themeData = ThemeData(
        //导航背景色
        primaryColor: Colors.white,
        //暗黑或者明亮模式
        brightness: Brightness.light,
        //下侧的按钮背景色
        accentColor: Colors.green[600],
        //下侧的按钮的阴影
        shadowColor: Colors.yellow);

    return MaterialApp(
      title: 'Flutter Demo',
      routes: routes,
      theme: themeData,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), elevation: 0),
      body: Center(
        child: Text("111"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/newsIndex");
        },
        child: Text("进入资讯", textAlign: TextAlign.center),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
