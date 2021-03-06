import 'package:flutter/cupertino.dart';
import '../common/QDGlobal.dart';

/// 用于个人中心的行
class QDTitleRow extends StatelessWidget {
  /// 初始化方法
  QDTitleRow(
      {Key key,
      this.imageName,
      this.title = "",
      this.subtitle = "",
      this.hasDivider = false})
      : super(key: key);

  final String imageName;
  final String title;
  final String subtitle;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: QDColors.whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    // Image(image: AssetImage(), width: 24, height: 24,),
                    Image(
                      image: imageName.qdImage(),
                      width: 24,
                      height: 24,
                      // decoration:
                      //     BoxDecoration(color: CupertinoColors.activeGreen),
                    ),
                    SizedBox(width: 8),
                    Text(
                      title ?? "",
                      style: TextStyle(
                          color: QDColors.blackColor,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      subtitle ?? "",
                      style: TextStyle(
                        color: QDColors.grayColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                    Image(
                      image: "uc_arrow_right".qdImage(),
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: (hasDivider ?? false) ? 0.5 : 0.0,
          child: Container(
            margin: EdgeInsets.only(left: 45, right: 20),
            decoration: BoxDecoration(
              color: 230.qdColor(),
            ),
          ),
        ),
      ],
    );
  }
}
