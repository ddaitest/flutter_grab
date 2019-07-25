import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'manager/beans.dart';
import 'test.dart';

class TestSilverState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
//        SliverPersistentHeader(
//          delegate: _SliverAppBarDelegate(
//            TabBar(
//              labelColor: Colors.black87,
//              unselectedLabelColor: Colors.grey,
//              tabs: [
//                Tab(icon: Icon(Icons.info), text: "Tab 1"),
//                Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
//              ],
//            ),
//          ),
//          pinned: false,
//          floating: true,
//        ),
//        SliverToBoxAdapter(
//          child: _getTestBanner(),
//        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
              Container(
                height: 120,
                color: Colors.orange,
                child: Text("HAHAHA"),
              ),
              120,
              120),
          pinned: false,
          floating: true,
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(_getTestBanner(), 120, 120),
          pinned: false,
          floating: false,
        ),

        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.grey[100]),
              Container(color: Colors.grey[200]),
              Container(color: Colors.grey[300]),
              Container(color: Colors.grey[400]),
              Container(color: Colors.grey[500]),
              Container(color: Colors.grey[600]),
              Container(color: Colors.grey[700]),
              Container(color: Colors.grey[800]),
              Container(color: Colors.grey[100]),
              Container(color: Colors.grey[200]),
              Container(color: Colors.grey[300]),
              Container(color: Colors.grey[400]),
              Container(color: Colors.grey[500]),
              Container(color: Colors.grey[600]),
              Container(color: Colors.grey[700]),
              Container(color: Colors.grey[800]),
            ],
          ),
        ),
      ]),
    );
  }

  _getTestBanner() {
    BannerInfo b1 = BannerInfo(
        image:
        "https://img.zcool.cn/community/01a82c5711fd566ac7251343a63c56.jpg");
    BannerInfo b2 = BannerInfo(
        image:
        "https://img.zcool.cn/community/01b0595711fd566ac725134316ff68.jpg");
    BannerInfo b3 = BannerInfo(
        image:
        "https://img.zcool.cn/community/01f6155711fd5632f8758c9b02edfe.jpg");
    return _getBannerView([b1, b2, b3]);
  }

  _getBannerView(List<BannerInfo> infos) {
    return Container(
      height: 120,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image(
            image: new CachedNetworkImageProvider(infos[index].image),
            fit: BoxFit.fitWidth,
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
//            launchcaller(infos[index].action);
          } catch (id) {}
        },
      ),
    );
  }
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