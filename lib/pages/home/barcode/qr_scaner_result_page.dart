import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class QRScarerResultPage extends StatefulWidget {
  QRScarerResultPage({Key key}) : super(key: key);

  @override
  _QRScarerResultPageState createState() => _QRScarerResultPageState();
}

class _QRScarerResultPageState extends State<QRScarerResultPage> {
  @override
  void initState() { 
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '扫码购物',
      body: ListView(
        children: [],
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
