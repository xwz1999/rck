/*
 * ====================================================
 * package   : pages.home.classify
 * author    : Created by nansi.
 * time      : 2019/5/9  4:37 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/daos/home_dao.dart';
import 'package:recook/models/category_list_model.dart';
import 'package:recook/models/country_list_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/sc_grid_view.dart';
import 'package:recook/widgets/sc_tab_bar.dart';

import 'classify_category_page.dart';
import 'goods_import_list_page.dart';

class ClassifyCountryPage extends StatefulWidget {
  final List<CountryListModel> data;
  ClassifyCountryPage({Key key, this.data}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ClassifyCountryPageState();
  }
}

class _ClassifyCountryPageState extends BaseStoreState<ClassifyCountryPage>
    with TickerProviderStateMixin {
  PageController _controller = PageController();
  TabBarController _tabController = TabBarController();
  List<CountryListModel> countryListModelList = [];
  int currentIndex = 0;
  String _searchText = '';
  int countryIndex = 0;
  bool countryBool = true;

  bool animating = false;
  TextEditingController _textEditController;
  // FocusNode _contentFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    countryListModelList = widget.data;
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    print("---");
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.data != null ? _buildTitle() : SizedBox(),
        // leading: Container(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: countryListModelList == null
          ? noDataView('没有获取到进口专区的数据')
          : _buildContent(),
    );
  }

  Widget _buildTitle() {
    return Container(
        // margin: EdgeInsets.only(right: rSize(10)),
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.search,
                size: 20,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                //autofocus: true,
                keyboardType: TextInputType.text,
                controller: _textEditController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_submitted) {
                  //_contentFocusNode.unfocus();

                  setState(() {});
                },
                //focusNode: _contentFocusNode,
                onChanged: (text) async {
                  _searchText = text;

                  countryListModelList =
                      await HomeDao.findCountryList(_searchText);
                  setState(() {});
                  if (_getcountrybool()) {
                    print(countryBool);
                    _tabController.jumpToIndex(_getcountryindex());
                    _controller.animateToPage(_getcountryindex(),
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  }
                },
                placeholder: "请输入想要搜索的国家",
                placeholderStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
                decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
                style: TextStyle(
                    color: Colors.black,
                    textBaseline: TextBaseline.ideographic),
              ),
            )
          ],
        ));
  }

  _buildContent() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(flex: 1, child: _buildLeft()),
          Expanded(
              flex: 3,
              child: countryBool ? _buildRight() : noDataView('没有找到您想搜索的国家')),
        ],
      ),
      color: Color(0xFFF9F9FB),
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
      items: countryListModelList.map((item) {
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
          style: AppTextStyle.generate(14 * 2.sp),
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

  _getcountryindex() {
    if (countryListModelList != null) {
      for (var i = 0; i < countryListModelList.length; i++) {
        if (countryListModelList[i].children.length > 0) {
          countryIndex = i;
          break;
        }
      }
    }
    return countryIndex;
  }

  _getcountrybool() {
    if (countryListModelList != null) {
      for (var i = 0; i < countryListModelList.length; i++) {
        if (countryListModelList[i].children.length > 0) {
          return countryBool = true;
        }
      }
      return countryBool = false;
    }
  }

  double padding = 0;

  _buildRight() {
    double statusBarHeight = DeviceInfo.statusBarHeight;
    double appbarHeight = 56.0;

    return PageView.builder(
        itemCount: countryListModelList.length,
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return NotificationListener(
              child: buildGridView(appbarHeight, statusBarHeight, index),
              onNotification: (ScrollUpdateNotification notification) {
                if (animating) return true;

                if (currentIndex < countryListModelList.length - 1 &&
                    notification.metrics.pixels.toInt() >
                        (notification.metrics.maxScrollExtent + 120).toInt()) {
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
    List<Country> secondCategories = countryListModelList[index].children;
    String firstTitle = countryListModelList[index].name;
    return SCGridView(
        viewportHeight:
            DeviceInfo.screenHeight - appbarHeight - statusBarHeight + 5,
        crossAxisCount: 3,
        sectionCount: 1,
        childAspectRatio: 0.9,
        itemCount: (section) {
          return countryListModelList[index].children.length;
        },
        // headerBuilder: (context, section) {
        //   return Container(
        //     // color: Colors.blueGrey,
        //     // height: rSize(48),
        //     height: ScreenAdapterUtils.setWidth(DeviceInfo.screenWidth / 4),
        //     child: CustomCacheImage(
        //         width: ScreenAdapterUtils.setWidth(DeviceInfo.screenWidth / 4),
        //         height:
        //             ScreenAdapterUtils.setWidth(DeviceInfo.screenWidth / 4 * 3),
        //         imageUrl: Api.getImgUrl(widget.data[index].icon)),
        //   );
        // },
        itemBuilder: (context, indexIn) {
          Country secondCategory = secondCategories[indexIn];
          return CustomImageButton(
            icon: CustomCacheImage(
                height: rSize(50),
                width: rSize(50),
                imageUrl: Api.getImgUrl(secondCategory.icon)),
            title: secondCategory.name,
            contentSpacing: rSize(5),
            fontSize: 14 * 2.sp,
            onPressed: () async {
              // AppRouter.push(context, RouteName.GOODS_LIST_PAGE,
              //     arguments: GoodsImportListPage.setArguments(
              //         title: firstTitle,
              //         index: indexIn,
              //         secondCategoryList: secondCategories));
              print(secondCategory.id);
              List<CategoryListModel> categoryListModelList;
              categoryListModelList =
                  await HomeDao.getCategoryList(secondCategory.id);

              Get.to(ClassifyCategoryPage(data: categoryListModelList,countryId:secondCategories[indexIn].id));
            },
          );
        });
  }
}
