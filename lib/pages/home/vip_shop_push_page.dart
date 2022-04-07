import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/models/home_weather_model.dart';
import 'package:jingyaoyun/pages/user/functions/user_benefit_func.dart';
import 'package:jingyaoyun/pages/user/model/pifa_table_model.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_table_month_page.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/bottom_time_picker.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/image_scaffold.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class VipShopPushPage extends StatefulWidget {
  VipShopPushPage({
    Key key,
  }) : super(key: key);

  @override
  _VipShopPushPageState createState() => _VipShopPushPageState();
}

class _VipShopPushPageState extends State<VipShopPushPage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  PiFaTableModel models;
  DateTime _date;
  bool _onLoad = true;

  @override
  void initState() {
    super.initState();
    _date = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day) ;
    Future.delayed(Duration.zero, () {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: Stack(
          children: [
            Positioned(child: Container(
              width: double.infinity,
              height: 237.rw,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                   Color(0xFFE8694E),
                    Color(0xFFCE1B1B),
                  ],
                )
              ),

            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.transparent,
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RecookBackButton(
                        white: true,
                      ),
                      Text(
                        "VIP店推广",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.rsp,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            AppIcons.icon_back,
                            size: 17,
                            color: Colors.transparent,
                          ),
                          onPressed: () {}),
                    ],
                  ),
                ),
                15.hb,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.rw),
                      height: 100.rw,
                      width: 260.rw,
                      margin: EdgeInsets.only(left: 20.rw),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.rw),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            color: Color(0x4FD93F37),
                            blurRadius: 16.rw,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  '推广次数',
                                  style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                                ),
                                32.wb,
                                Text(
                                  '6',
                                  style: TextStyle(fontSize: 18.rsp, color: Color(0xFFD5101A),fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    _showShare(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 2.rw,horizontal: 6.rw),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFFF14F49),
                                            Color(0xFFE21830),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(2.rw)
                                    ),
                                    child: Text(
                                      '推广 >',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.rsp,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                           Image.asset(Assets.vipPushLine.path,width: double.infinity,height: 1.rw,fit:BoxFit.fitWidth,),

                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  '推广收益',
                                  style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333),),
                                ),
                                32.wb,
                                Text(
                                  '¥4,000.00',
                                  style: TextStyle(fontSize: 18.rsp, color: Color(0xFFD5101A),fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    20.wb,
                    Image.asset(Assets.vipShopImg.path,width: 75.rw,height: 75.rw,)
                  ],
                ),
                20.hb,

                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.rw),topRight:Radius.circular(12.rw) )

                    ),
                    child: RefreshWidget(
                        controller: _refreshController,
                        color: Colors.white,
                        onRefresh: () async {
                          models = await UserBenefitFunc.getPiFaTable(1);

                          _refreshController.refreshCompleted();
                          _onLoad = false;
                          setState(() {});
                        },
                        body: _bodyWidget()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _bodyWidget() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.rw),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        40.hb,
        GestureDetector(
          onTap: (){
            showTimePickerBottomSheet(
                submit: (time, type) {
                  Navigator.maybePop(context);
                  _date = time;
                  _refreshController.requestRefresh();
                  setState(() {});
                },
                timePickerTypes: [
                  BottomTimePickerType.BottomTimePickerMonth,

                ]);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                DateUtil.formatDate(_date, format: 'yyyy-MM'),
                style: TextStyle(
                    fontSize: 16.rsp,
                    color: Color(0xFF111111),
                ),
              ),
              10.wb,
              Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF111111),
                size: 16.rw,
              ),

            ],
          ),
        ),


        _onLoad
            ? SizedBox()
            : Container(
                padding: EdgeInsets.symmetric(vertical: 15.rw),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rw),
                ),
                child: Column(
                  children: [
                    _buildTableTitle(),
                    10.hb,
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        if (models.data.isEmpty) {
                          return SizedBox();
                        } else {
                          PiFaData model = models.data[i];
                          return _buildTableBody(model);
                        }
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Color(0xFFEEEEEE),
                        height: 1.rw,
                        thickness: 1.rw,
                        indent: 20.rw,
                        endIndent: 20.rw,
                      ),
                      itemCount: models.data.length,
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  _buildTableTitle() {
    return Container(
      padding: EdgeInsets.only(top: 12.rw,bottom: 12.rw,left: 12.rw),
      color: Color(0xFFF6F6F6),
      child: Flex(
        direction: Axis.horizontal,
        children: [

          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '用户昵称',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF333333),
                  ),
                )),
            flex: 8,
          ),
          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '手机号',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF333333),
                  ),
                )),
            flex: 9,
          ),
          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '权益卡',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF333333),
                  ),
                )),
            flex: 6,
          ),
          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '金额',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF333333),
                  ),
                )),
            flex: 6,
          ),
        ],
      ),
    );
  }

  _buildTableBody(PiFaData model) {
    return GestureDetector(
      onTap: () {
        Get.to(WholesaleTableMonthPage(year: int.parse(model.name)));
      },
      child: Container(
        height: 40.rw,
        color: Colors.white,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    model.name,
                    style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    ),
                  )),
              flex: 3,
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${model.count}',
                    style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    ),
                  )),
              flex: 3,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        model.amount.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14.rsp,
                          color: Color(0xFF333333),
                        ),
                      )),
                  30.wb,
                  Icon(Icons.keyboard_arrow_right,
                      size: 22.rw, color: Color(0xFFCCCCCC)),
                  10.wb,
                ],
              ),
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }


  ///时间选择器
  showTimePickerBottomSheet(
      {List<BottomTimePickerType> timePickerTypes,
        Function(DateTime, BottomTimePickerType) submit}) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              yearChoose: true,
              timePickerTypes: timePickerTypes,
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: submit != null
                  ? submit
                  : (time, type) {
                Navigator.maybePop(context);
                _date = time;
                setState(() {});
              },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }

  _showShare(BuildContext context) {
    // if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip ||
    //     UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None) {
    //   //跳到分享邀请
    //   // _showInviteShare(context);
    //   ShareTool().inviteShare(context);
    //   return;
    // }

    ShareTool().goodsShare(context,
        goodsPrice: '',
        miniTitle: '',
        goodsName:'',
        goodsDescription: '',
        miniPicurl:"",
        goodsId:'',
        amount:  "");
  }

}
