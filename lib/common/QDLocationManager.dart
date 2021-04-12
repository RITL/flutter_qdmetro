// import 'package:geolocator/geolocator.dart';

import 'dart:async';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

typedef LocationCallback = void Function(QDPosition position);

class QDPosition {
  QDPosition(
      {this.longitude: 120.409693, this.latitude: 36.131241, this.code: 9999});

  final double longitude;
  final double latitude;
  // 9999表示初始化 0表示失败，1表示成功，-1表示没有权限
  final int code;
}

/// 高德定位的管理
class QDLocationManager {
  /// 高德地图的iOS Key
  static String iOSApiKey = "972694b3d66462891b8954c74cfaeeb4";

  /// 高德定位
  AMapFlutterLocation _aliMaplocationPlugin;

  /// 用于定位是否监听
  static StreamSubscription<Map<String, Object>> _locationListener;

  /// 初始化高德定位
  static initAMapLocation() {
    AMapFlutterLocation.setApiKey("", iOSApiKey);
  }

  // 用于消除
  void dispose() {
    if (_aliMaplocationPlugin != null) {
      _aliMaplocationPlugin.destroy();
    }

    if (_locationListener != null) {
      _locationListener.cancel();
    }
  }

  /// 默认的位置Future
  static Future<QDPosition> _defaultPositionFuture({int code: 9999}) {
    Future.value(
      defaultPosition(code: code),
    );
  }

  /// 默认的位置
  static QDPosition defaultPosition({int code: 9999}) {
    return QDPosition(
      longitude: 120.409693,
      latitude: 36.131241,
      code: code,
    );
  }

  /// 请求位置的权限
  static Future<bool> _requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 使用Geolocator进行地理位置请求
  Future<QDPosition> getLocationWithGeolocator() async {
    //请求位置即可
    try {
      var position =
          await Geolocator.getCurrentPosition(timeLimit: Duration(seconds: 6));
      return Future.value(QDPosition(
          latitude: position.latitude, longitude: position.longitude, code: 1));
    } catch (e) {
      return _defaultPositionFuture(code: 0);
    }
  }

  /// 使用高德SDK进行位置请求
  /// 获取定位并请求数据信息
  /// 由于高德，无法实现 async await 采用闭包形式 5.2.1
  void getLocationWithAMap(LocationCallback completeHandler) {
    //获得权限
    QDLocationManager._requestLocationPermission().then((hasAuthorization) {
      /// 不存在权限，返回默认的即可
      if (!hasAuthorization) {
        completeHandler(defaultPosition(code: -1));
        return;
      }
      //初始化变量
      if (_aliMaplocationPlugin == null) {
        _aliMaplocationPlugin = AMapFlutterLocation();
      }

      //设置定位的option
      _aliMaplocationPlugin.setLocationOption(AMapLocationOption(
          onceLocation: true, desiredAccuracy: DesiredAccuracy.Kilometer));
      //如果监听接口为空，则注册接口即可
      if (_locationListener == null) {
        _locationListener =
            _aliMaplocationPlugin.onLocationChanged().listen((result) {
          print(result);
          //获得code
          int errorCode = result["errorCode"];
          //如果errorCode不是null,返回失败即可
          if (errorCode != null) {
            completeHandler(defaultPosition(code: 0));
            return;
          }
          //获得经纬度
          var longitude = double.parse(result["longitude"]);
          var latitude = double.parse(result["latitude"]);
          completeHandler(
              QDPosition(latitude: latitude, longitude: longitude, code: 1));
        });
      }

      //开始定位
      _aliMaplocationPlugin.startLocation();
    });
  }
}
