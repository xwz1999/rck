/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/21  3:04 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/address_list_model.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/pages/user/address/mvp/address_model_impl.dart';
import 'package:recook/pages/user/address/mvp/address_mvp_contact.dart';

class AddressPresenterImpl extends AddressPresenterI {
  @override
  AddressModelI initModel() {
    return AddressModelImpl();
  }

  @override
  fetchAddressList(int userId) async {
    ResultData res = await getModel().fetchAddressList(userId);
    if (!res.result) {
      getRefreshView().refreshFailure(res.msg);
      return;
    }

    AddressListModel model = AddressListModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      getRefreshView().refreshFailure(model.msg);
      return;
    }
    getRefreshView().refreshSuccess(model.data);
  }

  @override
  deleteAddress(int userId,  Address address) async {
    ResultData res = await getModel().deleteAddress(userId, address.id);
    if (!res.result) {
      getRefreshView().refreshFailure(res.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      getRefreshView().refreshFailure(model.msg);
      return;
    }
    getView().deleteSuccess(address);
  }

  @override
  setDefaultAddress(int userId,  Address address) async {
    ResultData res = await getModel().setDefaultAddress(userId, address.id);
    if (!res.result) {
      getRefreshView().refreshFailure(res.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      getRefreshView().refreshFailure(model.msg);
      return;
    }
    getView().setDefaultSuccess(address);
  }
}
