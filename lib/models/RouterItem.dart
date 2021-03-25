import 'dart:convert';

class RouterItem {
  RouterItem({
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

  factory RouterItem.fromJson(String str) =>
      RouterItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RouterItem.fromMap(Map<String, dynamic> json) => RouterItem(
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
