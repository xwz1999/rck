import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/shopping_cart_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_car_item.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:velocity_x/velocity_x.dart';

class WholesaleCarPage extends StatefulWidget {
  WholesaleCarPage({
    Key key,
  }) : super(key: key);

  @override
  _WholesaleCarPageState createState() => _WholesaleCarPageState();
}

class _WholesaleCarPageState extends State<WholesaleCarPage>{
  bool _manageStatus = false;//是否进入删除商品的状态
  bool _checkAll = false;//全选
  bool _editting = false;
  GSRefreshController _refreshController;
  List<ShoppingCartGoodsModel> _selectedGoods = [];

  List<ShoppingCartBrandModel> _carList = [];
  StateSetter _bottomStateSetter;
  int _totalNum = 0;

  @override
  void initState() {
    super.initState();
    _refreshController = GSRefreshController(initialRefresh: true);
    Future.delayed(Duration.zero, () async {
      await getcarList();
    });
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.menu),
            // ),
            32.wb,
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  child: Text(
                      "批发购物车",
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 20.rsp,
                      ),

                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
        // title:  Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   // crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //
        //     Text(
        //         "批发购物车",
        //         style: TextStyle(
        //           color: Color(0xFF111111),
        //           fontSize: 20.rsp,
        //         ),
        //
        //     ),
        //   ],
        // ),
        elevation: 0,
        actions: [
          CustomImageButton(
            padding: EdgeInsets.only(right: rSize(10), top: rSize(5)),
            title: !_manageStatus ? "管理" : "完成",
            color: Color(0xFF666666),
            fontSize: 14 * 2.sp,
            onPressed: () {
              if (_editting) {
                FocusScope.of(context).requestFocus(FocusNode());
                return;
              }
              //切换管理状态  重置所以数据到原始数据
              for (ShoppingCartBrandModel _brandModel
              in _carList) {
                _brandModel.selected = false;
                for (ShoppingCartGoodsModel _goodsModel
                in _brandModel.children) {
                  _goodsModel.selected = false;
                }
              }
              _checkAll = false;
              _selectedGoods.clear();
              _manageStatus = !_manageStatus;
              setState(() {});
            },
          )
        ],

      ),
      body:  _bodyWidget(),

      bottomNavigationBar: _bottomTool() ,
    );
  }

  _bodyWidget() {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
         await getcarList();
         _checkAll = false;
         _selectedGoods.clear();
         _totalNum = 0;
         _carList.forEach((brand) {
           _totalNum += brand.children.length;
         });
        setState(() {

        });
        _refreshController.refreshCompleted();
      },

      body:
      // _recommendUserList.isNotEmpty?
      _carList.isNotEmpty?ListView.builder(
          itemBuilder: (context, index) {
            return WhosaleCarItem(
              isEdit: _manageStatus,
              //isEdit: true,
              model: _carList[index],
              selectedListener: (ShoppingCartGoodsModel goods) {
                bool goodsSelected = goods.selected;
                if (_selectedGoods.contains(goods)) {
                  if (!goodsSelected) {
                    _selectedGoods.remove(goods);
                  }
                } else {
                  if (goodsSelected) {
                    _selectedGoods.add(goods);
                  }
                }
                if (_selectedGoods.length == _totalNum) {
                  _checkAll = true;
                } else {
                  _checkAll = false;
                }
                _bottomStateSetter(() {});
              },
              clickListener: (ShoppingCartGoodsModel goods) {
                if (_editting) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return;
                }
                AppRouter.push(context, RouteName.COMMODITY_PAGE,
                    arguments: CommodityDetailPage.setArguments(goods.goodsId))
                    .then((onValue) {
                  getcarList();
                });
              },
              onBeginInput: (value) {
                _editting = true;
              },
              numUpdateCompleteCallback: (goods, num) {
                _editting = false;
                // _presenter.updateQuantity(
                //     UserManager.instance.user.info.id, goods, num);
              },
            );
          },
          itemCount: _carList.length,
        ):SizedBox(),

            // :noDataView('没有申请记录...'),
    );
  }

  _bottomTool() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter bottomSetState) {
        double totalPrice = 0;
        double totalCommission = 0;
        // _selectedGoods.forEach((goods) {
        //   totalPrice += goods.price * goods.quantity;
        //   totalCommission += goods.commission * goods.quantity;
        // });
        _bottomStateSetter = bottomSetState;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: rSize(8)),
          color: Colors.white,
          height: rSize(65),
          child:  _bottomBarChildren(totalPrice,
                totalCommission: totalCommission),

        );
      },
    );
  }

  _bottomBarChildren(totalPrice, {totalCommission = 0}) {
    return Row(
      children: [
        _checkAllButton(),
        Spacer(),
        !_manageStatus?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    text: "合计: ",
                    style: AppTextStyle.generate(14 * 2.sp,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: "¥",
                          style:
                          AppTextStyle.generate(13 * 2.sp, color: Color(0xffc70404),fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "${totalPrice.toStringAsFixed(2)}",
                          style:
                          AppTextStyle.generate(22 * 2.sp, color: Color(0xffc70404),fontWeight: FontWeight.bold))
                    ])),
            totalCommission > 0 && AppConfig.commissionByRoleLevel
                ? Text(
              "赚 ¥${totalCommission.toStringAsFixed(2)}",
              style: TextStyle(
                  color: AppColor.themeColor, fontSize: 14 * 2.sp),
            )
                : Container()
          ],
        ):SizedBox(),

        !_manageStatus?10.wb:SizedBox(),
        !_manageStatus?_settlementButton():SizedBox(),
        _manageStatus?_deleteButton():SizedBox(),

      ],
    );
  }

  CustomImageButton _checkAllButton() {
    return CustomImageButton(
      direction: Direction.horizontal,
      title: "全选",
      fontSize: 14 * 2.sp,
      color: Colors.grey[700],
      icon: Icon(
        !_checkAll ? AppIcons.icon_circle : AppIcons.icon_check_circle,
        color: _checkAll ? AppColor.themeColor : Colors.grey,
        size: rSize(18),
      ),
      contentSpacing: rSize(5),
      onPressed: () {
        if (_editting) {
          FocusScope.of(context).requestFocus(FocusNode());
          return;
        }
        _checkAll = !_checkAll;
        _selectedGoods.clear();
        // 如果是编辑状态 可以选中所以
        // 如果不是编辑状态 只能选中未下架的商品
        _carList.forEach((brand) {
          brand.selected = _checkAll;
          brand.children.forEach((goods) {
            if (_checkAll) {
              if(goods.publishStatus!=0){//判断是否下架
                _selectedGoods.add(goods);
              }
            }
            goods.selected = _checkAll;
          });
        });
        setState(() {});
      },
    );
  }

  Widget _deleteButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(3)),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          gradient: const LinearGradient(colors: [
            Color(0xFFE05346),
            Color(0xFFDB1E1E),
          ])),
      child: CustomImageButton(
        title: "删除(${_selectedGoods.length})",
        padding:
        EdgeInsets.symmetric(vertical: rSize(9), horizontal: rSize(23)),
        color: Colors.white,
        fontSize: 16 * 2.sp,
        onPressed: () {
          if (_editting) {
            FocusScope.of(context).requestFocus(FocusNode());
            return;
          }

          if (_selectedGoods.length == 0) {
            Toast.showInfo("您还没有选择商品");
            return;
          }

          Alert.show(
              context,
              NormalTextDialog(
                content: "确认将这${_selectedGoods.length}个宝贝删除?",
                items: ["我在想想"],
                listener: (int index) {
                  Alert.dismiss(context);
                },
                type: NormalTextDialogType.delete,
                deleteListener: () {

                },
              ));
        },
      ),
    );
  }

  Container _settlementButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(3)),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          gradient: const LinearGradient(colors: [
            Color(0xFFE05346),
            Color(0xFFDB1E1E),
          ])),
      child: CustomImageButton(
        padding:
        EdgeInsets.symmetric(vertical: rSize(9), horizontal: rSize(23)),
        title: "结算(${_selectedGoods.length})",
        color: Colors.white,
        fontSize: 16 * 2.sp,
        onPressed: () {
          if (_selectedGoods.length == 0) {
            Toast.showInfo("您还没有选择商品");
            return;
          }

        },
      ),
    );
  }


   Future<List<ShoppingCartBrandModel>> getcarList() async {
    ResultData result =
    await HttpManager.post(GoodsApi.shopping_cart_list, {"userID": UserManager.instance.user.info.id});
    if (result.data != null) {
      if (result.data['data'] != null) {
        _carList =
         (result.data['data'] as List)
            .map((e) => ShoppingCartBrandModel.fromJson(e))
            .toList();
      }
      else
        _carList= [];
    }
    else
      _carList= [];
  }
}