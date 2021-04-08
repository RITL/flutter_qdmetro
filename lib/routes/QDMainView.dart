import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_qdmetro/common/HttpUtil.dart';
import 'package:flutter_qdmetro/common/Global.dart';

import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'QDWebView.dart';
import '../components/QDDocumentRow.dart';
import '../models/QDHomePageContainer.dart';

class QDMainView extends StatefulWidget {
  QDMainView({Key key}) : super(key: key);

  @override
  _QDMainViewState createState() => _QDMainViewState();
}

class _QDMainViewState extends State<QDMainView> with TickerProviderStateMixin {
  /// 是否存在导航栏
  bool _hasNavigationBar = false;

  /// 列表的数据源
  QDHomePageContainer _listDataContainer;

  /// 记录当前的线路
  int _currentLine = 0;
  int _currentLineIndex = 0;
  double _currentLineOriginX = -7.0;
  double _beforeLineOriginX = -7.0;

  /// 列表控制器
  ScrollController _scrollController = ScrollController();

  //动画控制器
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    //创建scrollView
    _scrollController.addListener(() {
      //如果导航栏的滚动
      var navigationBarHeight = MediaQuery.of(context).padding.top + 64.0;
      //应该展示模拟的导航栏
      if (_scrollController.offset > navigationBarHeight) {
        //不存在导航栏
        if (_hasNavigationBar) {
          return;
        }
        //存在导航栏，启用黑色状态栏
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        setState(() {
          _hasNavigationBar = true;
        });
      } else {
        //应该消失模拟的导航栏
        //如果已经消失了，不再做操作
        if (!_hasNavigationBar) {
          return;
        }
        //存在状态栏，启用白色状态栏
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        setState(() {
          _hasNavigationBar = false;
        });
      }
    });

    //动画管理
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    //执行动画
    _animation = Tween(begin: _beforeLineOriginX, end: _currentLineOriginX)
        .animate(_animationController);
    //开始获取定位并开始请求
    _requestAllData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      //导航栏
      // navigationBar: _navigationBar(),
      child: SafeArea(
          top: false,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Global.mainPageBackgroundColor,
                ),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    /// 刷新组件
                    CupertinoSliverRefreshControl(),

                    /// List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          //顶部的轮播以及icon
                          if (index == 0) {
                            // return _topSwiper();
                            return _topSwiperAndIconContainer();
                          }
                          //热门活动
                          if (index == 1) {
                            return _activityContainer();
                          }
                          //附近站点
                          if (index == 2) {
                            return _nearStationContainer();
                          }
                          //中间的广告
                          if (index == 3) {
                            return _middleAdContainer();
                          }
                          //资讯模块
                          if (index == 4) {
                            return _bottomDocumentContainer();
                          }
                          //知道么
                          if (index == 5) {
                            return _bottomKnowledgeContainer();
                          }

