import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grab/common/ItemView2.dart';
import 'package:flutter_grab/common/common.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_grab/common/utils.dart';
import 'package:flutter_grab/manager/beans.dart';
import 'package:flutter_grab/manager/beans2.dart';
import 'package:flutter_grab/manager/main_model.dart';
import 'package:flutter_grab/pages/search.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'detail.dart';

class BasePage extends StatefulWidget {
  final PageType pageType; //false if vehicle.

  BasePage(this.pageType, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new BasePageState(pageType);
  }
}

class BasePageState extends State<BasePage> with AutomaticKeepAliveClientMixin {
  BasePageState(this.pageType);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  MainModel model;

  bool refreshing = false;
  bool loading = false;

  ///false if vehicle.
  PageType pageType = PageType.FindPassenger;

  _refreshList(Function done) {
    model.queryList(pageType, true, done: done);
  }

  _loadMoreList(Function done) {
    model.queryList(pageType, false, done: done);
  }

  Future _onRefresh() {
    return Future(() {
      if (!refreshing) {
        refreshing = true;
        print("ERROR. _onRefresh");
        _refreshList(() {
          refreshing = false;
        });
      }
    });
  }

  _gotoSearch() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(
                  pageType: pageType,
                )),
      );

  _onLoadMore() {
    print("INFO. _onLoadMore $loading");
    if (!loading) {
      loading = true;
      print("ERROR. _onLoadMore");
      _loadMoreList(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    model = MainModel.of(context);
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: getBodyView(context),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshing = false;
    loading = false;
    Future.delayed(Duration.zero, () {
      var x = MainModel.of(context);
      //加载 list 数据
      _onRefresh();
      //加载 banner 数据
      x.queryBanner(pageType);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getBodyView(BuildContext context) {
    var views = <Widget>[];
    //添加搜索
    var searchCondition = model.getSearchCondition(pageType);
    print("getBodyView searchCondition=$searchCondition");
    if (searchCondition != null) {
      views.add(getSearchView(
        searchCondition,
        () {
          _gotoSearch();
        },
        () {
          model.updateSearchCondition(pageType, null);
        },
      ));
    }
    //添加列表
    views.add(Expanded(child: _getScrollBody()));

    return Container(
      child: Column(children: views),
      color: Colors.white,
    );
  }

  /// View: 当前搜索信息。
  getSearchView(
      SearchCondition condition, Function callSearch, Function callClean) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      height: 55,
      child: InkWell(
        child: Row(
          children: <Widget>[
            SizedBox(width: 8),
            Icon(Icons.search, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                getDesc(condition),
                style: TextStyle(color: Colors.white),
              ),
              flex: 1,
            ),
            InkWell(
              child: Container(
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 24,
                ),
                padding: EdgeInsets.all(10),
              ),
              onTap: callClean,
            ),
          ],
        ),
        onTap: callSearch,
      ),
    );
  }

  /// View: 列表。
  _getScrollBody() {
    var status = model.getPageStatus(pageType);
    if (status == PageDataStatus.READY) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
//        child: _list(),
        child: _scrollViewWrapper(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  _scrollViewWrapper() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _onLoadMore();
        }
        return false;
      },
//      child: _list(),
      child: _scrollView(),
    );
  }

  Widget _scrollView() {
    final views = <Widget>[];
    var searchCondition = model.getSearchCondition(pageType);
    if (searchCondition == null) {
      //添加 搜索bar
      views.add(SliverPersistentHeader(
        delegate: _SliverAppBarDelegate(_getSearchInput(), 85, 85),
        floating: true,
      ));
    }

    //添加banner
    List<BannerInfo> info = model.getBannerInfoList();
    if (info != null && info.length > 0) {
      views.add(
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(_getBannerView(info), 120, 120),
          floating: false,
          pinned: false,
        ),
      );
    }

    views.add(_list());
    return CustomScrollView(
      slivers: views,
    );
  }

  Widget _list() {
    List<Event2> data = model.getListData(pageType);
    final enablePullUp = model.getHasMore(pageType);
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) => index == data.length
          ? _getLoadMore()
          : ItemView2(data[index], () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailPage(data[index])));
            }),
      childCount: enablePullUp ? data.length + 1 : data.length,
    ));
  }

  _getLoadMore() {
    return Container(
        color: Colors.greenAccent,
        child: FlatButton(
          child: Text("Load More"),
          onPressed: _onLoadMore,
        ));
  }

  _getSearchInput() {
    return Container(
      height: 55,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(width: 0.5, color: Colors.grey[400]),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              blurRadius: 10.0,
              spreadRadius: 1.0,
            )
          ]),
      child: InkWell(
        child: Row(
          children: <Widget>[
            SizedBox(height: 50, width: 20),
            Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10),
            Text(
              "搜索 起点 和 终点",
              style: textStyle2,
              maxLines: 1,
            ),
          ],
        ),
        onTap: () {
          _gotoSearch();
        },
      ),
    );
  }

  _getSearchInput2() {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: InkWell(
        child: Row(
          children: <Widget>[
            SizedBox(height: 50, width: 20),
            Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10),
            Text(
              "搜索 起点 和 终点",
              style: textStyle2,
              maxLines: 1,
            ),
          ],
        ),
        onTap: () {
          _gotoSearch();
        },
      ),
    );
  }

  /// View: Banner
  _getBannerView(List<BannerInfo> infos) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 120,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: new BorderRadius.circular(8.0),
            child: Image(
              image: new CachedNetworkImageProvider(infos[index].image),
              fit: BoxFit.fitWidth,
            ),
          );
        },
        itemHeight: 120,
        itemCount: infos.length,
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
        onTap: (index) {
          try {
            launchcaller(infos[index].action);
          } catch (id) {}
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.subView, this.minHeight, this.maxHeight);

  final Widget subView;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: subView,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
