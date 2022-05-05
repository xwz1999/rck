import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/pages/user/functions/user_benefit_func.dart';
import 'package:jingyaoyun/pages/user/model/pifa_table_model.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_table_month_page.dart';
import 'package:jingyaoyun/widgets/image_scaffold.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

class WholesaleTablePage extends StatefulWidget {
  WholesaleTablePage({
    Key key,
  }) : super(key: key);

  @override
  _WholesaleTablePageState createState() => _WholesaleTablePageState();
}

class _WholesaleTablePageState extends State<WholesaleTablePage> {
  GSRefreshController _refreshController =
  GSRefreshController(initialRefresh: true);

  PiFaTableModel models;

  bool _onLoad = true;



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){

    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImageScaffold(
      systemStyle: SystemUiOverlayStyle.light,
      path: Assets.pifaTableBg.path,
      bodyColor:Color(0xFFF6F6F6),
      appbar: Container(
        color: Colors.transparent,
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            RecookBackButton(
              white: true,
            ),
            Text(
              "批发报表",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.rsp,
              ),
            ),
            IconButton(
                icon: Icon(
                  AppIcons.icon_back,
                  size: 17,
                  color:  Colors.transparent ,
                ),
                onPressed: () {

                }),
          ],
        ),
      ),
      body: Flexible(
        child:          RefreshWidget(
            controller: _refreshController,
            color: Colors.white,
            onRefresh: () async {
              models = await UserBenefitFunc.getPiFaTable(1);

              _refreshController.refreshCompleted();
              _onLoad = false;
              setState(() {

              });
            },
            body: _bodyWidget()
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
        20.hb,
        Row(
          children: [
            Text(
              '全部',
              style: TextStyle(
                  fontSize: 24.rsp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
        48.hb,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.rw),

          height: 115.rw,
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
              48.hb,
              Text(
                '批发总额',
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
              ),
              40.hb,
              Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(top: 5.rw),
                    child: Text(
                      '¥ ',
                      style:
                          TextStyle(fontSize: 26.rsp, color: Color(0xFF8D1D22)),
                    ),
                  ),
                  Text(
                      _onLoad ?'0':TextUtils.getCount1(models.total),
                    style:
                        TextStyle(fontSize: 32.rsp, color: Color(0xFF8D1D22)),
                  ),
                ],
              )
            ],
          ),
        ),
        32.hb,

        _onLoad?SizedBox():
        Container(
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
                  if(models.data.isEmpty){
                    return SizedBox();
                  }else{
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

      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,

                child: Text(
                  '日期',
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
                  '订单数',
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
                  '批发金额',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF333333),
                  ),
                )),
            flex: 4,
          ),
        ],
      ),
    );
  }

  _buildTableBody(PiFaData model) {
    return GestureDetector(
      onTap: (){
        Get.to(WholesaleTableMonthPage(year:int.parse(model.name)));
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
}