                          //icon导航栏
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 800,
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeBlue,
                            ),
                          );
                        },
                        childCount: 6,
                      ),
                    ),
                  ],
                ),
              ),
              _navigationBar(),
            ],
          )),
    );
  }

  //MARK: UI

  /// 顶部的navigationBar
  _navigationBar() {
    // if (!_hasNavigationBar) {
    //   return Container();
    // }
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).padding.top + 44.0,
        decoration: BoxDecoration(
          color: _hasNavigationBar
              ? CupertinoColors.white
              : Color.fromRGBO(0, 0, 0, 0),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _hasNavigationBar
                        ? Text(
                            "畅达幸福",
                            style: TextStyle(
                              color: Global.blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.only(
                        right: 10,
                        top: 7,
                        bottom: 2,
                      ),
                      child: GestureDetector(
                          onTap: () => print("扫一扫"),
                          child: Image(
                            image: _hasNavigationBar
                                ? AssetImage("images/main_tab_scan.png")
                                : AssetImage("images/main_tab_scan_normal.png"),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //获得swiper的高度
  _getSwiperConstHeight() {
    var safeTop = MediaQuery.of(context).padding.top;
    var width = MediaQuery.of(context).size.width;
    var height = width * 170.0 / 375;
    return height + safeTop;
  }

  _getIconContainerHeight() {
    var height = 20.0;
    //获得容器的宽度
    var width = MediaQuery.of(context).size.width - 30;
    // return 20 +
    //large的高度
    height += (width / 5 * 58 / 67.0);
    //普通的高度
    height += (width / 5 * 47 / 67.0) * 2;
    //返回总高度
    return height;
  }

  _getIconCotainerInset() {
    return 20.0;
  }

  /// 顶部的Swiper和icon的整体容器
  _topSwiperAndIconContainer() {
    return Container(
      height: _getSwiperConstHeight() +
          _getIconContainerHeight() -
          _getIconCotainerInset(),
      child: Stack(
        children: [
          _topSwiper(),
          //icon
          Positioned(
            // top: 0,
            top: _getSwiperConstHeight() - _getIconCotainerInset(),
            left: 0,
            right: 0,
            child: _iconContainer(),
          ),
        ],
      ),
    );
  }

  /// 顶部的Swiper
  _topSwiper() {
    var items = _listDataContainer?.imgList ?? [];
    bool isLoop = items.length > 1;
    return Container(
      height: _getSwiperConstHeight(),
      child: items.isEmpty
          ? Container()
          : Swiper(
              itemCount: items.length,
              autoplay: isLoop,
              loop: isLoop,
              itemBuilder: ((context, index) => CachedNetworkImage(
                    imageUrl: items[index].imgUrl,
                    fit: BoxFit.cover,
                  )),
            ),
    );
  }

  /// 顶部的iconContainer
  _iconContainer() {
    var iconItems = _listDataContainer?.appIcons ?? [];
    if (iconItems.isEmpty) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      //圆角
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Container(
          // height: _getIconContainerHeight(),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
          ),
          child: Column(
            children: [
              GridView.count(
                padding: EdgeInsets.only(top: 5),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                childAspectRatio: 67.0 / 58,
                children: iconItems
                    .sublist(0, 5)
                    .map((e) => _iconItem(e, isLarge: true))
                    .toList(),
              ),
              GridView.count(
                padding: EdgeInsets.only(bottom: 15),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                childAspectRatio: 67.0 / 47,
                children:
                    iconItems.sublist(5).map((e) => _iconItem(e)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获得图标的item
  Widget _iconItem(QDAppIcon icon, {bool isLarge = false}) {
    //获得largeIcon
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: isLarge ? icon.bigIconUrl : icon.imgUrl,
          width: 67,
        ),
        Text(
          icon.name,
          style: TextStyle(
            color: Global.blackColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  //MARK:
  _activityContainer() {
    var items = _listDataContainer?.activity ?? [];
    if (items.isEmpty) {
      return Container();
    }
    return Container(
      // height: 250,
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        children: [
          //头部标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "热门活动",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "查看更多>",
                style: TextStyle(
                  fontSize: 12,
                  color: Global.grayColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            // decoration: BoxDecoration(
            //   color: CupertinoColors.systemRed,
            // ),
            child: GridView.count(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              shrinkWrap: true,
              childAspectRatio: 110.0 / 150,
              children: items
                  .map((e) => Container(
                        child: CachedNetworkImage(
                          imageUrl: e.imgUrl,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 附近站点容器
  _nearStationContainer() {
    var stationInfo = _listDataContainer?.nearByStation;
    if (stationInfo == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _nearStationHeader(),
          _nearStationMessageWidget(stationInfo),
        ],
      ),
    );
  }

  /// 附近站点的头部
  _nearStationHeader() {
    var stationInfo = _listDataContainer?.nearByStation;
    if (stationInfo == null) {
      return Container();
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "附近站点",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    stationInfo.stationName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Global.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "距离约${stationInfo.distance}" +
                  "${stationInfo.walkTime == 0 ? '' : ',步行约${stationInfo.walkTime}分钟'}",
              style: TextStyle(
                fontSize: 12,
                color: Global.blackColor,
              ),
            )
          ],
        ),
      ],
    );
  }

  /// 附近站点消息的widget
  _nearStationMessageWidget(QDNearByStation info) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // height: 400,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Global.whiteColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _nearStationSegment(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: _nearStationMessageItem(
                          info.lineData[_currentLineIndex], true)),
                  Expanded(
                      child: _nearStationMessageItem(
                          info.lineData[_currentLineIndex], false)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Global.ligjtOrangeColor,
                          ),
                          child: Text(
                            "到站时间仅为计划时间，请以实际到站时间为准.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Global.orangeColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 每个item的真实长度
  _nearStationSegmentItemWidth() {
    var items = _listDataContainer?.nearByStation?.lineData ?? [];
    return (MediaQuery.of(context).size.width - 30) / max(1, items.length);
  }

  /// 每个item背后滑块的真实长度
  _nearStationSegmentItemSwitchWidth() {
    return _nearStationSegmentItemWidth() + 14;
  }

  /// 更新附近站点的相关唯一数据
  _updateCurrentIndexFrameOnNearStation() {
    setState(() {
      _beforeLineOriginX = _currentLineOriginX;
      _currentLineOriginX =
          _nearStationSegmentItemWidth() * (_currentLineIndex + 0.5) -
              _nearStationSegmentItemSwitchWidth() / 2.0;
    });
  }

  /// 更新动画属性
  _updateAnimation() {
    setState(() {
      _animation = Tween(begin: _beforeLineOriginX, end: _currentLineOriginX)
          .animate(_animationController);
    });
  }

  /// 附近站点顶部的线路选择器
  _nearStationSegment() {
    //获得线路信息
    var items = _listDataContainer?.nearByStation?.lineData ?? [];
    var isOnly = items.length < 2;
    return Container(
        // height: 42,
        //如果只有一个，则需要渐变色
        decoration: isOnly
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: Global.metroLineUnselectedGradientColors(),
                ),
              )
            : BoxDecoration(
                color: Global.mainPageBackgroundColor,
              ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left:
                  _currentLineOriginX, //_animation?.value ??-7, //使用中心点计算 /*_currentLineIndex * width - 7,*/
              // child:
              // SlideTransition(
              // position: _animation,
              child: Container(
                height: isOnly ? 0 : 42,
                width: _nearStationSegmentItemSwitchWidth(),
                decoration: isOnly
                    ? BoxDecoration()
                    : BoxDecoration(
                        image: DecorationImage(
                          // fit: BoxFit.fill,
                          // centerSlice: Rect.fromLTRB(40, 0, 40, 0),
                          centerSlice: Rect.fromLTWH(10, 0, 20, 10),
                          image: AssetImage(
                              "images/metro_select_segment_background.png"),
                        ),
                      ),
              ),
            ),
            // ),
            Container(
              height: 42,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: items
                    .map((e) => _nearStationSegmentItem(e, isOnly))
                    .toList(),
              ),
            )
          ],
        ));
  }

  /// segment的选项item
  Widget _nearStationSegmentItem(QDLineData data, bool isOnlyOne) {
    //是否选中
    var isSelected = _currentLine == data.line;
    //获得索引
    var index = _listDataContainer?.nearByStation?.lineData?.indexOf(data) ?? 0;

    /// 必存在的选项
    List<Widget> children = [
      Container(
        width: 56,
        height: 26,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _currentLine == data.line
                ? "${data.line}".metroLineGradientColors()
                : [Global.borderGrayColor, Global.borderGrayColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${data.lineName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Global.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            )
          ],
        ),
      ),
    ];

    //如果不是唯一一个，需要追加角标三角
    if (!isOnlyOne && isSelected) {
      children.add(
        Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  height: 4,
                  width: 16,
                  image: AssetImage("images/main_station_arrow_up.png"),
                ),
              ],
            )),
      );
    }

    // 返回segmentItem容器
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: children,
                ),
              )
            ],
          ),
          onTap: () {
            //阻止重复或者无效点击
            if (isOnlyOne || _currentLine == data.line) {
              return;
            }
            //获得
            setState(
              () {
                _currentLine = data.line;
                _currentLineIndex = index;
                //这是动画的值
                _updateCurrentIndexFrameOnNearStation();
                //启动动画
                _updateAnimation();
                _animationController.forward();
              },
            );
          },
        ),
      ),
    );
  }

  /// 附近站点进出站信息的item
  /// 带有样式:
  /// 往：
  /// 本次列车:
  /// -----
  /// 首末时间
  _nearStationMessageItem(QDLineData lineData, bool isLeft) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      // height: 200,
      // width: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            height: 75,
            width: 1,
            decoration: BoxDecoration(
              color: "${lineData.line}".metroLineColor(),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "往",
                      style: TextStyle(
                        color: Global.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      isLeft ? lineData.startStation : lineData.endStation,
                      style: TextStyle(
                        color: Global.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "本次列车",
                      style: TextStyle(
                        color: Global.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Row(
                      children: [
                        Image(
                          width: 10,
                          height: 10,
                          image: AssetImage("images/metro_time_icon.png"),
                        ),
                        Text(
                          isLeft
                              ? lineData.startTimeArray.first
                              : lineData.endTimeArray.last,
                          style: TextStyle(
                            color: Global.orangeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  child: Divider(),
                ),

                /// 下方的时间表
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _nearStationMessageTimeItem(
                        "首", isLeft ? lineData.startFirst : lineData.endFirst),
                    _nearStationMessageTimeItem(
                        "末", isLeft ? lineData.startLast : lineData.endLast),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 附近站点信息底部的（首末时间）样式
  _nearStationMessageTimeItem(String title, String time) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: 18,
          padding: EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Global.borderGrayColor,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Global.blackColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: Global.blackColor,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  /// 中间广告页的高度
  _middleAdContainerHeight() {
    var width = MediaQuery.of(context).size.width - 40;
    var height = width * 60.0 / 335;
    return height;
  }

  //中间的广告位置
  _middleAdContainer() {
    var items = _listDataContainer?.advertisement ?? [];
    if (items.isEmpty) {
      return Container();
    }
    return Container(
      height: _middleAdContainerHeight(),
      child: Swiper(
        loop: items.isNotEmpty,
        itemCount: items.length,
        itemBuilder: (context, index) => Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: items[index].imgUrl,
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }

  //获得列表信息
  _getDocumentRow(int index) {
    //获得item
    var items = _listDataContainer?.documents ?? [];
    if (index >= items.length) {
      return Container();
    }
    var item = _listDataContainer.documents[index];
    // print("index = ${index}, total = ${documents.length}");
    return GestureDetector(
      child: Container(
        height: 90,
        child: QDDocumentRow(
          key: Key(item.id),
          item: QDDocumentRowItem(
              title: item.title,
              subtitle: Global.transDateToString(int.parse(item.time)),
              imgUrl: item.image,
              hasDivider: index != items.length - 1),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "/web",
            arguments: QDWebViewConfig(url: item.webUrl));
      },
    );
  }

  ///底部的资讯文章
  _bottomDocumentContainer() {
    var items = _listDataContainer?.documents ?? [];
    if (items.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "地铁资讯",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "查看更多>",
              style: TextStyle(
                fontSize: 12,
                color: Global.grayColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemExtent: 90,
          itemCount: items.length,
          itemBuilder: (context, index) => _getDocumentRow(index),
        )
      ]),
    );
  }

  /// doyouknow 知识的row
  _bottomKnowledgeRow(int index) {
    var item = _listDataContainer.doYouKnow.list[index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: Global.blackColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: Global.blackColor,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      item.number,
                      style: TextStyle(
                        color: Global.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(item.unit,
                        style: TextStyle(
                          color: Global.blackColor,
                          fontSize: 12,
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            child: Divider(
              height: 0.5,
              color: Color.fromRGBO(253, 238, 220, 1),
            ),
          )
        ],
      ),
    );
  }

  /// 底部bottomKnowledgeContainer中list的高度
  _bottomKnowledgeListHeight() {
    var items = _listDataContainer?.doYouKnow?.list ?? [];
    if (items.isEmpty) {
      return 0.0;
    }
    return 33.0 * items.length + 22.0 + 10.0;
  }

  /// 底部的DoUknown
  _bottomKnowledgeContainer() {
    var items = _listDataContainer?.doYouKnow?.list ?? [];
    if (items.isEmpty) {
      Container();
    }
    return Padding(
      padding: EdgeInsets.only(left: 13, right: 13, top: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          height: _bottomKnowledgeListHeight(),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(color: CupertinoColors.white),
          child: Stack(
            children: [
              //左上角的图片
              Positioned(
                child: Image.asset("images/main_bottom_left_top_bg.png"),
              ),
              //右下角的图片
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset("images/main_bottom_right_bottom_bg.png"),
              ),

              /// 中间的圆角框
              Positioned(
                right: 4,
                top: 5,
                left: 4,
                bottom: 5,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: .5,
                        color: Color.fromRGBO(253, 238, 220, 1),
                      )),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 22),
                    itemExtent: 33,
                    itemCount: items.length,
                    itemBuilder: (context, index) => _bottomKnowledgeRow(index),
                  ),
                ),
              ),
              //中间的文字
              Positioned(
                child: Container(
                  height: 22,
                  child: Center(
                    child: Container(
                      height: 22,
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/main_bottom_title_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          "您知道吗",
                          style: TextStyle(
                            color: Color.fromRGBO(252, 139, 0, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //MARK: 网络请求以及定位的逻辑

  _requestAllData() async {
    //获得定位
    var position = await _getLocationAndLoadData();
    //主页的数据
    double latitude = position.latitude ?? 36.131241;
    double longitude = position.longitude ?? 120.409693;
    //获得数据
    QDHomePageContainer container =
        await _requestListContainer(longitude: longitude, latitude: latitude);

    //设置值即可
    setState(() {
      _listDataContainer = container;
      _currentLine = container.nearByStation?.lineData?.first?.line ?? 0;
      _currentLineIndex = 0;
    });
  }

  /// 获取定位并请求数据信息
  Future<Position> _getLocationAndLoadData() async {
    //请求位置即可
    try {
      var position =
          await Geolocator.getCurrentPosition(timeLimit: Duration(seconds: 6));
      return Future.value(position);
    } catch (e) {
      return Future.value(
        Position(
          longitude: 120.409693,
          latitude: 36.131241,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        ),
      );
    }
  }

  /// 进行网络请求
  Future<QDHomePageContainer> _requestListContainer(
      {double longitude: 120.409693, double latitude: 36.131241}) async {
    //进行网络请求
    Map response = await HttpUtil().post(
        // 'https://www.fastmock.site/mock/3dbf639cdfdcfc128e6edd40c9042fd5/qdmetro/static/index',
        '/ngstatic/static/thirdlyIndex',
        {
          "moduleId": "1",
          "x": "${latitude.toString()}",
          "y": "${longitude.toString()}"
        });

    return Future.value(QDHomePageContainer.fromMap(response));
  }
}
