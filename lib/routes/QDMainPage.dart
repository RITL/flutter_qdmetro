import 'package:flutter/cupertino.dart';

class QDMainPage extends StatefulWidget {
  QDMainPage({Key key, this.title}) : super(key: key);

  String title;
  @override
  _QDMainPageState createState() => _QDMainPageState();
}

class _QDMainPageState extends State<QDMainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("主页"),
      ),
      child: Center(
        child: Text('我是青岛地铁Flutter'),
      ),
    );

    // Scaffold(
    //   appBar: AppBar(title: Text(widget.title), elevation: 0),
    //   body: Center(
    //     child: Text("我是青岛地铁Flutter"),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.pushNamed(context, "/newsIndex");
    //     },
    //     child: Text("进入资讯", textAlign: TextAlign.center),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}
