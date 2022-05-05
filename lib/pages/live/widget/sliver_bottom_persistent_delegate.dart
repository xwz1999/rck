import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class SliverBottomPersistentDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  SliverBottomPersistentDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(top: rSize(10)),
      color: AppColor.frenchColor,
      child: Container(
        color: Colors.white,
        height: rSize(48),
        child: tabBar,
      ),
    );
  }

  @override
  double get maxExtent => rSize(58);

  @override
  double get minExtent => rSize(58);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
