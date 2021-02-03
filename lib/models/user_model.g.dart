// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
      json['data'] == null
          ? null
          : User.fromJson(json['data'] as Map<String, dynamic>),
      json['code'] as String,
      json['msg'] as String);
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['auth'] == null
          ? null
          : Tkn.fromJson(json['auth'] as Map<String, dynamic>),
      json['info'] == null
          ? null
          : Info.fromJson(json['info'] as Map<String, dynamic>),
      json['status'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'auth': instance.auth,
      'info': instance.info,
      'status': instance.status
    };

Info _$InfoFromJson(Map<String, dynamic> json) {
  return Info(
      json['id'] as int,
      json['nickname'] as String,
      json['headImgUrl'] as String,
      json['wxOpenId'] as String,
      json['wxUnionId'] as String,
      json['mobile'] as String,
      json['identityCardName'] as String,
      json['identityCardNo'] as String,
      json['gender'] as int,
      json['birthday'] as String,
      json['invitationNo'] as String,
      json['offlineStoreId'] as int,
      json['level'] as int,
      json['balance'] as int,
      json['coin'] as int,
      json['createdAt'] as String,
      json['updatedAt'] as String,
      json['deletedAt'] as String,
      json['isVerified'] as bool,
      json['role'] as int,
      json['addr'] as String,
      json['phone'] as String,
      json['wechatNo'] as String,
      json['remarkName'] as String,
      json['introCode'] as String,
      json['upgradeCode'] as String,
      json['roleId'] as int,
      json['roleLevel'] as int,
      json['userLevel'] as int,
      json['isSetPayPwd'] as bool,
      json['realInfoStatus'] as bool,
      json['realName'] as String,
      json['idCard'] as String,
      json['teacherWechatNo']as String,
      );
}

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'headImgUrl': instance.headImgUrl,
      'wxOpenId': instance.wxOpenId,
      'wxUnionId': instance.wxUnionId,
      'mobile': instance.mobile,
      'identityCardName': instance.identityCardName,
      'identityCardNo': instance.identityCardNo,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'invitationNo': instance.invitationNo,
      'offlineStoreId': instance.offlineStoreId,
      'level': instance.level,
      'balance': instance.balance,
      'coin': instance.coin,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isVerified': instance.isVerified,
      'role': instance.role,
      'addr': instance.addr,
      'phone' : instance.phone,
      'wechatNo': instance.wechatNo,
      'remarkName': instance.remarkName,
      'introCode': instance.introCode,
      'upgradeCode': instance.upgradeCode,
      'roleId': instance.roleId,
      'roleLevel': instance.roleLevel,
      'userLevel': instance.userLevel,
      'isSetPayPwd': instance.isSetPayPwd,
      'realInfoStatus': instance.realInfoStatus,
    };

Tkn _$TknFromJson(Map<String, dynamic> json) {
  return Tkn(json['id'] as int, json['token'] as String);
}

Map<String, dynamic> _$TknToJson(Tkn instance) =>
    <String, dynamic>{'id': instance.id, 'token': instance.token};
