/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/21  2:19 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/address_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class AddressPresenterI extends MvpListViewPresenterI<Address,AddressViewI,AddressModelI>{
  fetchAddressList(int userId);
  setDefaultAddress(int userId, Address address);
  deleteAddress(int userId, Address address);
}

abstract class AddressViewI extends MvpView{
  setDefaultSuccess(Address address);
  deleteSuccess(Address address);
  requestFail(String msg);
}

abstract class AddressModelI extends MvpModel{
  fetchAddressList(int? userId);
  setDefaultAddress(int? userId, int? addrId);
  deleteAddress(int? userId, int? addrId);

  fetchWholeProvince();
  addNewAddress(int userId,String name,String province, String city, String district, String address, String mobile, int isDefault);
  updateAddress(int addrId, int userId,String name,String province, String city, String district, String address, String mobile, int isDefault);
}
