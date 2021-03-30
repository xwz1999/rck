/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-21  15:03 
 * remark    : 
 * ====================================================
 */

import 'package:recook/base/http_result_model.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/user_brief_info_model.dart';
import 'package:recook/pages/user/mvp/user_model_impl.dart';
import 'user_mvp_contact.dart';

class UserPresenterImpl extends UserMvpPresenterI {
  @override
  UserMvpModelI initModel() {
    return UserModelImpl();
  }

  @override
  Future<HttpResultModel<UserBrief>> getUserBriefInfo(int userId) async {
    ResultData resultData = await getModel().getUserBriefInfo(userId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    UserBriefInfoModel infoModel = UserBriefInfoModel.fromJson(resultData.data);
    if (infoModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(infoModel.code, null, infoModel.msg, false);
    }
    return HttpResultModel(infoModel.code, infoModel.data, infoModel.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel>> updateHeaderPic(int userId, String headUrl) async{
    ResultData resultData = await getModel().updateHeaderPic(userId, headUrl);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel>> updateUserNickname(int userId, String nickname) async{
    ResultData resultData = await getModel().updateUserNickname(userId, nickname);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  updateBirthday(int userId, String birthday) async{
    ResultData resultData = await getModel().updateBirthday(userId, birthday);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  updateGender(int userId, int gender) async{
    ResultData resultData = await getModel().updateGender(userId, gender);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  realBinding(int userId, String idCardName, String idCardNo, String bankName, String bankNo) async{
    ResultData resultData = await getModel().realBinding(userId, idCardName, idCardNo, bankName, bankNo)  ;
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  updateAddress(int userId, String address) async {
    ResultData resultData = await getModel().updateAddress(userId, address);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  updatePhone(int userId, String phone) async {
    ResultData resultData = await getModel().updatePhone(userId, phone);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  updateWechatNo(int userId, String wechatNo) async {
    ResultData resultData = await getModel().updateWechatNo(userId, wechatNo);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }
  
  @override
  realInfo(int userId, String realName, String idNum) async {
    ResultData resultData = await getModel().realInfo(userId, realName, idNum);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }
}

