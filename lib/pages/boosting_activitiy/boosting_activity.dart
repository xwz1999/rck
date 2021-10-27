import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'boosting_cut_down_time.dart';

class BooStingActivityPage extends StatefulWidget {
  BooStingActivityPage({
    Key key,
  }) : super(key: key);

  @override
  _BooStingActivityPageState createState() => _BooStingActivityPageState();
}

class _BooStingActivityPageState extends State<BooStingActivityPage>
    with TickerProviderStateMixin {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text(
          "助力活动",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(R.ASSETS_BOOSTING_BOOSTING_MAIN_BG_PNG),
                fit: BoxFit.fill)),
        child: Stack(
          children: [
            _textView(),
            _buildNestedScrollView(),
          ],
        )

      ),
    );
  }

  Widget _buildNestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(child: Container(height: 270.rw,)),
        ];
      },
      body: _buildRefreshScrollView(),
    );
  }

  Widget _buildRefreshScrollView() {
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Color(0xFFFFFFFF),Color(0xFFFF957D)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0,size.width,size.height));
    return Container(
      //margin: EdgeInsets.only(left: 6.rw, right: 6.rw),
      padding: EdgeInsets.only(left: 6.rw, right: 6.rw),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(6.rw),
      //   ),
      //   gradient: LinearGradient(
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     colors: [
      //       Color(0xFFFFCD53),
      //       Color(0xFFF43F53),
      //     ],
      //   ),
      // ),
      child: Stack(
        children: <Widget>[


          Container(
            child: RefreshWidget(
              //headerTriggerDistance: rSize(80),
              color: Colors.white,
              noData: '暂无助力活动',
              controller: _refreshController,
              onRefresh: () async {
                _refreshController.refreshCompleted();
              },
              body: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                // physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.rw),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.rw),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFFCD53),
                          Color(0xFFF43F53),
                        ],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding:
                          EdgeInsets.only(left: 10.rw, top: 10.rw, bottom: 10.rw),
                          child: Text(
                            "助力活动进行中",
                            style: TextStyle(
                                color: Color(0xFFEE2543),
                                fontSize: 18.rsp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        _inProgress(1),
                        _inProgress(2),
                        _inProgress(3),

                      ],
                    ),
                  ),
                  10.hb,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.rw),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.rw),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFD6E7C),
                          Color(0xFFF32143),
                          Color(0xFFFD6E7C),
                        ],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding:
                          EdgeInsets.only(left: 10.rw, top: 10.rw, bottom: 10.rw),
                          child: Text(
                            "即将开启",
                            style: TextStyle(
                                //color: Color(0xFFFF957D),
                                fontSize: 18.rsp,
                                foreground: Paint()..shader = shader,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        _noStart(),
                        _noStart(),
                        _noStart(),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  _textView() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            R.ASSETS_BOOSTING_BOOSTING_TEXT_PNG,
            width: 315.rw,
            height: 140.rw,
          ),
          margin: EdgeInsets.only(top: 30.rw),
        ),
        200.hb,
      ],
    );
  }

  _inProgress(int type) {
    //进行中的助力item
    return Container(
      margin: EdgeInsets.only(bottom: 10.rw),
      width: 350.rw,
      height: 185.rw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6.rw),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCacheImage(
                  borderRadius: BorderRadius.circular(5),
                  width: 135.rw,
                  height: 135.rw,
                  imageUrl: Api.getImgUrl(
                      '/photo/d172c416e5a0c9f0543c5b0b1c0b4fd6.jpg'),
                  fit: BoxFit.cover,
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _goodsName(),
                    _price(),
                    _progressbar(2),
                  ],
                ).expand()
              ],
            ),
          ),
          _bottomWidget(type)
        ],
      ),
    );
  }

  _noStart() {
    //进行中的助力item
    return Container(
      margin: EdgeInsets.only(bottom: 10.rw),
      width: 350.rw,
      height: 145.rw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6.rw),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment(0, .35),

          colors: [
            Color(0xFFFFE7EA),
            Colors.white

          ],
        ),
        color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //       color: Color(0xFFFFE7EA),
          //       offset: Offset(0.0, -15.0), //阴影xy轴偏移量
          //       blurRadius: 15.0, //阴影模糊程度
          //       spreadRadius: 1.0 //阴影扩散程度
          //   )
          // ],
      ),
      child:
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCacheImage(
                  borderRadius: BorderRadius.circular(5),
                  width: 135.rw,
                  height: 135.rw,
                  imageUrl: Api.getImgUrl(
                      '/photo/d172c416e5a0c9f0543c5b0b1c0b4fd6.jpg'),
                  fit: BoxFit.cover,
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _goodsName(),
                    _noStartPrice(),
                    Spacer(),
                    _noStartBtn(),
                    10.hb,
                  ],
                ).expand()
              ],
            ),
          ),


    );
  }

  _noStartBtn(){
    return Container(
      alignment: Alignment.center,
      width: 160.rw,
      height: 32.rw,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Color(0xFFF32A48)),
        borderRadius: BorderRadius.circular(20.rw),
        color: Color(0xFFF9DB8C),
      ),
      child: '9月20号开抢，享助力价'
          .richText
          .withTextSpanChildren([
        '20.9'.textSpan.size(14.rsp).bold.color(Color(0xFFF32143)).make(),

      ])
          .size(10.rsp)
          .bold
          .color(Color(0xFFF32143))
          .make(),
    );
  }

  _bottomWidget(int type) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.rw)),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFFFFE7EA),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Row(
        children: [
          25.wb,
          Image.asset(
            R.ASSETS_BOOSTING_BOOSTING_TIME_PNG,
            width: 14.rw,
            height: 18.rw,
          ),
          10.wb,
          Text(
            '2天',
            style: TextStyle(color: Colors.black, fontSize: 14.rsp),
          ),
          10.wb,
          BoostingCutDownTime(time: '20:15:00'),
          Spacer(),
          type==1?_btn():type==2?_sellOutBtn():_finishBtn(),
          10.wb,
        ],
      ),
    ).expand();
  }

  _btn() {

    return Container(
      padding: EdgeInsets.only(left: 7.rw),
      alignment: Alignment.center,
      width: 200.rw,
      height: 30.rw,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(R.ASSETS_BOOSTING_BOOSTING_BTN1_PNG),
              fit: BoxFit.fill)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '助力6人即可享受助力价',
            style: TextStyle(
                color: Color(0xFFF32143),
                fontSize: 10.rsp,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            '马上邀请!',
            style: TextStyle(color: Colors.white, fontSize: 10.rsp),
          ),
          30.wb,
        ],
      ),
    );
  }


  _sellOutBtn() {

    return Container(
      padding: EdgeInsets.only(left: 7.rw),
      alignment: Alignment.center,
      width: 200.rw,
      height: 30.rw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.rw)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFEB7447),
            Color(0xFFF32A48),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '不好意思客官您来晚了，商品已售罄',
            style: TextStyle(
                color: Colors.white,
                fontSize: 10.rsp,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }



  _finishBtn() {
    //还未开始的助力活动
    return GestureDetector(
      onTap: (){
        Alert.show(
            context,
            BoosTingDialog(
                title: '恭喜你助力完成！',
                price: '¥29.9',
                content: CustomCacheImage(
                  borderRadius: BorderRadius.circular(5),
                  width: 135.rw,
                  height: 135.rw,
                  imageUrl: Api.getImgUrl(
                      '/photo/d172c416e5a0c9f0543c5b0b1c0b4fd6.jpg'),
                  fit: BoxFit.cover,
                ),
                tips: '请您在指定时间内购买\n'+'    '+'否则活动价会失效',
                AlertItem: Container(
                  width: 238.rw,
                  height: 52.rw,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(29.rw)),
                    border: Border.all(color: Color(0xFFE3B43D),width: 2),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFEFADF),
                        Color(0xFFF5D67B),
                      ],
                    ),
                  ),
                  child: Text(
                    '前往活动页购买',
                    style: TextStyle(
                        color: Color(0xFF933800),
                        fontSize: 20.rsp,
                    ),
                  ),
                ),
                DeleteItem: GestureDetector(
                  onTap: (){
                    Alert.dismiss(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top:30.rw),
                    width: 40.rw,
                    height: 40.rw,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40.rw)),
                      border: Border.all(color: Colors.white,width: 1.5)
                    ),
                    child:  Icon(AppIcons.icon_delete,size: 20.rw,color: Colors.white,),
                  ),
                )
               )
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 7.rw),
        alignment: Alignment.center,
        width: 200.rw,
        height: 30.rw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.rw)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFEB7447),
              Color(0xFFF32A48),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '助力成功，仅需19.9元，请尽快下单！',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.rsp,
                  fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }

  _goodsName() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ExtendedText.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: CustomCacheImage(
                borderRadius: BorderRadius.circular(3),
                width: 24.rw,
                height: 15.rw,
                imageUrl: Api.getImgUrl('/photo/flag/中国.png'),
              ),
            ),
            TextSpan(
                text: '左家右厨多功能100米大容量雨伞',
                style: TextStyle(
                    fontSize: 15.rsp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A0001))
                // style: AppTextStyle.generate(15 * 2.sp,
                //     fontWeight: FontWeight.w600,),
                ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  _price() {
    return Container(
      margin: EdgeInsets.only(left: 8.rw),
      //padding: EdgeInsets.only(left: 8),
      // decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: AssetImage(R.ASSETS_BOOSTING_BOOSTING_PRICE_LINE_PNG),
      //         fit: BoxFit.fitWidth
      //     )
      // ),
      height: 55.rw,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              child: Image.asset(R.ASSETS_BOOSTING_BOOSTING_PRICE_LINE_PNG,
                  width: 180.rw, height: 30.rw, fit: BoxFit.fitHeight),
              top: 10),
          Positioned(
            child: Text(
              '原价39.90',
              style: TextStyle(color: Colors.black, fontSize: 10.rsp),
            ),
            top: 15,
            left: 0,
          ),
          Positioned(
            child: Text(
              '已售200件',
              style: TextStyle(color: Color(0xFF999999), fontSize: 10.rsp),
            ),
            top: 15,
            right: 0,
          ),
          Positioned(
              child: Text(
                '助力价',
                style: TextStyle(color: Color(0xFFF32A48), fontSize: 10.rsp),
              ),
              top: 40),
          Positioned(child: _boostingPrice(), top: 10),
        ],
      ),
    );
  }

  _noStartPrice(){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(

        children: [
          5.wb,
          Text(
            '原价¥19.90',
            style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
          ),
          Spacer(),
          Text(
            '已售200件',
            style: TextStyle(color: Color(0xFF666666), fontSize: 12.rsp),
          ),
          5.wb,
        ],
      ),
    );
  }

  _boostingPrice() {
    return Container(

        width: 39.rw,
        height: 18.rw,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(R.ASSETS_BOOSTING_BOOTSING_BUBBLE_PNG),
                fit: BoxFit.fill)),
        alignment: Alignment.center,
        child: Text(
          '¥19.90',
          style: TextStyle(color: Colors.white, fontSize: 10.rsp),
        ));
  }

  _spot(int num) {
    return Container(
      margin: EdgeInsets.only(
          left: ((6 - num) * (195.rw / 6) - 9.rw < 0
              ? 0
              : (6 - num) * (195.rw / 6) - 9.rw)),
      width: 9.rw,
      height: 9.rw,
      decoration: BoxDecoration(
          color: Color(0xFFDE0303),
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(4.5.rw))),
    );
  }

  _progressbar(int num) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: '还需要'
              .richText
              .withTextSpanChildren([
                '3'.textSpan.size(10.rsp).color(Color(0xFFDE0303)).make(),
                '位好友'.textSpan.size(10.rsp).color(Color(0xFF999999)).make()
              ])
              .size(10.rsp)
              .color(Color(0xFF999999))
              .make(),
          alignment: Alignment.centerRight,
        ),
        Container(
          margin: EdgeInsets.only(left: 8.rw),
          width: 195.rw,
          height: 9.rw,
          decoration: BoxDecoration(
              color: Color(0xFFECECEC),
              borderRadius: BorderRadius.all(Radius.circular(4.5.rw))),
          alignment: Alignment.centerLeft,
          child: Container(
              alignment: Alignment.centerLeft,
              width: ((6 - num) * (195.rw / 6) < 9.rw
                  ? 9
                  : (6 - num) * (195.rw / 6)),
              height: 9.rw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.5.rw)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFEE1B2),
                    Color(0xFFF21515),
                  ],
                ),
              ),
              child: _spot(num)),
        ),
      ],
    );
  }
}
