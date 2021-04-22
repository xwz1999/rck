import 'package:flutter/material.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/scan_result_model.dart';
import 'package:recook/pages/home/widget/plus_minus_view.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/const/resource.dart';

class QRScarerResultPage extends StatefulWidget {
  final String code;
  QRScarerResultPage({Key key, this.code}) : super(key: key);

  @override
  _QRScarerResultPageState createState() => _QRScarerResultPageState();
}

class _QRScarerResultPageState extends State<QRScarerResultPage> {
  ScanResultModel _scanResultModel;
  bool _onload = true;
  GSRefreshController _refreshController;
  int _goodsCount = 1;
  @override
  void initState() {
    super.initState();
    _refreshController = GSRefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '扫码购物',
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          _scanResultModel = await _getScanModel();
          if (_scanResultModel != null) {
            _onload = false;
          } else {
            ReToast.err(text: '未获取数据');
          }
          setState(() {});
        },
        body: _onload
            ? emptyWidget()
            : ListView(
                padding: EdgeInsets.symmetric(vertical: 22.w, horizontal: 20.w),
                children: [_goodsCard(_scanResultModel)],
              ),
      ),
      bottomNavi: Row(
        children: [_shopButton().expand(), 2.widthBox, _buyButton().expand()],
      )
          .pSymmetric(h: 32.w)
          .box
          .color(Colors.white)
          .padding(EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight))
          .width(double.infinity)
          .height(128.w)
          .make(),
    );
  }

  Widget _goodsCard(ScanResultModel model) {
    return Column(
      children: [
        Row(
          children: [
            FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: model.brandImg,
              width: 44.w,
              height: 44.w,
            ),
            20.w.widthBox,
            model.brandName.text
                .size(28.sp)
                .color(Color(0xFF0A0001))
                .bold
                .make(),
          ],
        ),
        26.w.heightBox,
        Row(
          children: [
            FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: model.brandImg,
              width: 200.w,
              height: 200.w,
              fit: BoxFit.contain,
            ),
            20.w.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                model.goodsName.text
                    .size(28.sp)
                    .bold
                    .color(Color(0xFF141414))
                    .maxLines(2)
                    .overflow(TextOverflow.ellipsis)
                    .make(),
                10.w.heightBox,
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFEFF1F6),
                      borderRadius: BorderRadius.circular(4.w)),
                  padding: EdgeInsets.all(10.w),
                  child: '${model.skuName}'
                      .text
                      .color(Color(0xFF666666))
                      .size(20.sp)
                      .make(),
                ),
                30.w.heightBox,
                Row(
                  children: [
                    '¥'
                        .richText
                        .withTextSpanChildren([
                          '${model.discount.toStringAsFixed(0)}.'
                              .textSpan
                              .size(36.sp)
                              .color(Color(0xFFC92219))
                              .bold
                              .make(),
                          ((model.discount.toDouble() -
                                      model.commission.toInt()) *
                                  100)
                              .toStringAsFixed(0)
                              .textSpan
                              .color(Color(0xFFC92219))
                              .size(24.sp)
                              .bold
                              .make()
                        ])
                        .color(Color(0xFFC92219))
                        .size(24.sp)
                        .bold
                        .make(),
                    8.w.widthBox,
                    '赚:${model.commission.toStringAsFixed(2)}'.text.color(Color(0xFFC92219)).size(24.sp).make()
                    // Spacer(),
                    // PlusMinusView(
                    //   onValueChanged: (value) {
                    //     _goodsCount = value;
                    //     setState(() {});
                    //   },
                    //   initialValue: 1,
                    //   onInputComplete: (text) {
                    //     _goodsCount = int.parse(text);
                    //   },
                    // )
                  ],
                )
              ],
            ),
          ],
        )
      ],
    )
        .box
        .padding(EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.w))
        .withRounded(value: 10.w)
        .width(double.infinity)
        .color(Colors.white)
        .make();
  }

  Widget emptyWidget() {
    return Container();
  }

  Future _getScanModel() async {
    ResultData resultData =
        await HttpManager.post(APIV2.userAPI.getScanResult, {
      "skuCode": widget.code,
    });
    if (resultData.data == null) {
      ReToast.err(text: resultData.msg);
      return;
    } else {
      return ScanResultModel.fromMap(resultData.data['data']);
    }
  }

  Widget _buyButton() {
    return CustomImageButton(
      title: "立即购买",
      color: Colors.white,
      height: 80.w,
      boxDecoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xffc81a3e), Color(0xfffa4968)]),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      fontSize: 32.sp,
      onPressed: () {},
    );
  }

  Widget _shopButton() {
    return CustomImageButton(
      title: "加入购物车",
      color: Colors.white,
      height: 80.w,
      boxDecoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff979797), Color(0xff5d5e5d)]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
      fontSize: 32.sp,
      onPressed: () {},
    );
  }
}
