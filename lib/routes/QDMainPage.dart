import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_qdmetro/common/HttpUtil.dart';
import 'package:flutter_qdmetro/common/Global.dart';
import 'package:geolocator/geolocator.dart';
import 'QDWebViewPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/QDDocumentRow.dart';
import '../models/QDHomePageContainer.dart';

class QDMainPage extends StatefulWidget {
  QDMainPage({Key key}) : super(key: key);

  @override
  _QDMainPageState createState() => _QDMainPageState();
}

class _QDMainPageState extends State<QDMainPage> {
  /// 导航栏背景的颜色
  Color _navigationBarBackgroundColor = Colors.white;

  /// 是否存在导航栏
  bool _hasNavigationBar = false;

  /// 列表的数据源
  QDHomePageContainer _listDataContainer;

  /// 列表控制器
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //开始获取定位并开始请求
    _requestAllData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      //导航栏
      navigationBar: _navigationBar(),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Global.mainPageBackgroundColor,
          ),
          child: CustomScrollView(
            controller: scrollController,
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
                      return Text("我是附近站点");
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
      ),
    );
  }

  //MARK: UI

  /// 顶部的navigationBar
  _navigationBar() {
    if (!_hasNavigationBar) {
      return null;
    }
    return CupertinoNavigationBar(
      backgroundColor: _navigationBarBackgroundColor,
      border: Border(
        bottom: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0),
          width: 0.1, // One physical pixel.
          style: BorderStyle.solid,
        ),
      ),
      leading: Container(
        padding: EdgeInsets.only(
          left: 10,
          top: 10,
          // bottom: 10,
        ),
        child: Text(
          "畅达幸福",
          style: TextStyle(
            color: Global.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.only(
          right: 10,
          top: 7,
          bottom: 2,
        ),
        child: Image(
          image: AssetImage("images/main_tab_scan.png"),
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
              autoplay: false,
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
            decoration: BoxDecoration(
              color: CupertinoColors.systemRed,
            ),
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
      return 0;
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

    // Container(
    //   height: 150,
    //   margin: EdgeInsets.only(left: 13, right: 13, top: 15),
    //   decoration: BoxDecoration(
    //     color: CupertinoColors.white,
    //   ),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(8),
    //     ),
    //   ),
    // );
  }

  //MARK: 逻辑

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
    Map response = await HttpUtil().post('/ngstatic/static/thirdlyIndex', {
      "moduleId": "1",
      "x": "${latitude.toString()}",
      "y": "${longitude.toString()}"
    });

    return Future.value(QDHomePageContainer.fromMap(response));
  }
}
