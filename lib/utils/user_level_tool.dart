/*
// ----- 用户等级（user level）
PartnerLevel = 1   合伙人
TopLevel     = 10  顶级
FirstLevel   = 20  一级
SecondLevel  = 30  二级
OthersLevel  = 40  其他
// ----- 角色等级(role level )
Diamond1Level = 100    钻一店铺
Diamond2Level = 130    钻二店铺
Diamond3Level = 160    钻三店铺
GoldLevel    = 200    黄金店铺
SilverLevel  = 300    白银店铺
MasterLevel  = 400    店主 
VipLevel     = 500    会员
*/

import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

enum UserLevel { None, Partner, Top, First, Second, Others }
enum UserRoleLevel {
  ///无
  None,


  ///黄金
  Gold,

  ///白银
  Silver,

  ///店主
  Master,

  ///会员
  Vip,

  ///店铺
  Shop,

  ///实体店
  physical,

  ///子公司
  subsidiary,
}

class UserLevelTool {

  static UserRoleLevel roleLevelEnum(int level) {
    UserRoleLevel userRoleLevel;
    if (level == null) {
      return UserRoleLevel.Vip;
    }
    switch (level) {
      case 0:
        userRoleLevel = UserRoleLevel.Vip;
        break;
      case 1:
        userRoleLevel = UserRoleLevel.Master;
        break;
      case 2:
        if(UserManager.instance.userBrief.isOffline){
          userRoleLevel = UserRoleLevel.physical;
        }else{
          userRoleLevel = UserRoleLevel.Shop;
        }
        break;
      case 10:
        userRoleLevel = UserRoleLevel.subsidiary;
        break;
      default:
        userRoleLevel = UserRoleLevel.Vip;
        break;
    }
    return userRoleLevel;
  }


  static UserRoleLevel currentRoleLevelEnum() {
    return roleLevelEnum(UserManager.instance.userBrief.level);
  }


