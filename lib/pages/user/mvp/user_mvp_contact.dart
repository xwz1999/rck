/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-21  15:01 
 * remark    : 
 * ====================================================
 */

import 'package:recook/utils/mvp.dart';

abstract class UserMvpPresenterI extends MvpPresenter<UserMvpViewI, UserMvpModelI> {
  getUserBriefInfo(int userId);
  updateUserNickname(int userId, String nickname);
  updateHeaderPic(int userId, String headUrl);
  updateGender(int userId, int gender);
  updateBirthday(int userId, String birthday);
  updateAddress(int userId, String address);
  updatePhone(int userId, String phone);
  updateWechatNo(int userId, String wechatNo);
  realBinding(int userId, String idCardName, String idCardNo, String bankName, String bankNo);
  realInfo(int userId, String realName, String idNum,); // 实名认证
}

abstract class UserMvpModelI extends MvpModel {
  getUserBriefInfo(int? userId);
  updateUserNickname(int? userId, String nickname);
  updateHeaderPic(int? userId, String? headUrl);
  updateGender(int? userId, int gender);
  updateBirthday(int? userId, String birthday);
  updateAddress(int? userId, String address);
  updatePhone(int? userId, String phone);
  updateWechatNo(int? userId, String wechatNo);
  realBinding(int userId, String idCardName, String idCardNo, String bankName, String bankNo);
  realInfo(int? userId, String realName, String idNum,); // 实名认证
}

abstract class UserMvpViewI extends MvpView {

}
