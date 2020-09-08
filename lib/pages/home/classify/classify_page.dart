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
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/daos/home_dao.dart';
import 'package:recook/models/category_model.dart';
import 'package:recook/pages/home/classify/goods_list_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/sc_grid_view.dart';
import 'package:recook/widgets/sc_tab_bar.dart';
import 'package:recook/widgets/toast.dart';

class ClassifyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClassifyPageState();
  }
}

class _ClassifyPageState extends BaseStoreState<ClassifyPage>
    with TickerProviderStateMixin {
  PageController _controller = PageController();
  TabBarController _tabController = TabBarController();
  List<FirstCategory> _data;

  int currentIndex = 0;

  bool animating = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    HomeDao.getCategories(success: (data, code, msg) {
      setState(() {
        _data = data;
      });
    }, failure: (code, msg) {
      Toast.showError(msg);
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
      body: _data == null ? _blankView() : _buildContent(),
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
          AppRouter.push(context, RouteName.SEARCH);
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
            fontSize: ScreenAdapterUtils.setSp(15),
            fontWeight: FontWeight.w400),
      ),
    );
  }

  _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(flex: 1, child: _buildLeft()),
        Expanded(flex: 3, child: _buildRight()),
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
      spacing: rSize(20),
      items: _data.map((item) {
        return item.name;
      }).toList(),
      itemBuilder: (context, index, item) {
        // Color color;
        // if (index == currentIndex) {
        //   color = Colors.red;
        // } else {
        //   color = Colors.black87;
        // }
        return Container(
            child: Center(
                child: Text(
          item,
          style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14)),
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
        itemCount: _data.length,
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return NotificationListener(
              child: buildGridView(appbarHeight, statusBarHeight, index),
              onNotification: (ScrollUpdateNotification notification) {
                if (animating) return true;

                if (currentIndex < _data.length - 1 &&
                    notification.metrics.pixels.toInt() >
                        notification.metrics.maxScrollExtent + 120) {
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
    List<SecondCategory> secondCategories = _data[index].sub;
    String first_title = _data[index].name;
    return SCGridView(
        viewportHeight:
            DeviceInfo.screenHeight - appbarHeight - statusBarHeight + 5,
        crossAxisCount: 3,
        sectionCount: 1,
        childAspectRatio: 0.9,
        itemCount: (section) {
          return _data[index].sub.length;
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
                imageUrl: Api.getImgUrl(_data[index].logoUrl)),
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
            fontSize: ScreenAdapterUtils.setSp(14),
            onPressed: () {
              AppRouter.push(context, RouteName.GOODS_LIST_PAGE,
                  arguments: GoodsListPage.setArguments(
                      title: first_title,
                      index: indexIn,
                      secondCategoryList: secondCategories));
            },
          );
        });
  }
}
