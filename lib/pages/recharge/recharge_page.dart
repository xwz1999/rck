import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

class RechargePage extends StatefulWidget {
  RechargePage({
    Key key,
  }) : super(key: key);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage>
    with TickerProviderStateMixin {

  final items = [
    BottomNavigationBarItem(
         icon: Image.asset(R.ASSETS_TICKET_ORDER_TAB_ICON_PNG,width: 18.rw,height: 19.rw,),
      label: '订单',
    ),
  ];
  String _phone = '';
  //手机号的控制器
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text(
          "话费充值",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 48.rw,
        color: Colors.white,
        child: Column(
          children: [
            16.hb,
            Image.asset(R.ASSETS_TICKET_ORDER_TAB_ICON_PNG,width: 18.rw,height: 19.rw,),
            Text('充值记录',style: TextStyle(color: Color(0xFF666666),fontSize: 10.rsp),)
          ],
        )
      ),
      body: Container(

        child: _bodyWidget(),
      ),
    );
  }

  void onTap(int index) {
    if (index == 0) {
      //Get.to(); //充值记录页面
    }
  }

  _bodyWidget() {
    return Container(
      width: 375.rw,
      child: Stack(
        children: [
          Positioned(
            top:0,
            left: 0,
            child: Container(

              width: 375.rw,
              height: 150.rw,
              color: Color(0xFF04C580),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  34.wb,
                  TextField(
                    controller:_phoneController,
                    decoration: InputDecoration(

                      contentPadding: EdgeInsets.only(left: 2.rw, bottom: 4.rw,top: 30.rw),
                      hintText: '请输入11位手机号码',
                      counterText: '',
                      border:UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 260.rw
                        ),
                      ),
                        suffixIconConstraints:BoxConstraints(
                                        minHeight: 17.rw,
                                        minWidth: 17.rw,
                       ),
                      suffixIcon:
                          Padding(
                            padding: EdgeInsets.all(5.rw),
                            child:GestureDetector(
                              onTap: (){
                                _phoneController.clear();
                                setState(() {
                                });
                              },
                              child:_phone!=''?Container(

                                width: 17.rw,
                                height: 17.rw,
                                child: ImageIcon(
                                AssetImage(R.ASSETS_CANCEL_ICON_PNG),
                                size: 17.rw,
                                color: Colors.white,
                              ),
                              ):SizedBox(),
                            ),
                          ),


                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintStyle:
                      AppTextStyle.generate(22.rsp, color: Color(0xFFFFFFFF)),
                    ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),//最大长度
                      ],

                    keyboardType: TextInputType.number,
                    style: AppTextStyle.generate(22.rsp,color: Colors.white),
                    maxLength: 11,
                    maxLines: 1,
                    onChanged: (text) {


                      if (text == null) return;
                      _phone = text;
                      _phoneController.text = _getPhone(_phone);
                      _phoneController.selection = TextSelection.fromPosition(
                          TextPosition(
                              offset: _phoneController.text.length, affinity: TextAffinity.upstream));
                      setState(() {

                      });
                      //print(_phone);
                    },
                  ).expand(),
                  100.wb,
                  Container(
                    padding: EdgeInsets.only(top: 34.rw),
                    child: Image.asset(R.ASSETS_TICKET_ORDER_TAB_ICON_PNG,width: 19.rw,height: 22.rw,color: Colors.white,),

                  ),

                  60.wb,
                ],

              ),
            ),
          ),

        ],
      ),
    );
  }
  _getPhone(String text){
    if(text.isEmpty){
      return text;
    }else{
      if(text.length<=3){

      }else if(text.length>3&&text.length<8){

        text = text.insert(" ",3);

      }else if(text.length>=8){
        text = text.insert(" ",3);
        text = text.insert(" ",8);
      }
      return text;
    }

  }
}
