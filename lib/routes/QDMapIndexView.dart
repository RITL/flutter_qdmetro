import 'package:flutter/cupertino.dart';

/// 地图主页
class QDMapIndexView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QDMapIndexViewState();
}

class _QDMapIndexViewState extends State<QDMapIndexView> {
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        decoration: BoxDecoration(color: CupertinoColors.activeGreen),
        // child: FlutterMap(
        //   options: MapOptions(
        //     center: LatLng(36.131241, 120.409693),
        //     zoom: 13.0,
        //   ),
        //   layers: [
        //     TileLayerOptions(
        //       urlTemplate:
        //           "http://webrd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}",
        //     )
        //   ],
        // ),
      ),
    );
  }

  //   longitude: 120.409693,
  // latitude: 36.131241,
}
