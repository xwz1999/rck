import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_prepay_model.dart';
import 'package:jingyaoyun/models/order_preview_model.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/order_mvp/order_presenter_impl.dart';
import 'package:jingyaoyun/pages/home/classify/order_prepay_page.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:oktoast/oktoast.dart';

import 'package:velocity_x/velocity_x.dart';

import 'models/vip_card_model.dart';

class VipShopCardPage extends StatefulWidget {
  final bool goToBottom;

  VipShopCardPage({
    Key key, this.goToBottom = false,
  }) : super(key: key);

  @override
  _VipShopCardPageState createState() => _VipShopCardPageState();
}

class _VipShopCardPageState extends State<VipShopCardPage>
    with TickerProviderStateMixin {
  int _chooseIndex = 0;
  List<VipCardModel> _cardList = [];///4
  // List<VipCardModel> _haveNotList = [];///3
  OrderPresenterImpl _presenterImpl = OrderPresenterImpl();
  bool _isTap = true;
  ScrollController _controller = ScrollController();


  @override
  void initState() {
    super.initState();


    Future.delayed(Duration.zero,() async{
      _cardList = await WholesaleFunc.getVipCardList();
      if(!UserManager.instance.getSeven){
        _cardList.insert(0, VipCardModel(goodsId: 0,skuId: 0,skuName: '七日卡',discountPrice: 0,coupon: 0,effectDayType: 1,effectTime: 1));
      }

      setState(() {

      });
    });

      Future.delayed(Duration.zero,(){
        if(widget.goToBottom)
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });


    }

  _refresh() async {
    UserManager.instance.getSeven = await WholesaleFunc.get7();
    _cardList = await WholesaleFunc.getVipCardList();
    if(!UserManager.instance.getSeven){
      _cardList.insert(0, VipCardModel(goodsId: 0,skuId: 0,skuName: '七日卡',discountPrice: 0,coupon: 0,effectDayType: 1,effectTime: 1));
    }

    setState(() {

    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.transparent,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('VIP店铺体验卡',
            style: TextStyle(
              color: Color(0xFF070707),
              fontSize: 18.rsp,
            )),
      ),
      body: Stack(
        children: [
          Positioned(
              child: Image.asset(
            Assets.imgCardBg.path,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          )),
          _bodyWidget()
        ],
      ),
    );
  }

  _bodyWidget() {
    return ListView(
      controller: _controller,
      shrinkWrap: true,
      children: [
        Container(
          margin: EdgeInsets.only(left: 45.w, right: 45.w, top: 20.w),
          padding: EdgeInsets.only(left: 60.w, right: 50.w),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.imgCardTopBg.path),
                  fit: BoxFit.fill)),
          child: Row(
            children: [
              Image.asset(
                Assets.icCardVip.path,
                width: 44.rw,
                height: 44.rw,
              ),
              40.wb,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  62.hb,
                  Text(
                    'VIP店铺权益卡',
                    style:
                        TextStyle(color: Color(0xFF6A4A1D), fontSize: 20.rsp),
                  ),
                  14.hb,
                  Text(
                    '开通即享8大特权，惊喜福利等你解锁',
                    style:
                        TextStyle(color: Color(0xFF967A54), fontSize: 12.rsp),
                  ),
                  62.hb,
                ],
              )
            ],
          ),
        ),
        20.hb,
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF2F2F2F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.rw)),
          ),
          child: Column(
            children: [
              42.hb,
              Text(
                '权益介绍',
                style: TextStyle(color: Colors.white, fontSize: 20.rsp),
              ),
              34.hb,
              _getItem(
                  '底价批发',
                  'VIP店铺可享受平台数字化底价批发进货的'
                      '权益。线上进货，各大品牌随你挑选，想进'
                      '多少货你说了算。最低一件起批，避免囤货'
                      '压资金；打破线下五公里生活圈的地域壁'
                      '垒；不再受品牌授权期限制约；没有年采购'
                      '销售指标考核',
                  Assets.icCardPi.path),
              24.hb,
              _getItem('0元创业平台', '零成本、零库存、零风险、零门槛', Assets.icCardMian.path),
              24.hb,
              _getItem('在线选品商城', '让销售场景无处不在，助力用户一键打造私', Assets.icCardShop.path),
              24.hb,
              _getItem('VIP店铺专属折扣', '享受VIP店铺专属折扣价，下单直降', Assets.icCardVvip.path),
              24.hb,
              _getItem(
                  '智能导购系统', '全面提高客户卖货积极性，促进零售线上和线下融合', Assets.icCardDaogou.path),
              24.hb,
              _getItem('SCRM客户资源管理', '会员精准化营业，提高客户忠诚度', Assets.icCardKehu.path),
              24.hb,
              _getItem(
                  '全面领先的数据分析', '多角度、多方位分析店铺经营状况，助力提高销量', Assets.icCardFenxi.path),
              24.hb,
              _getItem('正品保障', '多角度、多方位分析店铺经营状况，助力提', Assets.icCardZhengping.path),
              48.hb,
              _cardList.isNotEmpty? SizedBox(
                height: !UserManager.instance.getSeven?125.rw: 170.rw,
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.rw),
                    itemCount: !UserManager.instance.getSeven?4:3,
                    //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                    gridDelegate:
                    !UserManager.instance.getSeven? const SliverGridDelegateWithFixedCrossAxisCount(
                            //横轴元素个数
                            crossAxisCount: 4,
                            //纵轴间距
                            mainAxisSpacing: 6,
                            //横轴间距
                            crossAxisSpacing: 6,
                            //子组件宽高长度比例
                            childAspectRatio: 78 / 122):
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                        crossAxisCount: 3,
                        //纵轴间距
                        mainAxisSpacing: 6,
                        //横轴间距
                        crossAxisSpacing: 6,
                        //子组件宽高长度比例
                        childAspectRatio: 78 / 122),
                    itemBuilder: (BuildContext context, int index) {
                      //Widget Function(BuildContext context, int index)
                      return _getCard(index,_cardList[index]);
                    }),
              ):SizedBox(height: 125.rw,),
              72.hb,
              GestureDetector(
                onTap: () async{
                  if(_isTap){

                    if(!UserManager.instance.getSeven&&_chooseIndex==0){
                      _getListen();
                    }
                    else{
                      _buyListen(_cardList[_chooseIndex]);
                    }
                    _isTap = false;
                    // 500 毫秒内 不能多次点击
                    Future.delayed(Duration(milliseconds: 1000), () {
                      _isTap = true;
                    });
                  }


                },
                child: Container(
                  height: 36.rw,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 36.rw),
                  alignment:Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      //渐变位置
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFD1B272),
                          Color(0xFFFFDFA5)
                        ]),
                    borderRadius: BorderRadius.all(Radius.circular(18.rw)),
                  ),
                  child:       Text(
                    !UserManager.instance.getSeven&&_chooseIndex==0? '立即领取':'立即购买',
                    style: TextStyle(
                        color: Color(0xFF8F4A18),
                        fontSize: 14.rsp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              48.hb,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 2.rw),
                    child: Image.asset(Assets.icCardSafe.path,width: 20.rw,height: 20.rw,),
                  ),
                  5.wb,

                  RichText(
                      text: TextSpan(
                          text: '安心保障  ',
                          style: TextStyle(
                              color:  Color(0xFF278022),
                              fontSize: 14.rsp,
                              fontWeight: FontWeight.bold),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                color:  Color(0xFF278022),
                                height: 10.rw,
                                width: 2.w,
                              )
                            ),
                            TextSpan(
                              text: '  不自动续费 无任何附带扣费项目 无广告无插件',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.rsp,
                                  ),
                            ),
                            // TextSpan(
                            //   text: '/月',
                            //   style: TextStyle(
                            //       color: Color(0xFFC29761),
                            //       fontSize: 16.rsp,
                            //       fontWeight: FontWeight.bold),
                            // )
                          ])),
                ],
              ),
              72.hb,


            ],
            //
          ),
        )
      ],
    );
  }

  _getListen(){
    Alert.show(
      context,
      NormalContentDialog(
        title: '7日卡领取提醒',
        content: Text(
          'VIP7日体验卡将在领取后开始使用，\n    每个账号仅限一次，是否领取',
          style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
        ),
        items: ["取消"],
        listener: (index) {
          Alert.dismiss(context);
        },
        deleteItem: "领取",
        deleteListener: () async{
          Alert.dismiss(context);
          bool getCard = await WholesaleFunc.active7();
          if(getCard){
            BotToast.showText(text: '领取成功');
            _refresh();
          }else{
            BotToast.showText(text: '领取失败');
          }
        },
        type: NormalTextDialogType.delete,
      ),
    );
  }

  _buyListen(VipCardModel model) async{
    OrderPreviewModel order = await GoodsDetailModelImpl.createOrderPreview(
      UserManager.instance.user.info.id,
      model.skuId,
      model.skuName,
      1,
    );
    if (order.code != HttpStatus.SUCCESS) {
      // Toast.showError(order.msg);
      ReToast.err(text: order.msg);
      // Get.back();
      return;
    }else{
      final cancel = ReToast.loading();
      HttpResultModel<OrderPrepayModel> resultModel = await _presenterImpl
          .submitOrder(order.data.id, UserManager.instance.user.info.id);
      cancel();
      if (!resultModel.result) {
        ReToast.err(text: resultModel.msg);
        return;
      }
      AppRouter.push(context, RouteName.ORDER_PREPAY_PAGE,
          arguments: OrderPrepayPage.setArguments(
              resultModel.data,
              goToOrder: false,
              canUseBalance:  AppConfig.debug?true:false,
              isPifa: false,
              fromTo: '123'
          ));
    }

  }
  _getItem(String title, String content, String url) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.rw),
      margin: EdgeInsets.symmetric(horizontal: 20.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16.rw)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 28.w),
            child: Image.asset(
              url,
              width: 24.rw,
              height: 24.rw,
            ),
          ),
          28.wb,
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  28.hb,
                  Text(
                    title,
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16.rsp,
                        fontWeight: FontWeight.bold),
                  ),
                  16.hb,
                  Text(
                    content,
                    style:
                        TextStyle(color: Color(0xFF666666), fontSize: 14.rsp),
                  ),
                  28.hb,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getCard(int index,VipCardModel item) {
    return GestureDetector(
      onTap: () {
        _chooseIndex = index;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              //渐变位置
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                index == _chooseIndex ? Color(0xFFF1DCAF) : Colors.white,
                index == _chooseIndex ? Color(0xFFF9EFD7) : Colors.white
              ]),
          borderRadius: BorderRadius.all(Radius.circular(8.rw)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(8.rw)),
            border: Border.all(color: Color(0xFFB18A4F), width: 1.w),
          ),
          child:
          !UserManager.instance.getSeven?Column(
            children: [
              10.hb,
              Text(
                index==0?'七日卡':
                item.skuName.split('|')[1],
                style: TextStyle(
                    color: index == _chooseIndex ? Color(0xFFC2955B):Color(0xFF858585),
                    fontSize: 14.rsp,
                    fontWeight: FontWeight.bold),
              ),
              12.hb,
              RichText(
                  text: TextSpan(
                      text: '¥',
                      style: TextStyle(
                          color:  index == _chooseIndex ? Color(0xFF67421F):Color(0xFFC29761),
                          fontSize: 16.rsp,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: item.discountPrice.toString(),
                          style: TextStyle(
                              color: index == _chooseIndex ? Color(0xFF67421F):Color(0xFFC29761),
                              fontSize: 32.rsp,
                              fontWeight: FontWeight.bold),
                        ),
                      ])),
              item.coupon!=0&&index!=0?Text(
                '原价¥${item.coupon+item.discountPrice}/月',
                style: TextStyle(
                    color: index == _chooseIndex ? Color(0xFFA59571):Color(0xFF999999),
                    fontSize: 12.rsp,

                  decoration: TextDecoration.lineThrough,
                  decorationColor: index == _chooseIndex ? Color(0xFFA59571):Color(0xFF858585),),
              ): Text(
                '原价',
                style: TextStyle(
                  color: Colors.transparent,
                  fontSize: 12.rsp,

                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.transparent,),
              ),
              10.hb,
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 32.w,
                color: Color(0xFF9A7640),
                child: Text(
                  index==0?'仅限一次':
                  '¥${(item.discountPrice/item.effectTime/30).toStringAsFixed(1)}/天',
                  style: TextStyle(
                      color: index == _chooseIndex ? Color(0xFFFFEFCC):Color(0xFFFFFFFF),
                      fontSize: 10.rsp,fontWeight: FontWeight.bold
                     ),
                ),
              )

              //Text('VIP店铺月卡',style: TextStyle(color: Color(0xFF333333),fontSize: 16.rsp,fontWeight: FontWeight.bold),),
            ],
          ):
          Column(
            children: [
              36.hb,
              Text(
                item.skuName.split('|')[0],
                style: TextStyle(
                    color: index == _chooseIndex ? Color(0xFFC2955B):Color(0xFF858585),
                    fontSize: 14.rsp,
                    fontWeight: FontWeight.bold),
              ),
              20.hb,
              RichText(
                  text: TextSpan(
                      text: '¥',
                      style: TextStyle(
                          color:  index == _chooseIndex ? Color(0xFF67421F):Color(0xFFC29761),
                          fontSize: 16.rsp,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: item.discountPrice.toString(),
                          style: TextStyle(
                              color: index == _chooseIndex ? Color(0xFF67421F):Color(0xFFC29761),
                              fontSize: 32.rsp,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: index==0?'/月':index==1?'/季':'/年',
                          style: TextStyle(
                              color: index == _chooseIndex ? Color(0xFF67421F):Color(0xFFC29761),
                              fontSize: 16.rsp,
                              fontWeight: FontWeight.bold),
                        )
                      ])),
              16.hb,
              item.coupon!=0?Text(
                '原价¥${item.coupon+item.discountPrice}/${index==0?'/月':index==1?'/季':'/年'}',
                style: TextStyle(
                  color: index == _chooseIndex ? Color(0xFFA59571):Color(0xFF999999),
                  fontSize: 12.rsp,

                  decoration: TextDecoration.lineThrough,
                  decorationColor: index == _chooseIndex ? Color(0xFFA59571):Color(0xFF858585),),
              ):Text(
                '月',
                style: TextStyle(
                  color: Colors.transparent,
                  fontSize: 12.rsp,

                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.transparent),
              ),
              16.hb,
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 48.w,
                color: Color(0xFF9A7640),
                child: Text(
                  '¥${(item.discountPrice/item.effectTime/30).toStringAsFixed(1)}/天',
                  style: TextStyle(
                      color: index == _chooseIndex ? Color(0xFFFFEFCC):Color(0xFFFFFFFF),
                      fontSize: 12.rsp,fontWeight: FontWeight.bold
                  ),
                ),
              )

              //Text('VIP店铺月卡',style: TextStyle(color: Color(0xFF333333),fontSize: 16.rsp,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}


