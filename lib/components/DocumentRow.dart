import 'package:flutter/material.dart';
import '../common/Global.dart';

class DocumentRowItem {
  DocumentRowItem({this.title, this.subtitle, this.imgUrl, this.hasDivider});

  String title = "";
  String subtitle = "";
  String imgUrl = "";
  bool hasDivider = false;
}

class DocumentRow extends StatefulWidget {
  /// 创建传值
  DocumentRow({Key key, this.item}) : super(key: key);

  DocumentRowItem item;
  @override
  State<StatefulWidget> createState() => _DocumentRowState();
}

class _DocumentRowState extends State<DocumentRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 12, 10, 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Global.BlackColor,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          widget.item.subtitle,
                          style: TextStyle(
                            color: Color.fromRGBO(179, 179, 179, 1),
                            fontSize: 12,
                          ),
                        ),
                      )
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.item.imgUrl,
                    width: 100,
                    height: 68,
                    fit: BoxFit.cover,
                  )),
            )
          ],
        ),
        Divider(
          height: 0.1,
          color: Color.fromRGBO(76, 77, 76, widget.item.hasDivider ? 1 : 0),
          indent: 2,
          endIndent: 2,
        ),
      ],
    );
  }
}
