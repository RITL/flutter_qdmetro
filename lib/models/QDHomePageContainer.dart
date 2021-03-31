// To parse this JSON data, do
//
//     final QDHomePageContainer = QDHomePageContainerFromMap(jsonString);

import 'dart:convert';
import 'QDDocumentItem.dart';
import 'QDRouterItem.dart';

class QDHomePageContainer {
  QDHomePageContainer({
    this.activity,
    this.advertisement,
    this.appIcons,
    this.doYouKnow,
    this.documents,
    this.imgList,
    this.nearByStation,
    this.notices,
  });

  /// 顶部的banner图片
  List<QDRouterItem> imgList;

  /// icon区域
  List<QDAppIcon> appIcons;

  /// 中间最多放置三个的活动
  List<QDRouterItem> activity;

  /// 附近站点
  QDNearByStation nearByStation;

  /// 中间的banner图
  List<QDRouterItem> advertisement;

  /// 中间的紧急通知
  List<QDRouterItem> notices;

  /// 底部的资讯文章
  List<QDDocumentItem> documents;

  /// 底部的您知道吗
  QDDoYouKnow doYouKnow;

  factory QDHomePageContainer.fromJson(String str) =>
      QDHomePageContainer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDHomePageContainer.fromMap(Map<String, dynamic> json) =>
      QDHomePageContainer(
        activity: List<QDRouterItem>.from(
            json["activity"].map((x) => QDRouterItem.fromMap(x))),
        advertisement: List<QDRouterItem>.from(
            json["advertisement"].map((x) => QDRouterItem.fromMap(x))),
        appIcons: List<QDAppIcon>.from(
            json["appIcons"].map((x) => QDAppIcon.fromMap(x))),
        doYouKnow: QDDoYouKnow.fromMap(json["doYouKnow"]),
        documents: List<QDDocumentItem>.from(
            json["documents"].map((x) => QDDocumentItem.fromMap(x))),
        imgList: List<QDRouterItem>.from(
            json["imgList"].map((x) => QDRouterItem.fromMap(x))),
        nearByStation: QDNearByStation.fromMap(json["nearByStation"]),
        notices: List<QDRouterItem>.from(
            json["notices"].map((x) => QDRouterItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "activity": List<dynamic>.from(activity.map((x) => x.toMap())),
        "advertisement":
            List<dynamic>.from(advertisement.map((x) => x.toMap())),
        "appIcons": List<dynamic>.from(appIcons.map((x) => x.toMap())),
        "doYouKnow": doYouKnow.toMap(),
        "documents": List<dynamic>.from(documents.map((x) => x.toMap())),
        "imgList": List<dynamic>.from(imgList.map((x) => x.toMap())),
        "nearByStation": nearByStation.toMap(),
        "notices": List<dynamic>.from(notices.map((x) => x.toMap())),
      };
}

class QDAppIcon {
  QDAppIcon({
    this.bigIconUrl,
    this.editUrl,
    this.gif,
    this.imgUrl,
    this.linkUrl,
    this.moduleId,
    this.name,
    this.title,
    this.translation,
  });

  String bigIconUrl;
  String editUrl;
  bool gif;
  String imgUrl;
  String linkUrl;
  String moduleId;
  String name;
  String title;
  QDTranslation translation;

  factory QDAppIcon.fromJson(String str) => QDAppIcon.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDAppIcon.fromMap(Map<String, dynamic> json) => QDAppIcon(
        bigIconUrl: json["bigIconUrl"],
        editUrl: json["editUrl"],
        gif: json["gif"],
        imgUrl: json["imgUrl"],
        linkUrl: json["linkUrl"],
        moduleId: json["moduleId"],
        name: json["name"],
        title: json["title"],
        translation: json["translation"] == null
            ? null
            : QDTranslation.fromMap(json["translation"]),
      );

  Map<String, dynamic> toMap() => {
        "bigIconUrl": bigIconUrl,
        "editUrl": editUrl,
        "gif": gif,
        "imgUrl": imgUrl,
        "linkUrl": linkUrl,
        "moduleId": moduleId,
        "name": name,
        "title": title,
        "translation": translation == null ? null : translation.toMap(),
      };
}

class QDTranslation {
  QDTranslation({
    this.code,
    this.id,
    this.language,
    this.name,
    this.remark,
  });

  String code;
  int id;
  String language;
  String name;
  String remark;

  factory QDTranslation.fromJson(String str) =>
      QDTranslation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDTranslation.fromMap(Map<String, dynamic> json) => QDTranslation(
        code: json["code"],
        id: json["id"],
        language: json["language"],
        name: json["name"],
        remark: json["remark"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "id": id,
        "language": language,
        "name": name,
        "remark": remark,
      };
}

class QDDoYouKnow {
  QDDoYouKnow({
    this.list,
  });

  List<QDListElement> list;

  factory QDDoYouKnow.fromJson(String str) =>
      QDDoYouKnow.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDDoYouKnow.fromMap(Map<String, dynamic> json) => QDDoYouKnow(
        list: List<QDListElement>.from(
            json["list"].map((x) => QDListElement.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "list": List<dynamic>.from(list.map((x) => x.toMap())),
      };
}

class QDListElement {
  QDListElement({
    this.number,
    this.unit,
    this.subtitle,
    this.title,
  });

  String number;
  String unit;
  String subtitle;
  String title;

  factory QDListElement.fromJson(String str) =>
      QDListElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDListElement.fromMap(Map<String, dynamic> json) => QDListElement(
        number: json["number"],
        unit: json["unit"],
        subtitle: json["subtitle"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "number": number,
        "unit": unit,
        "subtitle": subtitle,
        "title": title,
      };
}

class QDNearByStation {
  QDNearByStation({
    this.disable,
    this.distance,
    this.isTransfer,
    this.lineData,
    this.lineName,
    this.lineNum,
    this.stationId,
    this.stationName,
    this.walkTime,
    this.xLocation,
    this.yLocation,
  });

  bool disable;
  String distance;
  String isTransfer;
  List<LineDatum> lineData;
  String lineName;
  String lineNum;
  int stationId;
  String stationName;
  int walkTime;
  double xLocation;
  double yLocation;

  factory QDNearByStation.fromJson(String str) =>
      QDNearByStation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDNearByStation.fromMap(Map<String, dynamic> json) => QDNearByStation(
        disable: json["disable"],
        distance: json["distance"],
        isTransfer: json["isTransfer"],
        lineData: List<LineDatum>.from(
            json["lineData"].map((x) => LineDatum.fromMap(x))),
        lineName: json["lineName"],
        lineNum: json["lineNum"],
        stationId: json["stationId"],
        stationName: json["stationName"],
        walkTime: json["walkTime"],
        xLocation: json["xLocation"].toDouble(),
        yLocation: json["yLocation"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "disable": disable,
        "distance": distance,
        "isTransfer": isTransfer,
        "lineData": List<dynamic>.from(lineData.map((x) => x.toMap())),
        "lineName": lineName,
        "lineNum": lineNum,
        "stationId": stationId,
        "stationName": stationName,
        "walkTime": walkTime,
        "xLocation": xLocation,
        "yLocation": yLocation,
      };
}

class LineDatum {
  LineDatum({
    this.endFirst,
    this.endLast,
    this.endStation,
    this.endTimeArray,
    this.line,
    this.lineId,
    this.lineName,
    this.nextEndStation,
    this.nextStartStation,
    this.startFirst,
    this.startLast,
    this.startStation,
    this.startTimeArray,
    this.thisStation,
  });

  String endFirst;
  String endLast;
  String endStation;
  List<String> endTimeArray;
  int line;
  int lineId;
  String lineName;
  String nextEndStation;
  String nextStartStation;
  String startFirst;
  String startLast;
  String startStation;
  List<String> startTimeArray;
  String thisStation;

  factory LineDatum.fromJson(String str) => LineDatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LineDatum.fromMap(Map<String, dynamic> json) => LineDatum(
        endFirst: json["endFirst"],
        endLast: json["endLast"],
        endStation: json["endStation"],
        endTimeArray: List<String>.from(json["endTimeArray"].map((x) => x)),
        line: json["line"],
        lineId: json["lineId"],
        lineName: json["lineName"],
        nextEndStation: json["nextEndStation"],
        nextStartStation: json["nextStartStation"],
        startFirst: json["startFirst"],
        startLast: json["startLast"],
        startStation: json["startStation"],
        startTimeArray: List<String>.from(json["startTimeArray"].map((x) => x)),
        thisStation: json["thisStation"],
      );

  Map<String, dynamic> toMap() => {
        "endFirst": endFirst,
        "endLast": endLast,
        "endStation": endStation,
        "endTimeArray": List<dynamic>.from(endTimeArray.map((x) => x)),
        "line": line,
        "lineId": lineId,
        "lineName": lineName,
        "nextEndStation": nextEndStation,
        "nextStartStation": nextStartStation,
        "startFirst": startFirst,
        "startLast": startLast,
        "startStation": startStation,
        "startTimeArray": List<dynamic>.from(startTimeArray.map((x) => x)),
        "thisStation": thisStation,
      };
}
