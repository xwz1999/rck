/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/21  3:06 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/address/mvp/address_mvp_contact.dart';

class AddressModelImpl extends AddressModelI{
  @override
  Future<ResultData> fetchAddressList(int? userId) async {
    ResultData res = await HttpManager.post(UserApi.address_list, {
      "userId":userId
    });
    return res;
  }

  @override
  Future<ResultData> deleteAddress(int? userId, int? addrId) async {
    ResultData res = await HttpManager.post(UserApi.address_delete, {
      "userId":userId,
      "addrId":addrId
    });
    return res;  }

  @override
  Future<ResultData> setDefaultAddress(int? userId, int? addrId) async {

    ResultData res = await HttpManager.post(UserApi.address_set_default, {
      "userId":userId,
      "addrId":addrId
    });
    return res;
  }

  @override
  Future<ResultData> fetchWholeProvince() async{
    ResultData res = await HttpManager.post(UserApi.address_whole_province_city, null);
    return res;
  }

  @override
  Future<ResultData> addNewAddress(int? userId, String? name, String? province, String? city, String? district, String? address, String? mobile, int? isDefault) async {
    Map params = {
      "userId" : userId,
      "name":name,
      "province":province,
      "city":city,
      "district":district,
      "address":address,
      "mobile":mobile,
      "isDefault": isDefault
    };
    ResultData res = await HttpManager.post(UserApi.address_new_address, params);
    return res;
  }

  @override
  updateAddress(int? addrId, int? userId, String? name, String? province, String? city, String? district, String? address, String? mobile, int? isDefault) async {
    Map params = {
      "addrId":addrId,
      "userId" : userId,
      "name":name,
      "province":province,
      "city":city,
      "district":district,
      "address":address,
      "mobile":mobile,
      "isDefault": isDefault
    };
    ResultData res = await HttpManager.post(UserApi.address_update, params);
    return res;
  }
}
