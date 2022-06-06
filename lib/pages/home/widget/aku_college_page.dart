import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/home/function/home_fuc.dart';
import 'package:recook/pages/home/model/aku_video_list_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'aku_college_detail_page.dart';

class AkuCollegePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AkuCollegePageState();
  }
}

class _AkuCollegePageState extends BaseStoreState<AkuCollegePage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  TextEditingController? _textEditController;
  AkuVideoListModel? _akuVideoListModel;
  List<AkuVideo>? _akuVideoList;
  String? _searchText;
  int page = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.tableViewGrayColor,
      appBar: CustomAppBar(

        appBackground: Colors.transparent,
        leading: RecookBackButton(
          white: true,
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(child: Container(
            height: 130.rw+DeviceInfo.statusBarHeight! + DeviceInfo.appBarHeight,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(R.ASSETS_SCHOOL_BG_PNG),
                    fit: BoxFit.fill)),
          )),

          _bodyWidget(),
        ],



      ),
      // appBar: PreferredSize(
      //
      //   child: Stack(
      //     children: [
      //       Image.asset(
      //         R.ASSETS_SCHOOL_TOP_BG_PNG,
      //         fit: BoxFit.cover,
      //         width: double.infinity,
      //       ),
      //
      //       AppBar(
      //         backgroundColor: Colors.transparent,
      //         elevation: 0,
      //         centerTitle: true,
      //         title: SizedBox(),
      //       ),
      //     ],
      //   ),
      //   preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
      // ),
      //body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Column(
      children: [
        // GestureDetector(
        //   onTap: () {},
        //   child: Container(
        //     width: double.infinity,
        //     height: 160.rw,
        //     child: Image.asset(
        //       R.ASSETS_SCHOOL_BG_PNG,
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        // 50.hb,
        Container(
          height:  160.rw+DeviceInfo.statusBarHeight! + DeviceInfo.appBarHeight
        ),

        Container(
            alignment: Alignment.center,
            width: 260.rw,
            height: 40.rw,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  color: Color(0x45B4B1B1),
                  blurRadius: 4.rw,
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(13.rw)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    keyboardType: TextInputType.text,
                    controller: _textEditController,
                    //textInputAction: TextInputAction.search,
                    onChanged: (text) async {

                      _searchText = text;
                      _akuVideoListModel =
                          await HomeFuc.getAkuVideoList(_searchText, page);

                      setState(() {});

                    },
                    placeholder: "搜一下是否有您想要的内容",
                    placeholderStyle: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14.rsp,
                        fontWeight: FontWeight.w300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.rw)),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 16.rsp),
                  ),
                ),
                Container(
                  width: 1.rw,
                  height: 27.rw,
                  color: Color(0xFFEEEDED),
                ),
                Container(
                  width: 37.rw,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    Icons.search,
                    size: 18.rw,
                    color: Color(0xFFC92219),
                  ),
                ),
              ],
            )),
        _buildListView(),
      ],
    );
  }

  _buildListView() {
    return Container(
            margin: EdgeInsets.only(left: 8.rw, right: 8.rw, top: 26.rw),
            child: RefreshWidget(
                controller: _refreshController,
                noData: '没有找到您想要的内容',
                onRefresh: () async {
                  //Function cancel = ReToast.loading();

                  _akuVideoListModel =
                      await HomeFuc.getAkuVideoList(_searchText, page);

                  setState(() {});
                  _refreshController.refreshCompleted();
                  //cancel();
                },
                onLoadMore: () async {
                  if (_akuVideoListModel!.list!.length >=
                      _akuVideoListModel!.total!) {
                    _refreshController.loadComplete();
                    _refreshController.loadNoData();
                  } else {
                    _akuVideoListModel =
                        await HomeFuc.getAkuVideoList(_searchText, page++);
                    _refreshController.loadComplete();
                  }
                },
                body: _akuVideoListModel?.list != null
                    ? GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 170 / 162,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 17),
                        itemCount: _akuVideoListModel!.list!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return
                              // Container(
                              //   color: Colors.red,
                              // );
                              _akuVideoItem(_akuVideoListModel!.list![index]);
                        },
                      )
                    : noDataView('没有找到您想要的内容')))
        .expand();
  }

  _akuVideoItem(AkuVideo akuVideo) {
    return Container(
      margin: EdgeInsets.only(left: 4.rw, right: 4.rw, top: 4.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.rw),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDBDBDB),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              //跳转页面
              Get.to(AkuCollegeDetailPage(akuVideo: akuVideo));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(4.rw),
                    ),
                    child: CustomCacheImage(
                      borderRadius: BorderRadius.circular(4.rw),
                      imageUrl: Api.getImgUrl(akuVideo.coverUrl),
                      height: 90.rw,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                akuVideo.type == 1
                    ? Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Icon(CupertinoIcons.play_circle,
                            size: 50, color: Colors.white),
                      )
                    : SizedBox()
              ],
            ),
          ),
          10.hb,
          Row(
            children: [
              16.wb,
              Text(
                akuVideo.title!,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.rsp,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              ).expand(),
              16.wb,
            ],
          ),
          Spacer(),
          Row(
            children: [
              16.wb,
              Text(akuVideo.subTitle!,
                  style: TextStyle(fontSize: 10.rsp, color: Color(0xFF333333))),
              Spacer(),
              Text(akuVideo.numberOfHits.toString() + '人看过',
                  style: TextStyle(fontSize: 10.rsp, color: Color(0xFF999999))),
              16.wb,
            ],
          ),
          20.hb,
        ],
      ),
    );
  }

}
