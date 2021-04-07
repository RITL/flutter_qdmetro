import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
// import 'package:move_forever_app/core/http/HttpIOExcepiton.dart';

/// 方法名字封装
const String GET = "GET";
const String POST = "POST";

/// 基础域名
const String HOST = "https://api.qd-metro.com/"; //正式环境
/// 链接超时时间
const int CONNECT_TIMECOUT = 10000000;

/// 等待超时时间
const int RECEIVE_TIMEOUT = 3000000;

typedef ErrorCallBack = void Function(int count, String msg);

/// 自己的异常
class HttpIOException implements Exception {
  int code;
  String message;
  HttpIOException(this.code, this.message);
}

/// 默认的拦截器
class HttpDefaultInterceptor extends Interceptor {
  // @override
  Future onRequest(RequestOptions options) async {
    //获得公共参数
    Map<String, String> commonMap = Map<String, String>();
    //获得包的信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //版本号
    commonMap["version"] = packageInfo.version;
    //设置平台
    commonMap["platform"] =
        Platform.isIOS ? "iOS" : (Platform.isAndroid ? "Android" : "");
    //如果是get获取queryParameters
    if (options.method == GET) {
      //获取queryParameters
      options.queryParameters =
          options.queryParameters ?? Map<String, dynamic>()
            ..addAll(commonMap);
    }
    //如果是post获取data即可
    else if (options.method == POST) {
      //获得data
      //如果类型是formData
      if (options.contentType == ContentType.text.toString() &&
          options.data is Map) {
        options.data = FormData.fromMap(
            (options.data ?? Map<dynamic, dynamic>())..addAll(commonMap));
      }
      //如果是普通的Map
      else if (options.data is Map) {
        options.data = (options.data ?? Map<dynamic, dynamic>())
          ..addAll(commonMap);
      }
    }

    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    //获得data
    var data =
        (response.data is Map) ? response.data : json.decode(response.data);
    if (data == null) {
      return super.onError(DioError(error: HttpIOException(-4, "JSON 格式不正确")));
    }
    var respcod = data["respcod"];
    if (respcod != "01") {
      return super.onError(
          DioError(error: HttpIOException(-4, data["respmsg"] ?? "数据返回错误!")));
    }

    response.data = data["data"] ?? Map<String, String>();
    return super.onResponse(response);
  }
}

class HttpUtil {
  /// 工厂模式返回单例
  factory HttpUtil() => HttpUtil._shareInstance();

  /// 基础配置
  BaseOptions options;

  /// 网络请求
  Dio _dio;

  ///单例对象
  static HttpUtil _shareUtil;

  ///单例方法
  static HttpUtil _shareInstance() {
    if (_shareUtil == null) {
      _shareUtil = HttpUtil._init();
    }
    return _shareUtil;
  }

  /// 初始化方法
  HttpUtil._init() {
    options = BaseOptions(
      contentType: ContentType.text.toString(), //默认为二进制
      connectTimeout: CONNECT_TIMECOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      baseUrl: HOST,
    );
    _dio = Dio(options);
    //追加拦截器
    addInterceptor(HttpDefaultInterceptor());
  }

  ///拦截器
  addInterceptor(Interceptor interceptor) {
    if (null != _dio) {
      _dio.interceptors.add(interceptor);
    }
  }

  ///追加拦截器
  addInterceptors(List<Interceptor> interceptors) {
    if (null != _dio) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  Future<dynamic> post(String path, data, {isJson: false}) async {
    return request(path, POST, data, isJson: isJson);
  }

  Future<dynamic> get(String path, data, {isJson: false}) async {
    return request(path, GET, data, isJson: isJson);
  }

  /// 进行网络请求
  Future<dynamic> request(String path, String mode, data,
      {isJson: false}) async {
    //进行contentType设置
    _dio.options.contentType =
        (isJson ? ContentType.json : ContentType.text).toString();

    try {
      //根据网络请求方式进行拆分
      switch (mode) {
        case GET:
          var response = await _dio.get(path, queryParameters: data);
          return new Future<dynamic>(() {
            return response.data;
          });
        case POST:
          //做一层json转换
          var response =
              await _dio.post(path, data: isJson ? json.encode(data) : data);
          return new Future<dynamic>(() {
            return response.data;
          });
      }
      //优先处理 DioError
    } on DioError catch (e) {
      return Future.error(
          HttpIOException(e.response?.statusCode ?? -3, e.message));
    } catch (e) {
      return Future.error(HttpIOException(-2, e.toString()));
    }

    return Future.error(HttpIOException(-1, "not supported"));
  }
}
