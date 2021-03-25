// To parse this JSON data, do
//
//     final listsHeaderContainer = listsHeaderContainerFromMap(jsonString);

import 'dart:convert';
import './RouterItem.dart';

class ListsHeaderContainer {
  ListsHeaderContainer({
    this.imgList,
  });

  List<RouterItem> imgList;

  factory ListsHeaderContainer.fromJson(String str) =>
      ListsHeaderContainer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListsHeaderContainer.fromMap(Map<String, dynamic> json) =>
      ListsHeaderContainer(
        imgList: List<RouterItem>.from(
            json["imgList"].map((x) => RouterItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "RouterItem": List<dynamic>.from(imgList.map((x) => x.toMap())),
      };
}
