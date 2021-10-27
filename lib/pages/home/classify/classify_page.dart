/*
 * ====================================================
 * package   : pages.home.classify
 * author    : Created by nansi.
 * time      : 2019/5/9  4:37 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/category_model.dart';
import 'package:recook/pages/home/classify/goods_list_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/sc_grid_view.dart';
import 'package:recook/widgets/sc_tab_bar.dart';

import '../search_page.dart';

class ClassifyPage extends StatefulWidget {
  final List<FirstCategory> data;
  final String initValue;
  final int jdType;//1为京东商品 空为非jd
  ClassifyPage({Key key, @required this.data, this.initValue, this.jdType})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ClassifyPageState();
  }
}

class _ClassifyPageState extends BaseStoreState<ClassifyPage>
    with TickerProviderStateMixin {
  PageController _controller = PageController();
  TabBarController _tabController = TabBarController();

  int currentIndex = 0;

  bool animating = false;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      int current =
          widget.data.indexWhere((element) => element.name == widget.initValue);
      currentIndex = current == -1 ? 0 : current;
      _tabController.jumpToIndex(currentIndex);
      _controller.animateToPage(currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    print("---");
    return Scaffold(
      appBar: CustomAppBar(
        title: _buildTitle(),
        // leading: Container(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: widget.data == null ? _blankView() : _buildContent(),
    );
  }

  Widget _blankView() {
    return Center(
      child: Text(
        "正在加载中...",
        style: AppTextStyle.generate(16),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: MediaQuery.of(context).size.width - 110,
      height: 40,
      // padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xFFEDEDED),
      ),
      child: CustomImageButton(
        onPressed: () {
          //AppRouter.push(context, RouteName.SEARCH);
          Get.to(SearchPage(jdType: 1,));
        },
        direction: Direction.horizontal,
        icon: Container(
          width: 30,
          height: 20,
          child: Icon(
            Icons.search,
            size: 20,
            color: Colors.grey,
          ),
        ),
        title: "搜索商品",
        style: TextStyle(
            color: Colors.grey,
            fontSize: 15 * 2.sp,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(flex: 2, child: _buildLeft()),
        Expanded(flex: 7, child: _buildRight()),
      ],
    );
  }

  _buildLeft() {
    return SCTabBar<String>(
      controller: _tabController,
      initialIndex: 0,
      height: rSize(28),
      indicatorLocation: IndicatorLocation.left,
      indicatorHeight: rSize(4),
      direction: Axis.vertical,
      spacing: rSize(30),
      items: widget.data.map((item) {
        return item.name;
      }).toList(),
      itemBuilder: (context, index, item) {
        Color color;
        if (index == currentIndex) {
          color = Colors.red;
        } else {
          color = Colors.black87;
        }
        return Container(
            child: Center(
                child: Text(

          item,
          style: AppTextStyle.generate(14 * 2.sp,color: color),
          textAlign: TextAlign.center,
        )));
      },
      itemClick: (index) {
        currentIndex = index;
        _controller.animateToPage(currentIndex,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      },
    );
  }

  double padding = 0;

  _buildRight() {
    double statusBarHeight = DeviceInfo.statusBarHeight;
    double appbarHeight = 56.0;

    return PageView.builder(
        itemCount: widget.data.length,
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return NotificationListener(
              child: buildGridView(appbarHeight, statusBarHeight, index),
              onNotification: (ScrollUpdateNotification notification) {
                if (animating) return true;

                if (currentIndex < widget.data.length - 1 &&
                    notification.metrics.pixels.toInt() >
                      ( notification.metrics.maxScrollExtent + 120).toInt()) {
                  if (!animating) {
                    animating = true;
                    currentIndex++;
                    _controller
                        .animateToPage(currentIndex,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear)
                        .then((value) {
                      animating = false;
                      setState(() {
                        _tabController.jumpToIndex(currentIndex);
                      });
                    });
                  }
                }

                if (currentIndex > 0 &&
                    notification.metrics.pixels.toInt() <
                        notification.metrics.minScrollExtent - 120) {
                  if (!animating) {
                    animating = true;
                    currentIndex--;
                    _controller
                        .animateToPage(currentIndex,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear)
                        .then((value) {
                      animating = false;
                      setState(() {
                        _tabController.jumpToIndex(currentIndex);
                      });
                    });
                  }
                }
                return true;
              });
        });
  }

  SCGridView buildGridView(
      double appbarHeight, double statusBarHeight, int index) {
    List<SecondCategory> secondCategories = widget.data[index].sub;
    String firstTitle = widget.data[index].name;
    return SCGridView(
        viewportHeight:
            DeviceInfo.screenHeight - appbarHeight - statusBarHeight + 5,
        crossAxisCount: 3,
        sectionCount: 1,
        childAspectRatio: 0.9,
        itemCount: (section) {
          return widget.data[index].sub.length;
        },
        headerBuilder: (context, section) {
          return Container(
            // color: Colors.blueGrey,
            // height: rSize(48),
            height: ScreenAdapterUtils.setWidth(DeviceInfo.screenWidth / 4),
            child: CustomCacheImage(
                width: ScreenAdapterUtils.setWidth(DeviceInfo.screenWidth / 4),
                height:
                    ScreenAdapterUtils.setWidth(DeviceInfo.screenWidth / 4 * 3),
                imageUrl: Api.getImgUrl(widget.data[index].logoUrl)),
          );
        },
        itemBuilder: (context, indexIn) {
          SecondCategory secondCategory = secondCategories[indexIn];
          return CustomImageButton(
            icon: CustomCacheImage(
                height: rSize(50),
                width: rSize(50),
                imageUrl: Api.getImgUrl(secondCategory.logoUrl)),
            title: secondCategory.name,
            contentSpacing: rSize(5),
            fontSize: 13 * 2.sp,
            onPressed: () {
              AppRouter.push(context, RouteName.GOODS_LIST_PAGE,
                  arguments: GoodsListPage.setArguments(
                      title: firstTitle,
                      index: indexIn,

                      secondCategoryList: secondCategories,
                      isJD: widget.jdType==1?true:false));

            },
          );
        });
  }
}
