/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/20  4:57 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/address_list_model.dart';
import 'package:recook/models/order_preview_model.dart';
import 'package:recook/pages/user/address/mvp/address_mvp_contact.dart';
import 'package:recook/pages/user/address/mvp/address_presenter_impl.dart';
import 'package:recook/pages/user/address/new_address_page.dart';
import 'package:recook/pages/user/address/widgets/item_my_address.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/toast.dart';

class ReceivingAddressPage extends StatefulWidget {
  final Map arguments;

  const ReceivingAddressPage({Key key, this.arguments}) : super(key: key);

  static setArguments({bool canBack = false, Addr addr}) {
    return {"canBack": canBack, "originAddr": addr};
  }

  @override
  State<StatefulWidget> createState() {
    return _ReceivingAddressPageState();
  }
}

class _ReceivingAddressPageState extends BaseStoreState<ReceivingAddressPage>
    with MvpListViewDelegate<Address>
    implements AddressViewI {
  AddressPresenterImpl _presenterImpl;
  MvpListViewController<Address> _controller = MvpListViewController();
  Address _defaultAddress;
  BuildContext _context;
  bool _canBack;
  Addr _originAddr;
  bool _shouldUpdated = false;

  @override
  void initState() {
    super.initState();
    _presenterImpl = AddressPresenterImpl();
    _presenterImpl.attach(this);
    if (widget.arguments != null) {
      _canBack = widget.arguments["canBack"];
      _originAddr = widget.arguments["originAddr"];
    } else {
      _canBack = false;
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    _context = context;
    return Scaffold(
      appBar: CustomAppBar(
        title: "我的收货地址",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        backEvent: () {
          if (_shouldUpdated) {
            if (_originAddr == null) {
              // 这是预览订单没有地址时  跳转过来添加地址后，再返回时默认使用默认地址
              Navigator.pop(globalContext, _defaultAddress);
              return;
            }
            // 这是预览订单有地址时  跳转过来添加地址后，如果改变了地址信息，再返回是需要更新地址信息
            Navigator.pop(globalContext,
                Address(
                    _originAddr.addressId,
                    _originAddr.receiverName,
                    _originAddr.mobile,
                    _originAddr.province,
                    _originAddr.city,
                    _originAddr.district,
                    _originAddr.address,
                    1));
            return;
          }
          pop();
        },
        actions: <Widget>[
          CustomImageButton(
            title: "添加收货地址",
            padding: EdgeInsets.symmetric(horizontal: 10),
            fontSize: ScreenAdapterUtils.setSp(14),
            onPressed: () {
              AppRouter.push(_context, RouteName.NEW_ADDRESS_PAGE).then((newAddress) {
                if ((newAddress is Address)) {
                  if (_originAddr == null) {
                    _shouldUpdated = true;
                  }
                  GSDialog.of(context).showSuccess(context, "添加地址成功");
                  _presenterImpl.fetchAddressList(UserManager.instance.user.info.id);
                }
              });
            },
          )
        ],
      ),
      backgroundColor: AppColor.tableViewGrayColor,
      body: _listView(),
    );
  }

  _listView() {
    return MvpListView<Address>(
      delegate: this,
      controller: _controller,
      itemBuilder: (_, index) {
        return _itemBuilder(_, index);
      },
      refreshCallback: () {
        _presenterImpl.fetchAddressList(UserManager.instance.user.info.id);
      },
      noDataView: NoDataView(
        title: "您还没有添加地址",
        height: 400,
      ),
    );
  }

  _itemBuilder(BuildContext context, int index) {
    Address address = _controller.getData()[index];
    if (address.isDefault == 1) {
      _defaultAddress = address;
    }
    return GestureDetector(
      onTap: () {
        if (!_canBack) return;
        print("返回了-------");
        Navigator.of(context).pop(address);
      },
      child: MyAddressItem(
        addressModel: address,
        deleteListener: () {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.delete,
                content: "确定删除该地址吗",
                items: ["取消"],
                deleteItem: "删除地址",
                listener: (index) {
                  print(index);
                  Alert.dismiss(context);
                },
                deleteListener: () {
                  Alert.dismiss(context);
                  _presenterImpl.deleteAddress(UserManager.instance.user.info.id, address);
                },
              ));
        },
        editListener: () {
          AppRouter.push(_context, RouteName.NEW_ADDRESS_PAGE,
                  arguments: NewAddressPage.setArguments(address))
              .then((newAddress) {
            if (newAddress != null) {
              // if ((newAddress as Address).id == _originAddr.addressId) {
                _shouldUpdated = true;
              // }
              GSDialog.of(context).showSuccess(context, "更新地址成功");
              _presenterImpl.fetchAddressList(UserManager.instance.user.info.id);
            }
          });
        },
        setDefaultListener: () {
          if (_defaultAddress == address) return;
          _presenterImpl.setDefaultAddress(UserManager.instance.user.info.id, address);
        },
      ),
    );
  }

  @override
  MvpListViewPresenterI<Address, MvpView, MvpModel> getPresenter() {
    return _presenterImpl;
  }

  @override
  deleteSuccess(Address address) {
    GSDialog.of(context).showSuccess(globalContext, "删除成功");
    setState(() {
      _controller.getData().remove(address);
    });
  }

  @override
  setDefaultSuccess(Address address) {
    Toast.showInfo("设置成功");
    print("设置默认-------");
    address.isDefault = 1;
    _defaultAddress.isDefault = 0;
    _defaultAddress = address;
    setState(() {});
  }

  @override
  requestFail(String msg) {
    GSDialog.of(context).dismiss(globalContext);
    GSDialog.of(context).showError(globalContext, msg);
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}
}
