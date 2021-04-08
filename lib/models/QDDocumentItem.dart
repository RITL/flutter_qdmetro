// To parse this JSON data, do
//
//     final documentItem = documentItemFromMap(jsonString);
//
// 搭配

import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'int';

class QDDocumentItem {
  QDDocumentItem({
    this.author,
    this.favoriteNum,
    this.favorited,
    this.id,
    this.image,
    this.readNum,
    this.reply,
    this.replyNum,
    this.thumbUpNum,
    this.thumbuped,
    this.time,
    this.title,
    this.webUrl,
  });

  String author;
  int favoriteNum;
  bool favorited;
  String id;
  String image;
  int readNum;
  bool reply;
  int replyNum;
  int thumbUpNum;
  bool thumbuped;
  String time;
  String title;
  String webUrl;

  factory QDDocumentItem.fromJson(String str) =>
      QDDocumentItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QDDocumentItem.fromMap(Map<String, dynamic> json) => QDDocumentItem(
        author: json["author"],
        favoriteNum: json["favoriteNum"],
        favorited: json["favorited"],
        id: json["id"],
        image: json["image"],
        readNum: json["readNum"],
        reply: json["reply"],
        replyNum: json["replyNum"],
        thumbUpNum: json["thumbUpNum"],
        thumbuped: json["thumbuped"],
        time: json["time"],
        title: json["title"],
        webUrl: json["webUrl"],
      );

  Map<String, dynamic> toMap() => {
        "author": author,
        "favoriteNum": favoriteNum,
        "favorited": favorited,
        "id": id,
        "image": image,
        "readNum": readNum,
        "reply": reply,
        "replyNum": replyNum,
        "thumbUpNum": thumbUpNum,
        "thumbuped": thumbuped,
        "time": time,
        "title": title,
        "webUrl": webUrl,
      };

  // String timeDesc() {
  //   var format = DateTime();
  // }
}
