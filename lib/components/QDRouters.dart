import 'package:flutter/cupertino.dart';

//路由的界面
import '../routes/QDNewsPage.dart';
import '../routes/QDWebViewPage.dart';

class QDRouters {
  /// 全局配置的路由
  static Map<String, WidgetBuilder> routes() {
    return {
      '/web': (BuildContext context) => QDWebViewPage(),
      '/newsIndex': (BuildContext context) => QDNewsPage(),
    };
  }
}
