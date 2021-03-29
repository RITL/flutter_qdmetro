// To parse this JSON data, do
//
//     final listsHeaderContainer = listsHeaderContainerFromMap(jsonString);

import 'dart:convert';
import 'QDRouterItem.dart';

class QDListHeaderContainer {
  QDListHeaderContainer({
    this.imgList,
  });

  List<QDRouterItem> imgList;

  factory QDListHeaderContainer.fromJson(String str) =>
      QDListHeaderContainer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDListHeaderContainer.fromMap(Map<String, dynamic> json) =>
      QDListHeaderContainer(
        imgList: List<QDRouterItem>.from(
            json["imgList"].map((x) => QDRouterItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "RouterItem": List<dynamic>.from(imgList.map((x) => x.toMap())),
      };
}
