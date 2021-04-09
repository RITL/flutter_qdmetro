import 'package:flutter/cupertino.dart';

//路由的界面
import '../routes/QDNewsIndexView.dart';
import '../routes/QDWebView.dart';

class QDRouters {
  /// 全局配置的路由
  static Map<String, WidgetBuilder> routes() {
    return {
      '/web': (BuildContext context) => QDWebView(),
      '/newsIndex': (BuildContext context) => QDNewsIndexView(),
    };
  }
}

// /// 定义全局路由
// extension QDRouters {

// }
