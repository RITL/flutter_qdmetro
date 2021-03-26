import 'dart:ui';
import 'package:date_format/date_format.dart';

class Global {
  /// 导航栏出返回按钮的默认颜色
  static var BackArrowDefaultColor = Color.fromRGBO(76, 77, 76, 1);

  /// 项目中默认的黑色
  static var BlackColor = Color.fromRGBO(89, 88, 89, 1);

  /// 时间日期格式转化
  static String transDateToString(int timeDuration,
      {List<String> format: const ['mm', "-", "dd"]}) {
    // return "${timeDuration}";
    // return formatDate(DateTime.now(),[])
    return formatDate(
        DateTime.fromMillisecondsSinceEpoch(timeDuration), format);
  }
}
