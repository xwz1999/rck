/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/20  4:57 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/address_list_model.dart';
import 'package:jingyaoyun/models/order_preview_model.dart';
import 'package:jingyaoyun/pages/user/address/mvp/address_mvp_contact.dart';
import 'package:jingyaoyun/pages/user/address/mvp/address_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/address/new_address_page.dart';
import 'package:jingyaoyun/pages/user/address/widgets/item_my_address.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:jingyaoyun/widgets/no_data_view.dart';
import 'package:jingyaoyun/widgets/toast.dart';

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
        title: "??????????????????",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        backEvent: () {
          if (_shouldUpdated) {
            if (_originAddr == null) {
              // ?????????????????????????????????  ??????????????????????????????????????????????????????????????????
              Navigator.pop(globalContext, _defaultAddress);
              return;
            }
            // ??????????????????????????????  ????????????????????????????????????????????????????????????????????????????????????????????????
            Navigator.pop(
                globalContext,
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
            title: "??????????????????",
            padding: EdgeInsets.symmetric(horizontal: 10),
            fontSize: 14 * 2.sp,
            onPressed: () async {
              await CRoute.push(
                  context,
                  NewAddressPage(
                    isFirstAdd: _controller.getData().isEmpty,
                  )).then((newAddress) {
                if ((newAddress is Address)) {
                  if (_originAddr == null) {
                    _shouldUpdated = true;
                  }
                  GSDialog.of(context).showSuccess(context, "??????????????????");
                  _presenterImpl
                      .fetchAddressList(UserManager.instance.user.info.id);
                }
                setState(() {});
              });
              _controller.requestRefresh();
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
        title: "????????????????????????",
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
        print("?????????-------");
        Navigator.of(context).pop(address);
      },
      child: MyAddressItem(
        addressModel: address,
        deleteListener: () {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.delete,
                content: "????????????????????????",
                items: ["??????"],
                deleteItem: "????????????",
                listener: (index) {
                  print(index);
                  Alert.dismiss(context);
                },
                deleteListener: () {
                  Alert.dismiss(context);
                  _presenterImpl.deleteAddress(
                      UserManager.instance.user.info.id, address);
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
              GSDialog.of(context).showSuccess(context, "??????????????????");
              _presenterImpl
                  .fetchAddressList(UserManager.instance.user.info.id);
            }
          });
        },
        setDefaultListener: () {
          if (_defaultAddress == address) return;
          _presenterImpl.setDefaultAddress(
              UserManager.instance.user.info.id, address);
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
    GSDialog.of(context).showSuccess(globalContext, "????????????");
    setState(() {
      _controller.getData().remove(address);
    });
  }

  @override
  setDefaultSuccess(Address address) {
    Toast.showInfo("????????????");
    print("????????????-------");
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
