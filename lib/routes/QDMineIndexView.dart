import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_qdmetro/common/QDGlobal.dart';
import '../components/QDTitleRow.dart';

class QDMineIndexView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QDMineIndexViewState();
}

class _QDMineIndexViewState extends State<QDMineIndexView> {
  //记录列表数据源
  var _titles = [
    ["支付管理", "乘车记录", "开具发票"],
    ["站内信", "帮助与客服"],
    ["我的收藏", "分享APP"]
  ];

  //记录列表数据的图片源
  var _imageNames = [
    ["uc_icon_zhifu", "uc_icon_jilu", "uc_icon_fapiao"],
    ["uc_icon_message", "uc_icon_kefu"],
    ["uc_icon_shoucang", "uc_icon_share"]
  ];

  //记录数据列表的副标题
  var _subtitles = [
    ["", "", ""],
    ["", ""],
    ["", ""]
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            color: 245.qdColor(),
          ),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _listViewHeaderView(),
                  childCount: 1,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _titles[index].length,
                      shrinkWrap: true,
                      // itemExtent: 52.5,
                      itemBuilder: (context, itemIndex) => Container(
                        height: _listViewBuildItemHeight(
                            itemIndex, _titles[index].length),
                        child: _listViewBuildItem(itemIndex, index),
                      ),
                    );
                  },
                  childCount: _titles.length,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  //MARK: 头部
  _listViewHeaderView() {
    //获得文本最大的宽度
    var maxWidth = MediaQuery.of(context).size.width - 48 - 65;
    return Container(
      height: 212 + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        // color: CupertinoColors.systemYellow,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: "uc_header_background".qdImage(),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /// 个人信息
          Container(
            padding: EdgeInsets.only(left: 24, right: 24),
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //头像以及实名认证
                Stack(
                  children: [
                    Container(
                      height: 64,
                      width: 60,
                      padding: EdgeInsets.only(bottom: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          height: 60,
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://api.qd-metro.com/file/201903/17/55cde52632c2d7817051c463826bcdea13231081a326de1450265b859747dc60.png",
                          // decoration: BoxDecoration(color: Global.grayColor),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: 47,
                            height: 16,
                            image: "uc_authenticated".qdImage(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //昵称
                Container(
                  constraints:
                      BoxConstraints(maxWidth: maxWidth, minWidth: 0.0),
                  margin: EdgeInsets.only(left: 5, top: 9),
                  // decoration: BoxDecoration(color: CupertinoColors.activeGreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "Yuexiaowen108",
                          style: TextStyle(
                            color: QDColors.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image(
                        width: 24,
                        height: 24,
                        image: "uc_arrow_right".qdImage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// icons
          Container(
            margin: EdgeInsets.only(bottom: 10, left: 11, right: 11, top: 10),
            padding: EdgeInsets.only(left: 25, right: 50),
            height: 81,
            decoration: BoxDecoration(
              // color: CupertinoColors.activeBlue,
              image: DecorationImage(
                centerSlice: Rect.fromLTWH(40, 0, 20, 10),
                image: "uc_header_item_container_background".qdImage(),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _listViewHeaderViewIconItems(),
            ),
          ),

          // Container(
          //   height: 10,
          //   decoration: BoxDecoration(
          //     color: 245.qdColor(),
          //   ),
          // ),
        ],
      ),
    );
  }

  List<Widget> _listViewHeaderViewIconItems() {
    //数据源
    var titles = ["我的钱包", "", "优惠券", "", "积分"];
    var imageNames = [
      "uc_icon_wallet",
      "",
      "uc_icon_discount",
      "",
      "uc_icon_integral"
    ];
    return titles.map((String title) {
      //如果是个空，则返回模拟竖线即可
      if (title.isEmpty) {
        return Container(
          height: 30,
          width: 0.5,
          decoration: BoxDecoration(color: QDColors.separateColor),
        );
      }

      return Row(
        children: [
          Image(
            width: 24,
            height: 24,
            image: imageNames[titles.indexOf(title)].qdImage(),
            // decoration: BoxDecoration(color: CupertinoColors.activeGreen),
          ),
          SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: QDColors.blackColor,
            ),
          )
        ],
      );
    }).toList();
  }

  //MARK: 列表

  _listViewBuildItemHeight(int index, int total) {
    return index < total - 1 ? 52.5 : 62.5;
  }

  _listViewBuildItem(int itemIndex, int parentIndex) {
    //是否是最后一个
    var isLast = itemIndex >= _titles[parentIndex].length - 1;

    //放置在listView中的row
    List<Widget> children = [
      Expanded(
          child: QDTitleRow(
        title: _titles[parentIndex][itemIndex],
        subtitle: _subtitles[parentIndex][itemIndex],
        imageName: _imageNames[parentIndex][itemIndex],
        hasDivider: !isLast,
      ))
    ];

    //如果是最后一个
    if (isLast) {
      children.add(Container(
        height: 10,
        decoration: BoxDecoration(
          color: 245.qdColor(),
        ),
      ));
    }

    return Column(children: children);
  }
}
