import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QDWebViewConfig {
  String url = "";
  String webTitle = "";
  QDWebViewConfig({this.url, this.webTitle: "详情"});
}

class QDWebViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QDWebViewPageState();
  }
}

class _QDWebViewPageState extends State<QDWebViewPage> {
  QDWebViewConfig url;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    //接收一下
    QDWebViewConfig _config = ModalRoute.of(context).settings.arguments;
    WebViewController _controller;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_config.webTitle),
      ),
      child: SafeArea(
        child: WebView(
          initialUrl: _config.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller = controller;
          },
          onPageFinished: (String url) {
            //获得title
            _controller.evaluateJavascript("document.title").then((value) {});
          },
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(_config.webTitle),
    //     elevation: 2,
    //     shadowColor: Colors.black12,
    //   ),
    //   body:
    // );
  }
}
