import 'package:date_format/date_format.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/utils/date/date_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/goods_item.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'cut_down_time_widget.dart';
import 'model/SeckillModel.dart';

class SeckillActivityPage extends StatefulWidget {
  final SeckillModel seckillModel;
  SeckillActivityPage({
    Key key, @required this.seckillModel,
  }) : super(key: key);

  @override
  _SeckillActivityPageState createState() => _SeckillActivityPageState();
}

class _SeckillActivityPageState extends State<SeckillActivityPage> {
  DateTime _dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  int _status = 0;
  String _endTime = '';
  String _startTime = '';
  num _peopleNum = 800;

  GSRefreshController _refreshController =
  GSRefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    _status = widget.seckillModel.status;
    _endTime = widget.seckillModel.endTime;
    _startTime = widget.seckillModel.startTime;
    _peopleNum = widget.seckillModel.shoppingPeople;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.transparent,
        flexibleSpace: Container(
          width: double.infinity,
          height: 124.rw,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.only(bottomRight: Radius.circular(104.rw)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFD9332D),
                Color(0xFFE44f37),
              ],
            ),
          ),
        ),
        leading: RecookBackButton(
          white: true,
        ),
        elevation: 0,
        title: Text(
          "限时秒杀",
          style: TextStyle(
              color: Colors.white,
              fontSize: 28.rsp,
              fontWeight: FontWeight.bold),
        ),
        bottom: _bottomWidgt(),
      ),

      body: Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFFD5101A),
        //     Color(0x03FE2E39),
        //   ],
        //   stops: [0.0, 0.5],
        // )),
        child: _listWidget(),
      ),
    );
  }


  _listWidget() {
    return Container(
      child: widget.seckillModel.seckillGoodsList!=null?
      ListView.builder(

        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              AppRouter.push(context, RouteName.COMMODITY_PAGE,
                  arguments: CommodityDetailPage.setArguments(
                      widget.seckillModel.seckillGoodsList[index].goodsId));
            },
            child: _itemWidget(widget.seckillModel.seckillGoodsList[index]),
          );
        },
        itemCount: widget.seckillModel.seckillGoodsList.length,
      ):noDataView('没有找到商品'),
    );
  }
  noDataView(String text, {Widget icon}) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon ??
              Image.asset(
                R.ASSETS_NODATA_PNG,
                width: rSize(80),
                height: rSize(80),
              ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey),
          ),
          SizedBox(
            height: rSize(30),
          )
        ],
      ),
    );
  }

  _itemWidget(SeckillGoods data) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      constraints: BoxConstraints(minWidth: 150),
      child: Stack(
        children: <Widget>[
          GoodsItemWidget.seckillGoodsItem(
            onBrandClick: () {
              AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                  arguments: BrandGoodsListPage.setArguments(
                      data.brandId, data.brandName));//brandId
            },
            buildCtx: context,
            model: data,
            seckillModel: widget.seckillModel,
          ),
        ],
      ),
    );
  }

  Widget _bottomWidgt() {
    return PreferredSize(
      preferredSize: Size.fromHeight(30.rw),
      child: (
          Container(
        margin: EdgeInsets.only(bottom: 10.rw),
        width: double.infinity,
        height: 30.rw,
        color: Color(0xFFFCEEED),
        child:_status==1&&_startTime!=''?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '还差',
              style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
            ),
            16.wb,
            CutDownTimeWidget(time:_startTime,white: false,),
            16.wb,
            Text(
              '活动开始',
              style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
            ),
          ],
        ):_status==2?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                30.wb,
                Text(
                  '约',
                  style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
                ),
                Text(
                  _peopleNum.toString()+'人',
                  style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
                ),
                Text(
                  '正在疯抢中',
                  style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
                ),
              ],
            ),
            Container(
              child: Row(
                children: [
                  Text(
                    '距结束',
                    style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
                  ),
                  16.wb,
                  CutDownTimeWidget(time:_endTime,white: false),
                  30.wb,
                ],
              ),
            ),

          ],
        ):SizedBox(),
      )),
    );
  }
}
