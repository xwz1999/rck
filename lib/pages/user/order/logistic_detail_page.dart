/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-19  16:33 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/logistic_list_model.dart';
import 'package:recook/pages/user/items/item_logistic_detail.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class LogisticDetailPage extends StatefulWidget {
  final Map arguments;

  const LogisticDetailPage({Key key, this.arguments}) : super(key: key);

  static setArguments({@required LogisticDetailModel detailModel}) {
    return {"detailModel": detailModel};
  }

  @override
  State<StatefulWidget> createState() {
    return _LogisticDetailPageState();
  }
}

class _LogisticDetailPageState extends BaseStoreState<LogisticDetailPage> {
  LogisticDetailModel _model;

  @override
  void initState() {
    super.initState();
    _model = widget.arguments["detailModel"];
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "物流详情",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      backgroundColor: AppColor.tableViewGrayColor,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin:
                EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(8)),
            padding:
                EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(8)),
            height: rSize(100),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(rSize(8)))),
            child: Row(
              children: <Widget>[
                CustomCacheImage(
                  width: rSize(84),
                  height: rSize(84),
                  fit: BoxFit.cover,
                  imageUrl: Api.getImgUrl(_model.picUrls[0]),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Text(
                      "承运公司: ${_model.name}",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                          color: Colors.grey[600]),
                    ),
                    Spacer(),
                    Text(
                      "快递单号: ${_model.no}",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                          color: Colors.grey[600]),
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin:
                EdgeInsets.symmetric(vertical: rSize(3), horizontal: rSize(8)),
            padding:
                EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(8)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(rSize(8)))),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _model.data.length,
                itemBuilder: (_, index) {
                  return LogisticDetailItem(
                    expressStatus: _model.data[index],
                    firstItem: index == 0,
                    lastItem: index == _model.data.length - 1,
                  );
                }),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: ScreenUtil.bottomBarHeight,
          ),
        )
      ],
    );
  }
}
