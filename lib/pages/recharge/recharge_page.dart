import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recook/pages/recharge/recharge_history_page.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:easy_contact_picker/easy_contact_picker.dart';

class RechargePage extends StatefulWidget {
  RechargePage({
    Key key,
  }) : super(key: key);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage>
    with TickerProviderStateMixin {
  List<RechargeModel> _rechargeModelList = [];
  TabController _tabController;
  final EasyContactPicker _contactPicker = new EasyContactPicker();
  Contact _contact = new Contact(fullName: "", phoneNumber: "");
  List _list = [];
  final items = [
    BottomNavigationBarItem(
      icon: Image.asset(
        R.ASSETS_TICKET_ORDER_TAB_ICON_PNG,
        width: 18.rw,
        height: 19.rw,
      ),
      label: '订单',
    ),
  ];
  String _phone = '';
  int _choiceIndex = -1;
  List _realPrice = [];
  //手机号的控制器
  TextEditingController _phoneController = TextEditingController();

  ///2.获取单个联系人
  _getContactData() async {
    Contact contact = await _contactPicker.selectContactWithNative();
    setState(() {
      _contact = contact;
      print("contact==>${_contact.toString()}");
      if (_contact.phoneNumber != '') {
        RegExp exp = RegExp(r'^1\d{10}$');
        bool matched = exp.hasMatch(_contact.phoneNumber);
        if (matched) {
          _phoneController.text = _getPhone(_contact.phoneNumber);
          if(_phoneController.text.length==13){
            _getRealPriceList();
          }else{
            _realPrice.clear();
          }
          _phoneController.selection = TextSelection.fromPosition(TextPosition(
              offset: _phoneController.text.length,
              affinity: TextAffinity.upstream));
        } else {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.normal,
                title: "提示",
                content: "手机格式号错误，请重新选择",
                items: ["确认"],
                listener: (index) {
                  Alert.dismiss(context);
                },
              ));
        }
      }
    });
  }

  _getRealPriceList(){
    _realPrice = ['9,90','19.90','29.90','49.90','99.90','149.90','199.90'];
  }

  ///获取联系人列表
  _getContactDataList() async {
    List<Contact> list = await _contactPicker.selectContacts();
    setState(() {
      _list = list;
      print("list==>${_list.toString()}");
    });
  }

  ///获取权限
  _getPermission(Permission permission) async {
//    var hasOpen = openAppSettings();
//    print("hasOpen==>$hasOpen");

    final status = await permission.request();
    print("status==>$status");
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //RechargeModel rechargeModel = RechargeModel(price:'10',unit:'元');
    _rechargeModelList = [RechargeModel(price:'10',unit:'元'),RechargeModel(price:'20',unit:'元'),RechargeModel(price:'30',unit:'元'),
      RechargeModel(price:'50',unit:'元')
      ,RechargeModel(price:'100',unit:'元'),RechargeModel(price:'150',unit:'元'),RechargeModel(price:'200',unit:'元')];
  }

  @override
  void dispose() {
    _tabController?.dispose();
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
      bottomNavigationBar:

      GestureDetector(
        onTap: (){
          Get.to(RechargeHistoryPage());
        },
        child: Container(
            width: double.infinity,
            height: 48.rw,
            color: Colors.white,
            child: Column(
              children: [
                16.hb,
                Image.asset(
                  R.ASSETS_TICKET_ORDER_TAB_ICON_PNG,
                  width: 18.rw,
                  height: 19.rw,
                ),
                Text(
                  '充值记录',
                  style: TextStyle(color: Color(0xFF666666), fontSize: 10.rsp),
                )
              ],
            )),
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
            top: 0,
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
                    controller: _phoneController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 2.rw, bottom: 4.rw, top: 30.rw),
                      hintText: '请输入11位手机号码',
                      counterText: '',
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 260.rw),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minHeight: 17.rw,
                        minWidth: 17.rw,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 30.rw),
                        child: GestureDetector(
                          onTap: () {
                            _phoneController.clear();
                            _realPrice.clear();
                            setState(() {});
                          },
                          child: _phoneController.text != ''
                              ? Container(
                                  width: 17.rw,
                                  height: 17.rw,
                                  child: ImageIcon(
                                    AssetImage(R.ASSETS_CANCEL_ICON_PNG),
                                    size: 17.rw,
                                    color: Colors.white,
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintStyle: AppTextStyle.generate(22.rsp,
                          color: Color(0xFFFFFFFF)),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11), //最大长度
                    ],
                    keyboardType: TextInputType.number,
                    style: AppTextStyle.generate(22.rsp, color: Colors.white),
                    maxLength: 11,
                    maxLines: 1,
                    onChanged: (text) {
                      if (text == null) return;

                      _phoneController.text = _getPhone(text);
                      _phoneController.selection = TextSelection.fromPosition(
                          TextPosition(
                              offset: _phoneController.text.length,
                              affinity: TextAffinity.upstream));
                      print(_phoneController.text.length);
                      if(_phoneController.text.length==13){
                        _getRealPriceList();
                      }else{
                        _realPrice.clear();
                      }
                      setState(() {});
                      //print(_phone);
                    },
                  ).expand(),
                  100.wb,
                  GestureDetector(
                    onTap: () async {
                      //_getPermission(Permission.contacts);
                      if (Platform.isIOS) {
                        _getContactData();
                      } else {
                        bool canUseContact =
                            await PermissionTool.haveContactPermission();

                        if (canUseContact) {
                          _getContactData();
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 34.rw),
                      child: Image.asset(
                        R.ASSETS_TICKET_ORDER_TAB_ICON_PNG,
                        width: 19.rw,
                        height: 22.rw,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  60.wb,
                ],
              ),
            ),
          ),
          Positioned(
              top: 90.rw,
              left: 15.rw,
              right: 15.rw,
              child: Container(
                height: 295.rw,//_rechargeModelList.isNotEmpty&&_rechargeModelList.length>9?((_rechargeModelList.length~/3)-3)*74.rw+295.rw:295.rw,
                width: 375.rw,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.rw),
                ),
                child: Column(
                  children: [
                    _tabBarView(),
                    _ticketsList(),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  _tabBarView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.rw),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4.rw)),
      alignment: Alignment.center,
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 40.rw),
        isScrollable: true,
        controller: _tabController,
        labelColor: Color(0xFF333333),
        unselectedLabelColor: Color(0xFF333333).withOpacity(0.3),
        labelStyle: TextStyle(
          fontSize: 18.rsp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 18.rsp,
          fontWeight: FontWeight.w400,
        ),
        indicatorPadding: EdgeInsets.only(bottom: 12.rw),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: RecookIndicator(
          borderSide: BorderSide(
            width: 6.rw,
            color: Color(0xFF04C580),
          ),

          //borderRadius: BorderRadius.circular(3.rw),
        ),
        tabs: [
          Tab(text: '充话费'),
          Tab(text: '充流量'),
        ],
      ),
    );
  }

  _tabViewItem(RechargeModel rechargeModel, int index, VoidCallback onPressed,int choiceIndex,String realPrice) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: choiceIndex!=index?Colors.white:Color(0xFF04C580),
          borderRadius: BorderRadius.circular(3.rw),
          border: Border.all(width: 1.rw,color: Color(0xFFF1F1F1))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rechargeModel.price,
                  style: TextStyle(color: choiceIndex!=index? Color(0xFF333333):Colors.white, fontSize: 24.rsp),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 2.rw),
                  child: Text(
                    rechargeModel.unit,
                    style: TextStyle(color: choiceIndex!=index? Color(0xFF333333):Colors.white, fontSize: 16.rsp,),
                  ),
                )
              ],
            ),

            realPrice!=''?Text(
              '售价' + realPrice + '元',
              style: TextStyle(color: choiceIndex!=index?Color(0xFF666666):Colors.white, fontSize: 12.rsp),
            ):SizedBox()
          ],
        ),
      ),
    );
  }

  _ticketsList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.rw),
      child: TabBarView(
        controller: _tabController,
        children: [
          _phoneBill(),
          _phoneBill(),
        ],
      ),
    ).expand();
  }
  //给手机号加上空格
  _getPhone(String text) {
    if (text.isEmpty) {
      return text;
    } else {
      if (text.length <= 3) {
      } else if (text.length > 3 && text.length < 8) {
        text = text.insert(" ", 3);
      } else if (text.length >= 8) {
        text = text.insert(" ", 3);
        text = text.insert(" ", 8);
      }
      return text;
    }
  }

  _phoneBill(){
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 95 / 64,
          crossAxisSpacing: 15.rw,
          mainAxisSpacing: 10.rw,
        ),
        itemBuilder: (context, index) {
          return _rechargeModelList.length > 0
              ? _tabViewItem(_rechargeModelList[index],index,(){
            setState(() {
                _choiceIndex = index;
            }
            );
          },_choiceIndex,_realPrice.length==_rechargeModelList.length?_realPrice[index]:'')
              : SizedBox();
        },itemCount: _rechargeModelList.length,);
  }


}


class RechargeModel{
  String price;
  String unit;
  RechargeModel({
    this.price,
    this.unit,
});
}