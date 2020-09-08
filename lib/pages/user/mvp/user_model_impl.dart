/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-21  15:04 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';

import 'user_mvp_contact.dart';

class UserModelImpl extends UserMvpModelI {

  @override
  getUserBriefInfo(int userId) async {
    ResultData resultData = await HttpManager.post(UserApi.brief_info, {"userId": userId});
    return resultData;
  }

  @override
  updateHeaderPic(int userId, String headUrl) async {
    ResultData resultData = await HttpManager.post(UserApi.updateAvatar, {
      "userId": userId,
      "headUrl":headUrl
    });
    return resultData;
  }

  @override
  updateUserNickname(int userId, String nickname) async{
    ResultData resultData = await HttpManager.post(UserApi.updateNickname, {
      "userId": userId,
      "nickname":nickname
    });
    return resultData;
  }

  @override
  updateBirthday(int userId, String birthday)  async{
    ResultData resultData = await HttpManager.post(UserApi.updateBirthday, {
      "userId": userId,
      "birthday":birthday
    });
    return resultData;
  }

  @override
  updateGender(int userId, int gender) async{
    ResultData resultData = await HttpManager.post(UserApi.updateGender, {
      "userId": userId,
      "gender":gender
    });
    return resultData;
  }

  @override
  realBinding(int userId, String idCardName, String idCardNo, String bankName, String bankNo) async{
    ResultData resultData = await HttpManager.post(UserApi.realBinding, {
      "userId": userId,
      "idCardName":idCardName,
      "idCardNo":idCardNo,
      "bankName":bankName,
      "bankNo":bankNo
    });
    return resultData;
  }

  @override
  updateAddress(int userId, String address) async {
    ResultData resultData = await HttpManager.post(UserApi.updateAddress, {
      "userID": userId,
      "address": address
    });
    return resultData;
  }

  @override
  updatePhone(int userId, String phone) async {
    ResultData resultData = await HttpManager.post(UserApi.updatePhone, {
      "userID": userId,
      "phone": phone
    });
    return resultData;
  }

  @override
  updateWechatNo(int userId, String wechatNo) async {
    ResultData resultData = await HttpManager.post(UserApi.updateWechatNo, {
      "userID": userId,
      "wechatNo": wechatNo
    });
    return resultData;
  }

  @override
  realInfo(int userId, String realName, String idNum) async {
    ResultData resultData = await HttpManager.post(UserApi.realInfo, {
      "userId": userId,
      "realName": realName,
      "idNum": idNum
    });
    return resultData;
  }
  
}
