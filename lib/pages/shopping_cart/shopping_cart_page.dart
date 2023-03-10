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
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/models/order_preview_model.dart';
import 'package:jingyaoyun/models/shopping_cart_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/classify/order_preview_page.dart';
import 'package:jingyaoyun/pages/home/items/item_brand_like_grid.dart';
import 'package:jingyaoyun/pages/shopping_cart/item/item_shopping_cart.dart';
import 'package:jingyaoyun/pages/shopping_cart/mvp/shopping_cart_contact.dart';
import 'package:jingyaoyun/pages/shopping_cart/mvp/shopping_cart_presenter_impl.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'function/shopping_cart_fuc.dart';

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
  List<ShoppingCartGoodsModel> _selectedGoods = [];
  GoodsSimpleListModel goodsSimpleListModel;
  List<GoodsSimple> _likeGoodsList = [];
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
    Future.delayed(Duration.zero, () async {
      int userid;
      if (UserManager.instance.user.info.id == null) {
        userid = 0;
      } else {
        userid = UserManager.instance.user.info.id;
      }
      _likeGoodsList = await ShoppingCartFuc.getLikeGoodsList(userid);
      // if (goodsSimpleListModel != null) {
      //   _likeGoodsList = goodsSimpleListModel.data;
      // }

      setState(() {});
    });
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


  @override
  Widget buildContext(BuildContext context, {store}) {
    _context = context;
    return Scaffold(
      backgroundColor: AppColor.tableViewGrayColor,
      appBar: PreferredSize(
        child: Stack(
          children: [
            Image.asset(
              UserLevelTool.currentAppBarBGImagePath(),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            AppBar(
              leading: RecookBackButton(white: true,),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text("?????????($_totalNum)"),
              actions: <Widget>[
                CustomImageButton(
                  padding: EdgeInsets.only(right: rSize(10), top: rSize(5)),
                  title: !_manageStatus ? "??????" : "??????",
                  color: Colors.white,
                  fontSize: 15 * 2.sp,
                  onPressed: () {
                    if (_editting) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      return;
                    }
                    //??????????????????  ?????????????????????????????????
                    for (ShoppingCartBrandModel _brandModel
                        in _controller.getData()) {
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
          ],
        ),
        preferredSize: Size.fromHeight(30 + MediaQuery.of(context).padding.top),
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
          height: rSize(65),
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
                  text: "??????: ",
                  style: AppTextStyle.generate(14 * 2.sp,
                      color: Colors.black),
                  children: [
                    TextSpan(
                        text: "??",
                        style:
                        AppTextStyle.generate(13 * 2.sp, color: Color(0xffc70404),fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "${totalPrice.toStringAsFixed(2)}",
                    style:
                        AppTextStyle.generate(22 * 2.sp, color: Color(0xffc70404),fontWeight: FontWeight.bold))
              ])),
          totalCommission > 0 && AppConfig.commissionByRoleLevel
              ? Text(
                  "??? ??${totalCommission.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: AppColor.themeColor, fontSize: 14 * 2.sp),
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
            EdgeInsets.symmetric(vertical: rSize(9), horizontal: rSize(23)),
        title: "??????(${_selectedGoods.length})",
        color: Colors.white,
        fontSize: 16 * 2.sp,
        onPressed: () {
          if (_selectedGoods.length == 0) {
            Toast.showInfo("????????????????????????");
            return;
          }

          //ReToast.loading();
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
      title: "??????",
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
        // ????????????????????? ??????????????????
        // ???????????????????????? ??????????????????????????????
        _controller.getData().forEach((brand) {
          brand.selected = _checkAll;
          brand.children.forEach((goods) {
            if (_checkAll) {
              if(goods.publishStatus!=0){//??????????????????
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

  CustomImageButton _deleteButton() {
    return CustomImageButton(
      title: "??????(${_selectedGoods.length})",
      fontSize: 14 * 2.sp,
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
          Toast.showInfo("????????????????????????");
          return;
        }

        Alert.show(
            context,
            NormalTextDialog(
              content: "????????????${_selectedGoods.length}????????????????",
              items: ["????????????"],
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

  _buildLikeTitle() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22.rw,
            height: 2.rw,
            decoration: BoxDecoration(color: Color(0xFFC92219)),
          ),
          Container(
            width: 6.rw,
            height: 6.rw,
            decoration: BoxDecoration(
                color: Color(0xFFC92219),
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
          ),
          20.wb,
          Text(
            '??????????????????',
            style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
          ),
          20.wb,
          Container(
            width: 6.rw,
            height: 6.rw,
            decoration: BoxDecoration(
                color: Color(0xFFC92219),
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
          ),
          Container(
            width: 22.rw,
            height: 2.rw,
            decoration: BoxDecoration(color: Color(0xFFC92219)),
          ),
        ],
      ),
    );
  }

  _buildLikeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.rw),
      //height: _likeGoodsList?.length * 381.rw / 2,
      width: double.infinity,
      child: Column(
        children: [
          35.hb,
          _buildLikeTitle(),
          50.hb,
          WaterfallFlow.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight),
              physics: NeverScrollableScrollPhysics(),
              itemCount: _likeGoodsList?.length,
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                GoodsSimple goods = _likeGoodsList[index];

                return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      AppRouter.push(context, RouteName.COMMODITY_PAGE,
                          arguments:
                              CommodityDetailPage.setArguments(goods.id));
                    },
                    child: BrandLikeGridItem(goods: goods));
              }),
          40.hb,
          // Container(
          //   alignment: Alignment.center,
          //   child: Text(
          //     '???????????????~',
          //     style: TextStyle(color: Color(0xFF999999), fontSize: 14.rsp),
          //   ),
          // ),
        ],
      ),
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
          return index == _controller.getData().length - 1
              ? _buildExtraItem(context, index)
              : _buildItem(context, index);
        },
        refreshCallback: () {
          // if (UserManager.instance.haveLogin){
          _presenter.getShoppingCartList(UserManager.instance.user.info.id);

          Future.delayed(Duration.zero, () async {
            int userid;
            if (UserManager.instance.user.info.id == null) {
              userid = 0;
            } else {
              userid = UserManager.instance.user.info.id;
            }
            _likeGoodsList = await ShoppingCartFuc.getLikeGoodsList(userid);
            // if (goodsSimpleListModel != null) {
            //   _likeGoodsList = goodsSimpleListModel.data;
            // }

            setState(() {});
          });
          // }else{
          //   _presenter.getShoppingCartList(0);
          // }
        },
        noDataView: noDataView("??????????????????~???????????????"),
      ),
    );
  }

  noDataView(String text, {Widget icon}) {
    return ListView(
      //height: double.infinity,
      children: <Widget>[
        100.hb,
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
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            text,
            style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey),
          ),
        ),

        SizedBox(
          height: rSize(30),
        ),
        _likeGoodsList != null ? _buildLikeWidget() : SizedBox(),
      ],
    );
  }

  ShoppingCartItem _buildItem(BuildContext context, int index) {


    return ShoppingCartItem(
      isEdit: _manageStatus,
      //isEdit: true,
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

  _buildExtraItem(BuildContext context, int index) {
    return Column(
      children: [
        ShoppingCartItem(
          isEdit: _manageStatus,
          //isEdit: true,
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
        ),
        _likeGoodsList != null ? _buildLikeWidget() : SizedBox(),
      ],
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
    Toast.showInfo("????????????");
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
    ReToast.err(text: msg);
  }
}
