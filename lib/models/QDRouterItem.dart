import 'dart:convert';

class QDRouterItem {
  QDRouterItem({
    this.boxKey,
    this.gif,
    this.id,
    this.imgUrl,
    this.mid,
    this.moduleType,
    this.title,
    this.type,
  });

  String boxKey;
  bool gif;
  String id;
  String imgUrl;
  String mid;
  String moduleType;
  String title;
  String type;

  factory QDRouterItem.fromJson(String str) =>
      QDRouterItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDRouterItem.fromMap(Map<String, dynamic> json) => QDRouterItem(
        boxKey: json["boxKey"],
        gif: json["gif"],
        id: json["id"],
        imgUrl: json["imgUrl"],
        mid: json["mid"],
        moduleType: json["moduleType"],
        title: json["title"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "boxKey": boxKey,
        "gif": gif,
        "id": id,
        "imgUrl": imgUrl,
        "mid": mid,
        "moduleType": moduleType,
        "title": title,
        "type": type,
      };
}
