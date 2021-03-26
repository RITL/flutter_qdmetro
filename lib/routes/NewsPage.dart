import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../common/HttpUtil.dart';
import '../models/RouterItem.dart';
import '../models/ListsHeaderContainer.dart';
import '../models/DocumentItem.dart';
import '../components/DocumentRow.dart';
import 'QDWebView.dart';

/// 新闻界面
class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航栏
      appBar: AppBar(
        title: Text("资讯"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color.fromRGBO(76, 77, 76, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      //实现功能的载体
      body: NewsPageBody(),
    );
  }
}

class NewsPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsPageBodyState();
}

class NewsPageBodyState extends State<NewsPageBody> {
  /// 网络请求
  var httpUtil = HttpUtil();

  /// 存放顶部banner的items
  List<RouterItem> topImages = [];

  /// 展示文本列表的document
  List<DocumentItem> documents = [];

  /// 用于监听滚动
  ScrollController _scrollController = ScrollController();

  /// 当前的页码
  int currentPage = 1;

  /// 是否正在上拉加载
  bool isBottomLoading = false;

  /// 是否正在下拉刷新
  bool isHeaderLoading = false;

  /// 不再存在更多的数据
  bool isAll = false;

  @override
  void initState() {
    super.initState();
    //进行网络请求
    _loadData();

    //创建监听
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (isAll || isBottomLoading) {
          return;
        }
        isBottomLoading = true;
        _loadDocumentsList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 行数
  _rowsCount() {
    return 2 + documents.length;
  }

  /// 顶部的轮播图
  _getTopSwiper() {
    if (topImages.length < 1) {
      return Container(
        height: 0,
      );
    }
    //获得屏幕宽度
    var width = MediaQuery.of(context).size.width;
    var height = (width - 40) * 140.0 / 335 + 16;
    bool isLoop = topImages.length > 1;
    //返回轮播图
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Swiper(
          loop: isLoop,
          itemHeight: height - 16,
          itemWidth: width - 40,
          itemCount: topImages.length,
          viewportFraction: 0.95,
          scale: 1,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                topImages[index].imgUrl,
                fit: BoxFit.cover,
              ),
            );
          }),
    );
  }

  //获得列表的表头
  _getHeaderView() {
    if (documents.length < 1) {
      return Container(
        height: 0,
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 13, top: 12),
      height: 48,
      child: Text("地铁资讯",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  //获得列表信息
  _getDocumentRow(int index) {
    //获得item
    var item = documents[index];
    // print("index = ${index}, total = ${documents.length}");
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: DocumentRow(
          key: Key(item.id),
          item: DocumentRowItem(
              title: item.title,
              subtitle: item.time,
              imgUrl: item.image,
              hasDivider: index != documents.length - 1),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "/web",
            arguments: QDWebViewConfig(url: item.webUrl));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //banner图片
    return RefreshIndicator(
      onRefresh: () async {
        //正在下拉刷新中，直接return即可
        if (isHeaderLoading) {
          return;
        }
        setState(() {
          isHeaderLoading = true;
          currentPage = 1;
        });
        await _loadData();
        return;
      },
      child: ListView.builder(
        itemCount: _rowsCount(),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _getTopSwiper();
          }
          if (index == 1) {
            return _getHeaderView();
          }
          return _getDocumentRow(index - 2);
        },
        controller: _scrollController,
      ),
    );
  }

  //进行网络加载数据
  Future<Null> _loadData() async {
    _loadHeaderData();
    _loadDocumentsList();
    if (isHeaderLoading) {
      isHeaderLoading = false;
    }
  }

  //请求顶部的数据
  _loadHeaderData() async {
    try {
      //进行请求
      var response = await httpUtil.post(
        "ngstatic/document/getNewModules",
        {"moduleId": "20"},
      );
      //转model
      var container = ListsHeaderContainer.fromMap(response);

      //设置banner
      setState(() {
        topImages = container.imgList;
      });
    } on HttpIOException catch (e) {
      print(e.message);
    }
  }

  /// 记载底部的列表标签
  _loadDocumentsList() async {
    try {
      List<dynamic> response = await httpUtil.post(
        "ngstatic/document/getDocumentList",
        {"type": "20", "size": "10", "page": currentPage},
      );
      //如果当前页码为1,数据置空即可
      if (currentPage == 1) {
        documents = [];
      }

      var items =
          response.map((element) => DocumentItem.fromMap(element)).toList();
      //设置数据
      setState(() {
        isAll = items.length < 10;
        isBottomLoading = false;
        currentPage += 1;
        documents.addAll(items);
      });
    } on HttpIOException catch (e) {}
  }
}