  static roleLevelWidget({String level}) {
    return CustomImageButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      backgroundColor: Color(0xFFF6CB88),
      fontSize: 10 * 2.sp,
      color: Color(0xFFAE5930),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      direction: Direction.horizontal,
      contentSpacing: 2,
      icon: Image.asset(
        currentUserLevelIcon(),
        width: 13,
        height: 13,
      ),
      // icon: Icon(
      //   Icons.star_border,
      //   size: rSize(13),
      // ),
      title:
          TextUtils.isEmpty(level) ? UserLevelTool.currentRoleLevel() : level,
    );
  }

  static String currentUpgradeRoleLevelIcon() {
    return upgradeRoleLevelIcon(currentRoleLevelEnum());
  }


  static String upgradeRoleLevelIcon(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Silver:
        return R.ASSETS_UPGRADE_ICON_SILVER_PNG;
        break;
      case UserRoleLevel.Gold:
        return R.ASSETS_UPGRADE_ICON_GOLD_PNG;
        break;
      case UserRoleLevel.Master:
        return R.ASSETS_UPGRADE_ICON_MASTER_PNG;
        break;
      default:
        return R.ASSETS_UPGRADE_ICON_VIP_PNG;
    }
  }

  static String currentUserLevelIcon() {
    return userLevelIcon(currentRoleLevelEnum());
  }

  static String userLevelIcon(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Vip:
        return R.ASSETS_USER_LEVEL_ICON_MASTER_PNG;
        break;
      case UserRoleLevel.Shop:
        return R.ASSETS_USER_LEVEL_ICON_DIAMOND_PNG;
        break;
      case UserRoleLevel.Master:
        return R.ASSETS_USER_LEVEL_ICON_SILVER_PNG;
        break;
      default:
        return R.ASSETS_USER_LEVEL_ICON_MASTER_PNG;
    }
  }

  static String currentCardImagePath() {
    return cardImagePath(currentRoleLevelEnum());
  }

  static String currentMedalImagePath() {
    return cardBadge(currentRoleLevelEnum());
  }

  static String cardBadge(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Master:
        return R.ASSETS_SHOP_SILVER_BADGE_PNG;
        break;
      case UserRoleLevel.Shop:
        return R.ASSETS_SHOP_DIAMOND_BADGE_PNG;
        break;
      case UserRoleLevel.Vip:
        return R.ASSETS_SHOP_MASTER_BADGE_PNG;
        break;
      default:
        return "";
    }
  }

  static String cardImagePath(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Master:
        return R.ASSETS_SHOP_SILVER_BG_WEBP;
        break;
      case UserRoleLevel.Shop:
        return R.ASSETS_SHOP_DIAMOND_BG_WEBP;
        break;
      case UserRoleLevel.Vip:
        return R.ASSETS_SHOP_MASTER_BG_WEBP;
        break;
      default:
        return R.ASSETS_SHOP_MASTER_BG_WEBP;
    }
  }

  static String get userCardBackground {
    switch (UserLevelTool.currentRoleLevelEnum()) {
      case UserRoleLevel.Vip:
        return R.ASSETS_USER_NORMAL_WEBP;
        break;
      case UserRoleLevel.Shop:
        return R.ASSETS_USER_DIAMOND_WEBP;
        break;
      case UserRoleLevel.Master:
        return R.ASSETS_USER_SLIVER_WEBP;
        break;
      default:
        return R.ASSETS_USER_NORMAL_WEBP;
        break;
    }
  }



  static String currentAppBarBGImagePath() {
    return appBarBGImagePath(UserLevelTool.currentRoleLevelEnum());
  }

  static String appBarBGImagePath(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Vip:
        return R.ASSETS_HEADER_MASTER_HEADER_PNG;
        break;
      case UserRoleLevel.Shop:
        return R.ASSETS_HEADER_DIAMOND_HEADER_PNG;
        break;
      case UserRoleLevel.Master:
        return R.ASSETS_HEADER_SILVER_HEADER_PNG;
        break;
      default:
        return R.ASSETS_HEADER_MASTER_HEADER_PNG;
        break;
    }
  }



  static String currentRoleLevel() {
    return roleLevel(UserManager.instance.userBrief.level);
  }

  static String roleLevel(int level) {
    if (level == null) {
      return "";
    }
    String roleLevel = "";
    switch (level) {
      case 0:
        roleLevel = "会员";
        break;
      case 1:
        roleLevel = "店主";
        break;
      case 2:
        if(UserManager.instance.userBrief.isOffline){
          roleLevel = "实体店";
        }else{
          roleLevel = "店铺";
        }

        break;
      case 10:
        roleLevel = "子公司";
        break;
      default:
        roleLevel = "会员";
        break;
    }
    return roleLevel;
  }

  static String roleLevelWithEnum(UserRoleLevel level) {
    if (level == null) {
      return "";
    }
    String roleLevel = "";
    switch (level) {
      case UserRoleLevel.Shop:
        roleLevel = "店铺";
        break;
      case UserRoleLevel.Master:
        roleLevel = "店主";
        break;
      case UserRoleLevel.Vip:
        roleLevel = "会员";
        break;
      case UserRoleLevel.physical:
        roleLevel = "实体店";
        break;
      case UserRoleLevel.subsidiary:
        roleLevel = "子公司";
        break;
      default:
        roleLevel = "会员";
        break;
    }
    return roleLevel;
  }




  ///获取用户的名片的角色 icon
  static String getRoleLevelIcon(UserRoleLevel level) {
    switch (level) {
      case UserRoleLevel.Shop:
        return R.ASSETS_USER_ICON_DIAMOND_PNG;
      case UserRoleLevel.Master:
        return R.ASSETS_USER_ICON_SLIVER_PNG;
      case UserRoleLevel.Vip:
        return R.ASSETS_USER_ICON_MASTER_PNG;
      default:
        return R.ASSETS_USER_ICON_MASTER_PNG;
    }
  }

  ///当前用户的名片角色
  static String get roleLevelIcon => getRoleLevelIcon(currentRoleLevelEnum());
}
