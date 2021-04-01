import 'dart:ui';
import 'package:date_format/date_format.dart';

class Global {
  /// 导航栏出返回按钮的默认颜色
  static var backArrowDefaultColor = Color.fromRGBO(76, 77, 76, 1);

  /// 项目中默认的黑色
  static var blackColor = Color.fromRGBO(89, 88, 89, 1);

  /// 项目中的灰色
  static var grayColor = Color.fromRGBO(153, 153, 153, 1);

  /// 主页的背景色
  static var mainPageBackgroundColor = Color.fromRGBO(247, 247, 247, 1);

  /// 时间日期格式转化
  static String transDateToString(int timeDuration,
      {List<String> format: const ['mm', "-", "dd"]}) {
    // return "${timeDuration}";
    // return formatDate(DateTime.now(),[])
    return formatDate(
        DateTime.fromMillisecondsSinceEpoch(timeDuration), format);
  }
}
