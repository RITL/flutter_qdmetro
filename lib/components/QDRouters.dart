import 'package:flutter/cupertino.dart';

//路由的界面
import '../routes/QDNewsView.dart';
import '../routes/QDWebView.dart';

enum QDRouterPlatform {
  newsIndex,
  //  web(),
}

class QDRouters {
  /// 全局配置的路由
  static Map<String, WidgetBuilder> routes() {
    return {
      '/web': (BuildContext context) => QDWebView(),
      '/newsIndex': (BuildContext context) => QDNewsView(),
    };
  }
}

// /// 定义全局路由
// extension QDRouters {

// }
