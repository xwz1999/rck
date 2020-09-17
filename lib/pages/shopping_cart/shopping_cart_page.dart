/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-23  14:10 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/order_preview_model.dart';
import 'package:recook/models/shopping_cart_list_model.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/order_preview_page.dart';
import 'package:recook/pages/shopping_cart/item/item_shopping_cart.dart';
import 'package:recook/pages/shopping_cart/mvp/shopping_cart_contact.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/pages/shopping_cart/mvp/shopping_cart_presenter_impl.dart';
import 'package:recook/widgets/toast.dart';

class ShoppingCartPage extends StatefulWidget {
  final bool needSafeArea;

  const ShoppingCartPage({Key key, this.needSafeArea = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShoppingCartPageState();
  }
}

class _ShoppingCartPageState extends BaseStoreState<ShoppingCartPage>
    with MvpListViewDelegate<ShoppingCartBrandModel>
    implements ShoppingCartViewI {
  ShoppingCartPresenterImpl _presenter;
  MvpListViewController<ShoppingCartBrandModel> _controller;
  bool _checkAll = false;
  List<ShoppingCartGoodsModel> _selectedGoods;
  StateSetter _bottomStateSetter;
  int _totalNum = 0;
  bool _manageStatus;
  bool _editting;
  BuildContext _context;

  // @override
  // bool get wantKeepAlive {
  //   return true;
  // }

  @override
  void initState() {
    super.initState();
    _manageStatus = false;
    _editting = false;
    _presenter = ShoppingCartPresenterImpl();
    _presenter.attach(this);
    _controller = MvpListViewController();
    _selectedGoods = [];

    _presenter.getShoppingCartList(UserManager.instance.user.info.id);

    UserManager.instance.refreshShoppingCart.addListener(_refreshShoppingCart);
  }

  _refreshShoppingCart() {
    if (UserManager.instance.refreshShoppingCart.value) {
      UserManager.instance.refreshShoppingCart.value = false;
      _controller.requestRefresh();
    }
  }

  @override
  void dispose() {
    UserManager.instance.refreshShoppingCart
        .removeListener(_refreshShoppingCart);
    super.dispose();
  }

  Color getAppBarColor() {
    UserRoleLevel level = UserLevelTool.currentRoleLevelEnum();
    switch (level) {
      case UserRoleLevel.None:
        return Color(0xFFdca3ab);
        break;
      case UserRoleLevel.Diamond:
        return Color(0xFFa27cc9);
        break;
      case UserRoleLevel.Gold:
        return Color(0xFFe4be79);
        break;
      case UserRoleLevel.Silver:
        return Color(0xFF6c7c89);
        break;
      case UserRoleLevel.Master:
        return Color(0xFFe1243d);
        break;
      case UserRoleLevel.Vip:
        return Color(0xFFdca3ab);
        break;
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    _context = context;
    return Scaffold(
      backgroundColor: AppColor.tableViewGrayColor,
      appBar: CustomAppBar(
        appBackground: getAppBarColor(),
        title: "购物车($_totalNum)",
        actions: <Widget>[
          CustomImageButton(
            padding: EdgeInsets.only(right: rSize(10), top: rSize(5)),
            title: !_manageStatus ? "管理" : "完成",
            color: Colors.white,
            fontSize: ScreenAdapterUtils.setSp(15),
            onPressed: () {
              if (_editting) {
                FocusScope.of(context).requestFocus(FocusNode());
                return;
              }
              // 切换管理状态  重置所以数据到原始数据
              // for (ShoppingCartBrandModel _brandModel in _controller.getData()) {
              //   _brandModel.selected = false;
              //   for (ShoppingCartGoodsModel _goodsModel in _brandModel.children) {
              //     _goodsModel.selected = false;
              //   }
              // }
              // _checkAll = false;
              // _selectedGoods.clear();
              _manageStatus = !_manageStatus;
              setState(() {});
            },
          )
        ],
      ),
      body: _buildList(context),
      bottomNavigationBar:
          SafeArea(bottom: widget.needSafeArea, child: _bottomTool()),
    );
  }

  _bottomTool() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter bottomSetState) {
        double totalPrice = 0;
        double totalCommission = 0;
        _selectedGoods.forEach((goods) {
          totalPrice += goods.price * goods.quantity;
          totalCommission += goods.commission * goods.quantity;
        });
        _bottomStateSetter = bottomSetState;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: rSize(8)),
          color: Colors.white,
          height: rSize(49),
          child: Row(
            children: _bottomBarChildren(totalPrice,
                totalCommission: totalCommission),
          ),
        );
      },
    );
  }

  _bottomBarChildren(totalPrice, {totalCommission = 0}) {
    List<Widget> children = [];
    children..add(_checkAllButton())..add(Spacer());

    if (_manageStatus) {
      children.add(_deleteButton());
      return children;
    }

    children
      ..add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
              text: TextSpan(
                  text: "合计: ",
                  style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                      color: Colors.black.withOpacity(0.6)),
                  children: [
                TextSpan(
                    text: "${totalPrice.toStringAsFixed(2)}",
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(16),
                        color: Colors.black))
              ])),
          totalCommission > 0 && AppConfig.commissionByRoleLevel
              ? Text(
                  "赚${totalCommission.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: AppColor.themeColor,
                      fontSize: ScreenAdapterUtils.setSp(11)),
                )
              : Container()
        ],
      ))
      ..add(Container(
        width: 10,
      ))
      ..add(_settlementButton());
    return children;
  }

  Container _settlementButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(3)),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 249, 117, 10),
            Color.fromARGB(255, 249, 67, 7),
          ])),
      child: CustomImageButton(
        padding:
            EdgeInsets.symmetric(vertical: rSize(3), horizontal: rSize(18)),
        title: "结算(${_selectedGoods.length})",
        color: Colors.white,
        fontSize: ScreenAdapterUtils.setSp(14),
        onPressed: () {
          if (_selectedGoods.length == 0) {
            Toast.showInfo("您还没有选择商品");
            return;
          }
          GSDialog.of(context).showLoadingDialog(_context, "");
          _presenter.submitOrder(
              UserManager.instance.user.info.id,
              _selectedGoods.map<int>((goods) {
                return goods.shoppingTrolleyId;
              }).toList());
        },
      ),
    );
  }

  CustomImageButton _checkAllButton() {
    return CustomImageButton(
      direction: Direction.horizontal,
      title: "全选",
      fontSize: ScreenAdapterUtils.setSp(14),
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
        // 如果不是编辑状态 只能选中没有在活动中的商品
        _controller.getData().forEach((brand) {
          brand.selected = _checkAll;
          brand.children.forEach((goods) {
            if (_checkAll) {
              _selectedGoods.add(goods);
            }
            goods.selected = _checkAll;
          });
        });
        setState(() {});
      },
    );
  }

  CustomImageButton _deleteButton() {
    return CustomImageButton(
      title: "删除(${_selectedGoods.length})",
      fontSize: ScreenAdapterUtils.setSp(14),
      padding: EdgeInsets.symmetric(horizontal: rSize(18), vertical: rSize(3)),
      borderRadius: BorderRadius.all(Radius.circular(50)),
      border: Border.all(width: 0.5, color: Colors.red),
      color: Colors.red,
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
                _presenter.deleteFromShoppingCart(
                    UserManager.instance.user.info.id,
                    _selectedGoods.map<int>((goods) {
                      return goods.shoppingTrolleyId;
                    }).toList());
              },
            ));
      },
    );
  }

  _buildList(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MvpListView(
        autoRefresh: false,
        delegate: this,
        controller: _controller,
        itemBuilder: (context, index) {
          return _buildItem(context, index);
        },
        refreshCallback: () {
          // if (UserManager.instance.haveLogin){
          _presenter.getShoppingCartList(UserManager.instance.user.info.id);
          // }else{
          //   _presenter.getShoppingCartList(0);
          // }
        },
        noDataView: noDataView("购物车是空的~快去逛逛吧"),
      ),
    );
  }

  ShoppingCartItem _buildItem(BuildContext context, int index) {
    // ShoppingCartBrandModel model = _controller.getData()[index];
    // Promotion promotion = new Promotion(11, 11, "1212", "date", 1111, "2020-05-10 11:20:00", "2020-05-11 11:20:00", 100);
    // for (ShoppingCartGoodsModel goodsModel in model.children) {
    //   if (goodsModel.promotion == null) {
    //     goodsModel.promotion = promotion;
    //     // goodsModel.promotion.startTime = "2020-05-10 11:20:00";
    //   }
    // }

    return ShoppingCartItem(
      // isEdit: _manageStatus,
      isEdit: true,
      model: _controller.getData()[index],
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
          _controller.requestRefresh();
        });
      },
      onBeginInput: (value) {
        _editting = true;
      },
      numUpdateCompleteCallback: (goods, num) {
        _editting = false;
        _presenter.updateQuantity(
            UserManager.instance.user.info.id, goods, num);
      },
    );
  }

  @override
  refreshSuccess(data) {
    // refreshSuccess(List<ShoppingCartBrandModel> data) {
    _checkAll = false;
    _selectedGoods.clear();
    _totalNum = 0;
    data.forEach((brand) {
      _totalNum += brand.children.length;
    });
    setState(() {});
  }

  @override
  MvpListViewPresenterI<ShoppingCartBrandModel, MvpView, MvpModel>
      getPresenter() {
    return _presenter;
  }

  @override
  void updateNumSuccess(ShoppingCartGoodsModel goods, int num) {
    goods.quantity = num;
    setState(() {});
    UserManager.instance.refreshShoppingCartNumber.value = true;
  }

  @override
  void updateNumFail(String msg) {
    Toast.showError(msg);
    setState(() {});
  }

  @override
  void deleteGoodsSuccess() {
    Toast.showInfo("删除成功");
    if (_context != null) {
      Alert.dismiss(_context);
    }
    setState(() {
      _manageStatus = false;
    });
    _presenter.getShoppingCartList(UserManager.instance.user.info.id);

    UserManager.instance.refreshShoppingCartNumber.value = true;
  }

  @override
  void submitOrderSuccess(OrderPreviewModel model) {
    GSDialog.of(context).dismiss(_context);
    AppRouter.push(context, RouteName.GOODS_ORDER_PAGE,
            arguments: GoodsOrderPage.setArguments(model))
        .then((value) {
      _controller.requestRefresh();
    });
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  void failure(String msg) {
    GSDialog.of(context).dismiss(_context);
    GSDialog.of(context).showError(globalContext, msg);
  }
}
