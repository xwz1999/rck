import 'dart:ui';

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/login/login_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/toast.dart';

class RechargePageThird extends StatefulWidget {

  final String? amount;
  final String? time;
  final String? logisticsNumber;
  final String? licenseFiles;

  RechargePageThird({
    Key? key, this.amount, this.time, this.logisticsNumber, this.licenseFiles,
  }) : super(key: key);

  @override
  _RechargePageThirdState createState() => _RechargePageThirdState();
}

class _RechargePageThirdState extends State<RechargePageThird>
    with TickerProviderStateMixin {

  List images = [];

  @override
  void initState() {
    super.initState();
    images = widget.licenseFiles!.split(';');

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF3A3842),
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          appBackground: Color(0xFF3A3842),
          leading: RecookBackButton(
            white: true,
          ),
          elevation: 0,
          title: Text(
            "预存款充值",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.rsp,
            ),
          ),
        ),
        body: _bodyWidget());
  }

  _bodyWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.rw),
          child: Container(
            padding: EdgeInsets.only(top: 12.rw, bottom: 12.rw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.rw),
                  topRight: Radius.circular(8.rw)),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                32.wb,
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep1Red.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "开发票",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGotoRed.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep2Red.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "申请提现",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGotoRed.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep3Red.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "平台审核",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep4.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "打款到账",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                32.wb,
              ],
            ),
          ),
        ),
        Container(
          child: Stack(
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: new Container(
                    color: Colors.white.withOpacity(0.1),
                    width: double.infinity,
                    height: 56.rw,
                  ),
                ),
              ),
              Container(
                height: 56.rw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    32.wb,
                    Text(
                      "如有疑问，点击联系客服",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.rsp,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async{
                        // WholesaleCustomerModel? model =
                        // await WholesaleFunc.getCustomerInfo();
                        //
                        // Get.to(() => WholesaleCustomerPage(
                        //   model: model,
                        // ));
                        if (UserManager.instance!.user.info!.id == 0) {
                          Get.offAll(() => LoginPage());
                          Toast.showError('请先登录...');
                          return;
                        }
                        BytedeskKefu.startWorkGroupChat(context, AppConfig.WORK_GROUP_WID, "客服");
                      },
                      child: Container(
                        height: 32.rw,
                        width: 32.rw,
                        padding: EdgeInsets.all(7.rw),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.rw)),
                        child: Image.asset(
                          Assets.icKefu.path,
                          width: 18.rw,
                          height: 18.rw,
                        ),
                      ),
                    ),
                    32.wb,
                  ],
                ),
              ),
            ],
          ),
        ),
        20.hb,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.rw),
          child: Container(
            width: double.infinity,

            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.rw)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw,right: 16.rw),
                  child: _textItem('充值金额',widget.amount!,isRed:true),
                ),
                35.hb,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.wb,
                  SizedBox(
                    width: 60.rw,
                    child: Text(
                      '汇款凭证',
                      style: TextStyle(
                        color: Color(0xFF333333),

                        fontSize: 14.rsp,
                      ),
                    ),
                  ),
                  16.wb,
                  Flexible(child:
                  Padding(
                    padding:  EdgeInsets.only(right:16.rw ),
                    child: GridView.builder(
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: images.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: rSize(10),
                            mainAxisSpacing: rSize(10),
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              List<PicSwiperItem> picSwiperItem = [];
                              images.forEach((element) {
                                picSwiperItem.add(PicSwiperItem(Api.getImgUrl(element)));
                              });
                              //
                              // AppRouter.fade(
                              //   context,
                              //   RouteName.PIC_SWIPER,
                              //   arguments: PicSwiper.setArguments(
                              //     index: index,
                              //     pics: picSwiperItem,
                              //   ),
                              // );
                              Get.to(()=>PicSwiper(arguments: PicSwiper.setArguments(
                                index: index,
                                pics: picSwiperItem,
                              )));
                            },
                            child:         Container(
                                margin: EdgeInsets.only(top: 5),
                                width: 48,
                                height: 48,
                                child: FadeInImage.assetNetwork(
                                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                  image: Api.getImgUrl(
                                      images[index],)!,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset(Assets.placeholderNew1x1A.path,);
                                  },
                                )),
                          );

                        }),
                  )
          ),
                ],
              ),
                35.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw,right: 16.rw),
                  child: _textItem('申请时间',widget.time!),
                ),
                35.hb,
              ],
            ),
          ),
        ),

      ],
    );
  }

  _textItem(String title, String content,{bool isRed = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60.rw,
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFF333333),

              fontSize: 14.rsp,
            ),
          ),
        ),
        16.wb,
        Expanded(
          child: Text(
            content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.4,
              color:isRed?Color(0xFFD5101A) :Color(0xFF333333),
              fontSize: 14.rsp,

            ),
          ),
        ),
      ],
    );
  }

}
