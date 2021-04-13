import 'dart:ui';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';

class QDColors {
  /// 白色
  static var whiteColor = CupertinoColors.white;

  /// 主题色 105 201 121
  static var themeColor = Color.fromRGBO(105, 201, 121, 1);

  /// 某个版本更换的主题色 47 189 75
  static var newThemeColor = Color.fromRGBO(47, 189, 75, 1);

  /// 默认渐变色的左色调 59 204 88
  static var defaultThemeLeadingColor = Color.fromRGBO(59, 204, 88, 1);

  /// 默认渐变色的右色调 35, 184, 65
  static var defaultThemeTralingColor = Color.fromRGBO(35, 184, 65, 1);

  /// 用于展示的橘色 252, 139, 0,
  static var orangeColor = Color.fromRGBO(252, 139, 0, 1);

  /// 浅橘色 253, 244, 234
  static var ligjtOrangeColor = Color.fromRGBO(253, 244, 234, 1);

  /// 边距的颜色 204
  static var borderGrayColor = 204.qdColor();

  /// 导航栏出返回按钮的默认颜色 76, 77, 76
  static var backArrowDefaultColor = Color.fromRGBO(76, 77, 76, 1);

  /// 项目中默认的黑色 89, 88, 89
  static var blackColor = Color.fromRGBO(89, 88, 89, 1);

  /// 项目中的灰色 153
  static var grayColor = 153.qdColor();

  /// 主页的背景色 247
  static var mainPageBackgroundColor = 247.qdColor();

  /// 分割线 230
  static var separateColor = 230.qdColor();

  /// 青岛地铁线路未选中的颜色
  static List<Color> metroLineUnselectedGradientColors() {
    return [255.qdColor(), 240.qdColor()];
  }
}

class QDGlobal {
  /// 时间日期格式转化
  static String transDateToString(int timeDuration,
      {List<String> format: const ['mm', "-", "dd"]}) {
    return formatDate(
        DateTime.fromMillisecondsSinceEpoch(timeDuration), format);
  }
}

/// 给青岛地铁追加配色
extension QDMetroColor on String {
  /// 青岛地铁线路的单色
  Color metroLineColor() {
    switch (this) {
      case "3":
        return Color.fromRGBO(97, 181, 246, 1);
      case "2":
        return Color.fromRGBO(230, 115, 62, 1);
      case "11":
        return Color.fromRGBO(93, 120, 216, 1);
      case "13":
        return Color.fromRGBO(94, 204, 186, 1);
      case "8":
        return Color.fromRGBO(247, 111, 191, 1);
      case "1":
        return Color.fromRGBO(252, 181, 58, 1);
      default:
        return QDColors.themeColor;
    }
  }

  /// 青岛地铁线路的渐变色
  List<Color> metroLineGradientColors() {
    switch (this) {
      case "3":
        return [
          Color.fromRGBO(102, 186, 250, 1),
          Color.fromRGBO(90, 176, 242, 1)
        ];
      case "2":
        return [
          Color.fromRGBO(235, 126, 58, 1),
          Color.fromRGBO(224, 103, 56, 1)
        ];
      case "11":
        return [
          Color.fromRGBO(103, 129, 224, 1),
          Color.fromRGBO(84, 111, 209, 1)
        ];
      case "13":
        return [
          Color.fromRGBO(103, 207, 189, 1),
          Color.fromRGBO(84, 201, 182, 1)
        ];
      case "8":
        return [
          Color.fromRGBO(84, 201, 182, 1),
          Color.fromRGBO(247, 111, 191, 1)
        ];
      case "1":
        return [
          Color.fromRGBO(255, 198, 84, 1),
          Color.fromRGBO(252, 181, 58, 1)
        ];
      default:
        return [
          Global.defaultThemeLeadingColor,
          Global.defaultThemeTralingColor
        ];
    }
  }
}

extension QDColors on int {
  /// color
  Color qdColor({double opacity: 1}) {
    if (this < 0 || this > 255) {
      return CupertinoColors.white;
    }

    return Color.fromRGBO(this, this, this, opacity);
    // switch (this) {
    //   case 0...255:
    //   default: return CupertinoColors.white;
    // }
  }
}

extension StringTransDouble on String {
  double toDouble() {
    return double.parse(this);
  }
}

extension QDAssetImage on String {
  /// 根据字符串自身的内容，返回ImageProvider
  ImageProvider<Object> qdImage({String path: "images/", bool isPNG: true}) {
    return AssetImage("$path${this}.${isPNG ? 'png' : 'jpg'}");
  }

  /// 根据字符串内容，返回Image.asset
  Widget qdImageAsset({String path: "images/", bool isPNG: true}) {
    return Image.asset("$path${this}.${isPNG ? 'png' : 'jpg'}");
  }
}
