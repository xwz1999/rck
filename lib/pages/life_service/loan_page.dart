import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/loan_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/list_pick_body.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'loan_result_page.dart';

class LoanPage extends StatefulWidget {
  LoanPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage>
    with TickerProviderStateMixin {
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();

  String money = '';
  String year = '';
  String active = '';
  String type = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _contentFocusNode.dispose();
    _weightFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,

      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,

        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('贷款公积金查询',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.rw),
      child: ListView(
        shrinkWrap: true,
        children: [
          64.hb,
          RichText(
            text: TextSpan(
                text: '贷款总额(万)',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '  如50表示50万，最多不可超过500万',
                      style: TextStyle(
                        fontSize: 12.rsp,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.normal
                      ))
                ]),
          ),
          24.hb,
          Container(
            height: 50.rw,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              onSubmitted: (_submitted) async {
                _weightFocusNode.unfocus();
              },
              focusNode: _weightFocusNode,
              onChanged: (text) {
                if (text.isNotEmpty) money = text;
                else
                  money = '';
              },
              style: TextStyle(
                  color: Colors.black, textBaseline: TextBaseline.ideographic),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 25.rw),
                filled: true,
                fillColor: Color(0xFFF9F9F9),
                hintText: '请输入',
                hintStyle: TextStyle(
                    color: Color(0xFFD8D8D8),
                    fontSize: 14.rsp,
                    fontWeight: FontWeight.bold),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.rw)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.rw)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          64.hb,
          Text(
            '贷款年限(年)',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              year =  (await ListPickBody.listPicker([
                '5','10','15','20','25','30'
              ], '贷款年限'))??'';
              setState(() {

              });
            },
            child: Container(
              height: 50.rw,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.rw),
              decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.all(Radius.circular(24.rw))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    year,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 28 * 2.sp,
                  ),
                ],
              ),
            ),
          ),
          64.hb,
          Text(
            '计算标准',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: ()async {
              type =  (await ListPickBody.listPicker([
              '等额本息','等额本金'
              ], '还款方式'))??'';
              setState(() {

              });

            },
            child: Container(
              height: 50.rw,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.rw),
              decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.all(Radius.circular(24.rw))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    type,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 28 * 2.sp,
                  ),
                ],
              ),
            ),
          ),
          64.hb,
          RichText(
            text: TextSpan(
                text: '贷款利率(%)',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),),
          ),
          24.hb,
          Container(
            height: 50.rw,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              onSubmitted: (_submitted) async {
                _contentFocusNode.unfocus();
              },
              focusNode: _contentFocusNode,
              onChanged: (text) {
                if (text.isNotEmpty) active = text;
                else
                  active = '';
              },

              style: TextStyle(
                  color: Colors.black, textBaseline: TextBaseline.ideographic),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 25.rw),
                filled: true,
                fillColor: Color(0xFFF9F9F9),
                hintText: '请输入利率',
                hintStyle: TextStyle(
                    color: Color(0xFFD8D8D8),
                    fontSize: 14.rsp,
                    fontWeight: FontWeight.bold),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.rw)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.rw)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),

          100.hb,
          CustomImageButton(
            height: 42.rw,
            title: "开始查询",
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            fontSize: 14.rsp,
            borderRadius: BorderRadius.all(Radius.circular(21.rw)),
            onPressed: () {
              if ((double.parse(active)< 20 && double.parse(money)<500) &&
                  (type!=''&& year!='')) {

                Get.to(() => LoanResultPage(loanModel: LoanModel(
                  bx:Bx(
                    bxPerMonth: '3301.68',
                    bxTotal: '1188603.87',
                    lxPerMonth: '1357.233',
                    lxTotal: '488603.87'
                  ),
                  bj: Bj(
                      bxTotal: "1110637.50",
                      lxTotal: "410637.50",
                      perMonth: ["4219.44", "4213.12", "4206.81", "4200.49", "4194.17", "4187.85", "4181.53", "4175.21", "4168.89", "4162.57", "4156.25", "4149.93", "4143.61", "4137.29", "4130.97", "4124.65", "4118.33", "4112.01", "4105.69", "4099.38", "4093.06", "4086.74", "4080.42", "4074.10", "4067.78", "4061.46", "4055.14", "4048.82", "4042.50", "4036.18", "4029.86", "4023.54", "4017.22", "4010.90", "4004.58", "3998.26", "3991.94", "3985.62", "3979.31", "3972.99", "3966.67", "3960.35", "3954.03", "3947.71", "3941.39", "3935.07", "3928.75", "3922.43", "3916.11", "3909.79", "3903.47", "3897.15", "3890.83", "3884.51", "3878.19", "3871.88", "3865.56", "3859.24", "3852.92", "3846.60", "3840.28", "3833.96", "3827.64", "3821.32", "3815.00", "3808.68", "3802.36", "3796.04", "3789.72", "3783.40", "3777.08", "3770.76", "3764.44", "3758.12", "3751.81", "3745.49", "3739.17", "3732.85", "3726.53", "3720.21", "3713.89", "3707.57", "3701.25", "3694.93", "3688.61", "3682.29", "3675.97", "3669.65", "3663.33", "3657.01", "3650.69", "3644.38", "3638.06", "3631.74", "3625.42", "3619.10", "3612.78", "3606.46", "3600.14", "3593.82", "3587.50", "3581.18", "3574.86", "3568.54", "3562.22", "3555.90", "3549.58", "3543.26", "3536.94", "3530.62", "3524.31", "3517.99", "3511.67", "3505.35", "3499.03", "3492.71", "3486.39", "3480.07", "3473.75", "3467.43", "3461.11", "3454.79", "3448.47", "3442.15", "3435.83", "3429.51", "3423.19", "3416.88", "3410.56", "3404.24", "3397.92", "3391.60", "3385.28", "3378.96", "3372.64", "3366.32", "3360.00", "3353.68", "3347.36", "3341.04", "3334.72", "3328.40", "3322.08", "3315.76", "3309.44", "3303.12", "3296.81", "3290.49", "3284.17", "3277.85", "3271.53", "3265.21", "3258.89", "3252.57", "3246.25", "3239.93", "3233.61", "3227.29", "3220.97", "3214.65", "3208.33", "3202.01", "3195.69", "3189.38", "3183.06", "3176.74", "3170.42", "3164.10", "3157.78", "3151.46", "3145.14", "3138.82", "3132.50", "3126.18", "3119.86", "3113.54", "3107.22", "3100.90", "3094.58", "3088.26", "3081.94", "3075.62", "3069.31", "3062.99", "3056.67", "3050.35", "3044.03", "3037.71", "3031.39", "3025.07", "3018.75", "3012.43", "3006.11", "2999.79", "2993.47", "2987.15", "2980.83", "2974.51", "2968.19", "2961.88", "2955.56", "2949.24", "2942.92", "2936.60", "2930.28", "2923.96", "2917.64", "2911.32", "2905.00", "2898.68", "2892.36", "2886.04", "2879.72", "2873.40", "2867.08", "2860.76", "2854.44", "2848.12", "2841.81", "2835.49", "2829.17", "2822.85", "2816.53", "2810.21", "2803.89", "2797.57", "2791.25", "2784.93", "2778.61", "2772.29", "2765.97", "2759.65", "2753.33", "2747.01", "2740.69", "2734.38", "2728.06", "2721.74", "2715.42", "2709.10", "2702.78", "2696.46", "2690.14", "2683.82", "2677.50", "2671.18", "2664.86", "2658.54", "2652.22", "2645.90", "2639.58", "2633.26", "2626.94", "2620.62", "2614.31", "2607.99", "2601.67", "2595.35", "2589.03", "2582.71", "2576.39", "2570.07", "2563.75", "2557.43", "2551.11", "2544.79", "2538.47", "2532.15", "2525.83", "2519.51", "2513.19", "2506.88", "2500.56", "2494.24", "2487.92", "2481.60", "2475.28", "2468.96", "2462.64", "2456.32", "2450.00", "2443.68", "2437.36", "2431.04", "2424.72", "2418.40", "2412.08", "2405.76", "2399.44", "2393.12", "2386.81", "2380.49", "2374.17", "2367.85", "2361.53", "2355.21", "2348.89", "2342.57", "2336.25", "2329.93", "2323.61", "2317.29", "2310.97", "2304.65", "2298.33", "2292.01", "2285.69", "2279.38", "2273.06", "2266.74", "2260.42", "2254.10", "2247.78", "2241.46", "2235.14", "2228.82", "2222.50", "2216.18", "2209.86", "2203.54", "2197.22", "2190.90", "2184.58", "2178.26", "2171.94", "2165.62", "2159.31", "2152.99", "2146.67", "2140.35", "2134.03", "2127.71", "2121.39", "2115.07", "2108.75", "2102.43", "2096.11", "2089.79", "2083.47", "2077.15", "2070.83", "2064.51", "2058.19", "2051.87", "2045.56", "2039.24", "2032.92", "2026.60", "2020.28", "2013.96", "2007.64", "2001.32", "1995.00", "1988.68", "1982.36", "1976.04", "1969.72", "1963.40", "1957.08", "1950.76"],
                      lxLastMonth: "6.32",
                      lxFirstMonth: "2275.00",
                      capital: "1944.44"
                  )
                ), year: year, type: type,));

              } else {
                BotToast.showText(text: '请输入正确的数据');
              }
            },
          )
        ],
      ),
    );
  }
}
