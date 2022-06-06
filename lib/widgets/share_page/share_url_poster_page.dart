import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/share_page/share_invite_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../alert.dart';

class ShareUrlPosterPage extends StatefulWidget {
  final Map? arguments;
  ShareUrlPosterPage({Key? key, this.arguments}) : super(key: key);
  static setArguments({String url = ""}) {
    return {"url": url};
  }

  @override
  _ShareUrlPosterPageState createState() => _ShareUrlPosterPageState();
}

class _ShareUrlPosterPageState extends BaseStoreState<ShareUrlPosterPage>
    with TickerProviderStateMixin {
  ShareInvitaModal? _shareInvitaModal;
  TabController? _tabController;
  int _tabIndex = 0;
  @override
  void dispose() {
    _tabController!.removeListener(_handleTabControllerTick);
    super.dispose();
  }

  @override
  void initState() {
    _getPostImageList();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabControllerTick);
    super.initState();
  }

  void _handleTabControllerTick() {
    _tabIndex = _tabController!.index;
    setState(() {});
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "邀请",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
      ),
      bottomNavigationBar: _bottomWidget(),
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: AppColor.frenchColor,
            child: _shareInvitaModal == null
                ? loadingView()
                : Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _indicatorWidget(length: 3, index: _tabIndex),
                      ),
                      Expanded(
                        child: CacheTabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            _imageWidget(
                                _shareInvitaModal!.data!.data![0], context),
                            _imageWidget(
                                _shareInvitaModal!.data!.data![1], context),
                            _imageWidget(
                                _shareInvitaModal!.data!.data![2], context),
                            // FocusPage(),
                          ],
                        ),
                      )
                    ],
                  )
            // : CustomCacheImage(
            //   imageUrl: widget.arguments['url'],
            // ),
            ),
      ),
    );
  }

  _indicatorWidget({length = 1, index = 0}) {
    if (length < 1) {
      FlutterError("length !< 1");
      return Container();
    }
    if (index > (length - 1)) {
      FlutterError("index>lenght");
      return Container();
    }
    _indicator(bool isSelect) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.5),
          border: Border.all(color: AppColor.themeColor, width: 1),
          color: isSelect ? AppColor.themeColor : Colors.white,
        ),
      );
    }

    List<Widget> widgetList = [];
    for (var i = 0; i < length; i++) {
      widgetList.add(_indicator(i == index));
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgetList,
      ),
    );
  }

  _imageWidget(url, ctx) {
    return Container(
      // width: MediaQuery.of(ctx).size.width*0.6,
      padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: CustomCacheImage(
        imageUrl: url,
      ),
    );
  }

  _bottomWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      height: 60,
      child: CustomImageButton(
        onPressed: () {
          var cancel = ReToast.loading();
          ImageUtils.saveNetworkImagesToPhoto(
              [_shareInvitaModal!.data!.data![_tabIndex]], (index) {}, (success) {
            cancel();
            Navigator.pop(context);
            if (success) {
              ReToast.success(text: '图片已保存到相册');
            } else {
              Alert.show(
                context,
                NormalContentDialog(
                  title: '提示',
                  content: Text('图片保存失败，请前往应用权限页，设置存储权限为始终允许',style: TextStyle(color: Color(0xFF333333),fontSize: 14.rsp),),
                  items: ["取消"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                  deleteItem: "确认",
                  deleteListener: () async{

                    Alert.dismiss(context);
                    bool isOpened = await openAppSettings();
                  },
                  type: NormalTextDialogType.delete,
                ),
              );
            }
          });
        },
        boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColor.themeColor),
        title: "保存海报图片到相册",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  _getPostImageList() async {
    Response? res = await HttpManager.netFetchNormal(
        widget.arguments!['url'], null, null, null);
    try {
      Map map = json.decode(res.toString());
      _shareInvitaModal = ShareInvitaModal.fromJson(map as Map<String, dynamic>);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) showError(e.toString());
    }
  }
}
