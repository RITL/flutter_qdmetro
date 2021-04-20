import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_qdmetro/common/QDGlobal.dart';
import 'package:flutter_qdmetro/common/QDHttpUtil.dart';
import 'package:flutter_qdmetro/common/QDLocationManager.dart';
import 'package:flutter_qdmetro/components/QDDottedLine.dart';
import 'package:flutter_ritl_alert/flutter_ritl_alert.dart';

import '../models/QDHomePageContainer.dart';

/// 地图主页
class QDMapIndexView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QDMapIndexViewState();
}

class _QDMapIndexViewState extends State<QDMapIndexView> {
  //定位对象
  QDLocationManager _locationManager = QDLocationManager();
  //底部的icon
  List<QDAppIcon> _icons = [];
  //当前的数据
  QDPosition _currentPosition = QDLocationManager.defaultPosition();

  /// 文本域
  /// 为了模拟点击效果，采用文字输入即可，不再跳转新的界面
  // String _start = "";
  TextEditingController _startTextController;
  // String _end = "";
  TextEditingController _endTextController;

  @override
  initState() {
    super.initState();
    _startTextController = TextEditingController();
    _endTextController = TextEditingController();

    //进行定位
    _getCurrentLocation();
    //获得icon
    _requestAllIcons();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _startTextController.dispose();
    _endTextController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(color: CupertinoColors.activeGreen),
          child: SafeArea(
            top: false,
            child: Stack(
              children: [
                _mapWidget(),
                _bottomIconContainer(),
              ],
            ),
          )),
    );
  }

  /// 地图
  _mapWidget() {
    //默认未初始化完毕，返回占位即可
    if (_currentPosition.code == 9999) {
      return Container();
    }
    return AMapWidget(
      apiKey: AMapApiKey(iosKey: QDLocationManager.iOSApiKey),
      initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition.latitude,
            _currentPosition.longitude,
          ),
          zoom: 16),
      myLocationStyleOptions: MyLocationStyleOptions(true),
    );
  }

  /// 结束响应
  _endEdit() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// 地图顶层的icon容器区域
  _bottomIconContainer() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _endEdit();
        },
        child: Container(
          height: 190,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: QDColors.whiteColor,
            // image: DecorationImage(
            //   centerSlice: Rect.fromLTWH(10, 0, 20, 10),
            //   image: "map_index_footer_container_background".qdImage(),
            // ),
          ),

          /// 分为3列，数据输入部分 搜索部分  icon部门
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //数据输入部分
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: QDColors.mainPageBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //数据输入部门左侧的原点标记区域
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //起点原点
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: QDColors.newThemeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 30,
                          width: 10,
                          child: QDDottedLine(
                            color: QDColors.separateColor,
                            direction: Axis.vertical,
                            dashWidth: 3,
                            height: 4,
                            radius: 2,
                          ),
                        ),
                        //终点原点
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(252, 101, 0, 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    // Text("input"),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  width: 0.5,
                                  color: QDColors.separateColor,
                                )),
                              ),
                              height: 40,
                              child: CupertinoTextField(
                                style: TextStyle(
                                  color: QDColors.blackColor,
                                  fontSize: 16,
                                ),
                                controller: _startTextController,
                                placeholder: "请输入出发地",
                                decoration: BoxDecoration(),
                                placeholderStyle: TextStyle(
                                  fontSize: 16,
                                  color: CupertinoColors.placeholderText,
                                ),
                                // onChanged: (value) {
                                //   setState(() {
                                //     _start = value;
                                //   });
                                // },
                              ),
                            ),
                            Container(
                              height: 40,
                              child: CupertinoTextField(
                                style: TextStyle(
                                  color: QDColors.blackColor,
                                  fontSize: 16,
                                ),
                                controller: _endTextController,
                                placeholder: "请输入出发地",
                                decoration: BoxDecoration(),
                                placeholderStyle: TextStyle(
                                  fontSize: 16,
                                  color: CupertinoColors.placeholderText,
                                ),
                                // onChanged: (value) {
                                //   setState(() {
                                //     _end = value;
                                //   });
                                // },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Image(
                        width: 26,
                        height: 26,
                        image: "map_index_footer_transfer".qdImage(),
                      ),
                      onTap: () {
                        _exchangeStartAndEnd();
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _searchButtonDidTap();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 12),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          QDColors.defaultThemeLeadingColor,
                          QDColors.defaultThemeTralingColor
                        ],
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "搜索",
                        style: TextStyle(
                          color: QDColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// icon
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _icons
                      .map((e) => Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: e.imgUrl,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 3),
                              Text(
                                e.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: QDColors.blackColor,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //MARK: 逻辑

  /// 获得当前的地理位置
  _getCurrentLocation() async {
    // var position = await _locationManager.getLocationWithGeolocator();
    _locationManager.getLocationWithAMap((position) {
      //进行地图定位
      setState(() {
        // _currentPosition = QDPosition(latitude: 38.000, longitude: 120.11111);
        _currentPosition = position;
      });

      //如果定位是权限问题，弹窗提示一下
      if (position.code != -1) {
        return;
      }
      //弹窗提示即可
      RITLAlert(
        context: context,
        title: "定位失败",
        message: "请开启GPS定位服务，获取精准定位",
      ).show();
    });
  }

  /// 获得icon
  _requestAllIcons() async {
    Map response = await QDHttpUtil().post(QDHttpURL.QDMapIndexIconURL, {});
    //进行模型转换
    List icons = response["appIcons"] ?? [];
    //进行赋值转换
    setState(() {
      _icons = icons.map((e) => QDAppIcon.fromMap(e)).toList();
    });
  }

  ///MARK: Targe

  _searchButtonDidTap() {
    //获得两个文本域的文字
    _endEdit();
    //判断起点和终点
    var message = _startTextController.text.isEmpty
        ? "您从哪里触发?"
        : _endTextController.text.isEmpty
            ? "您到哪里去?"
            : "";

    RITLAlert(
      context: context,
      title: "点击了搜索",
      message: message.isEmpty
          ? "起点是: ${_startTextController.text} \n 目的地是: ${_endTextController.text}"
          : message,
    ).show();

    // showCupertinoDialog(
    //     context: context,
    //     builder: (context) => CupertinoAlertDialog(
    //           title: Text("搜索啦!"),
    //           content: Text(
    //               "起点是: ${_startTextController.text} \n 目的地是: ${_endTextController.text}"),
    //           actions: [
    //             Text("取消"),
    //           ],
    //         ));

    // print("${_startTextController.text}" + "${_endTextController.text}");
  }

  _exchangeStartAndEnd() {
    print("交换啦");
    //进行交换起始点
    // [_start, _end] = [_end, _start];
    _endEdit();
    var start = _startTextController.text;
    var end = _endTextController.text;
    setState(() {
      _startTextController.text = end;
      _endTextController.text = start;
    });
  }
}
