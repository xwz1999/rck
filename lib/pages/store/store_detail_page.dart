/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/5  11:00 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/store/modify_info_page.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';

class StoreDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoreDetailPageState();
  }
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  List<_InfoModel> _infoModels = [];

  @override
  void initState() {
    super.initState();
    _infoModels
      ..add(_InfoModel("店名", "小卷毛杂货店", ""))
      ..add(_InfoModel("店铺签名", "不会ps的前端不是好商家", ""))
      ..add(_InfoModel("店铺Logo", "小卷毛杂货店",
          "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559711939336&di=b0d64520f7da02b6667dffdd75d8a613&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201506%2F16%2F20150616143732_PJ8Xf.jpeg"))
      ..add(_InfoModel("店铺介绍", "主营日化百货，品质生活", ""))
      ..add(_InfoModel("店招", "小卷毛杂货店",
          "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559711896703&di=f581d59f81066775195d8b6bb0d91713&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201704%2F02%2F20170402184902_E3iW8.jpeg"))
      ..add(_InfoModel("微信名片", "", ""))
      ..add(_InfoModel("店铺升级规则", "小卷毛杂货店", ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        title: "店铺信息",
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: ListView.builder(
          itemCount: _infoModels.length,
          itemBuilder: (_, index) {
            return _normalTile(_infoModels[index], index);
          }),
    );
  }

  _normalTile(_InfoModel info, int index) {
    if (index == 4 || index == 2) {
      return _imageTile(info, 25.0 * index);
    }
    return Container(
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                info.title,
                style: AppTextStyle.generate(15, fontWeight: FontWeight.w400),
              )),
              Text(
                info.value,
                style: AppTextStyle.generate(15,
                    color: Colors.grey[700], fontWeight: FontWeight.w400),
              ),
              Container(
                width: 5,
              ),
              Icon(
                AppIcons.icon_next,
                color: Colors.grey[500],
                size: 16,
              ),
            ],
          ),
        ),
        onPressed: () {
          AppRouter.push(context, RouteName.MODIFY_DETAIL_PAGE,
                  arguments:
                      ModifyInfoPage.setArguments(info.title, info.value))
              .then((value) {
            if (value != null) {
              info.value = value;
            }
          });
//          ActionSheet.show(context, items: ["拍照", "从相册选择"], subTitles: ["选一个呗"]);
        },
      ),
    );
  }

  _imageTile(_InfoModel info, double maxSize) {
    return Container(
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                info.title,
                style: AppTextStyle.generate(15, fontWeight: FontWeight.w400),
              )),
              Container(
                constraints:
                    BoxConstraints(maxHeight: maxSize, maxWidth: maxSize),
                child: CustomCacheImage(imageUrl: info.imgUrl),
              ),
              Container(
                width: 5,
              ),
              Icon(
                AppIcons.icon_next,
                color: Colors.grey[500],
                size: 16,
              ),
            ],
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}

class _InfoModel {
  String title;
  String value;
  String imgUrl;

  _InfoModel(this.title, this.value, this.imgUrl);
}
