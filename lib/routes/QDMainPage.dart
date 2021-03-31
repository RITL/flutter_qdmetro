import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_qdmetro/common/HttpUtil.dart';
import 'package:flutter_qdmetro/common/Global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        // top: false,
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
                    //顶部的轮播
                    if (index == 0) {
                      // return _topSwiper();
                      return _topSwiperAndIconContainer();
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
                  childCount: 2,
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
    var width = MediaQuery.of(context).size.width;
    var height = width * 170.0 / 375;
    return height;
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
