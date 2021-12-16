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

import 'package:redux/redux.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/user_role_upgrade_model.dart';
import 'package:recook/pages/shop/widget/shop_page_upgrade_alert.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/widgets/custom_image_button.dart';

enum UserLevel { None, Partner, Top, First, Second, Others }
enum UserRoleLevel {
  ///无
  None,

  ///钻1
  Diamond_1,

  ///钻2
  Diamond_2,

  ///钻3
  Diamond_3,

  ///黄金
  Gold,

  ///白银
  Silver,

  ///店主
  Master,

  ///会员
  Vip,

  ///店铺
  Shop
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
        userRoleLevel = UserRoleLevel.Shop;
        break;
      default:
        userRoleLevel = UserRoleLevel.Vip;
        break;
    }
    return userRoleLevel;
  }












  static showUpgradeWidget(UserRoleUpgradeModel model, BuildContext context,
      Store<RecookState> store) {
    if (model != null && model.data != null && model.data.upGrade == 1) {
      UserManager.instance.user.info.roleLevel = model.data.roleLevel;
      UserManager.instance.user.info.userLevel = model.data.userLevel;
      UserManager.instance.refreshUserRole.value =
          !UserManager.instance.refreshUserRole.value;
      UserManager.updateUserInfo(store);
      showDialog(
          context: context,
          builder: (context) => GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: RoleLevelUpgradeAlert(
                  userLevel: UserLevelTool.userLevelEnum(model.data.userLevel),
                  width: MediaQuery.of(context).size.width,
                  userRoleLevel:
                      UserLevelTool.roleLevelEnum(model.data.roleLevel),
                ),
              ));
    }
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
      // case UserRoleLevel.Diamond:
      //   return "assets/upgrade_icon_diamond.png";
      //   break;
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
      case UserRoleLevel.Silver:
        return R.ASSETS_USER_LEVEL_ICON_SILVER_PNG;
        break;
      case UserRoleLevel.Gold:
        return R.ASSETS_USER_LEVEL_ICON_GOLD_PNG;
        break;
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return R.ASSETS_USER_LEVEL_ICON_DIAMOND_PNG;
        break;
      case UserRoleLevel.Master:
        return R.ASSETS_USER_LEVEL_ICON_MASTER_PNG;
        break;
      default:
        return R.ASSETS_USER_LEVEL_ICON_VIP_PNG;
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
      case UserRoleLevel.Silver:
        return R.ASSETS_SHOP_SILVER_BADGE_PNG;
        break;
      case UserRoleLevel.Gold:
        return R.ASSETS_SHOP_GOLD_BADGE_PNG;
        break;
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return R.ASSETS_SHOP_DIAMOND_BADGE_PNG;
        break;
      case UserRoleLevel.Master:
        return R.ASSETS_SHOP_MASTER_BADGE_PNG;
        break;
      default:
        return "";
    }
  }

  static String cardImagePath(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Silver:
        return R.ASSETS_SHOP_SILVER_BG_WEBP;
        break;
      case UserRoleLevel.Gold:
        return R.ASSETS_SHOP_GOLD_BG_WEBP;
        break;
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return R.ASSETS_SHOP_DIAMOND_BG_WEBP;
        break;
      default:
        return R.ASSETS_SHOP_MASTER_BG_WEBP;
    }
  }

  static String get userCardBackground {
    switch (UserLevelTool.currentRoleLevelEnum()) {
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return R.ASSETS_USER_DIAMOND_WEBP;
        break;
      case UserRoleLevel.Gold:
        return R.ASSETS_USER_GOLD_WEBP;
        break;
      case UserRoleLevel.Silver:
        return R.ASSETS_USER_SLIVER_WEBP;
        break;
      default:
        return R.ASSETS_USER_NORMAL_WEBP;
        break;
    }
  }

  static Color cardTitleColor(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Silver:
        return Color(0xFF36393F);
        break;
      case UserRoleLevel.Gold:
        return Color(0xFF5F431E);
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return Color(0xFF2B2B31);
      default:
        return Color(0xFF52383D);
    }
  }

  static String currentAppBarBGImagePath() {
    return appBarBGImagePath(UserLevelTool.currentRoleLevelEnum());
  }

  static String appBarBGImagePath(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Master:
        return R.ASSETS_HEADER_MASTER_HEADER_PNG;
        break;
      case UserRoleLevel.Silver:
        return R.ASSETS_HEADER_SILVER_HEADER_PNG;
        break;
      case UserRoleLevel.Gold:
        return R.ASSETS_HEADER_GOLD_HEADER_PNG;
        break;
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return R.ASSETS_HEADER_SILVER_HEADER_PNG;
        break;
      default:
        return R.ASSETS_HEADER_VIP_HEADER_PNG;
        break;
    }
  }

  static String currentAppBarIconImagePath() {
    return appBarIconImagePath(UserLevelTool.currentRoleLevelEnum());
  }

  static String appBarIconImagePath(UserRoleLevel roleLevel) {
    switch (roleLevel) {
      case UserRoleLevel.Master:
        return R.ASSETS_USER_PAGE_APPBAR_ICON_MASTER_PNG;
        break;
      case UserRoleLevel.Silver:
        return R.ASSETS_USER_PAGE_APPBAR_ICON_SILVER_PNG;
        break;
      case UserRoleLevel.Gold:
        return R.ASSETS_USER_PAGE_APPBAR_ICON_GOLD_PNG;
        break;
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return R.ASSETS_USER_PAGE_APPBAR_ICON_DIAMOND_PNG;
        break;
      default:
        return R.ASSETS_USER_PAGE_APPBAR_ICON_VIP_PNG;
        break;
    }
  }

  static String currentUserLevel() {
    return userLevel(UserManager.instance.user.info.userLevel);
  }

  static String userLevel(int level) {
    if (level == null) {
      return "";
    }
    String userLevel = "";
    switch (level) {
      case 1:
        userLevel = "合伙人";
        break;
      case 10:
        userLevel = "顶级";
        break;
      case 20:
        userLevel = "一级";
        break;
      case 30:
        userLevel = "二级";
        break;
      case 40:
        userLevel = "其他";
        break;
      default:
    }
    return userLevel;
  }

  static UserLevel currentUserLevelEnum() {
    return userLevelEnum(UserManager.instance.user.info.userLevel);
  }

  static UserLevel userLevelEnum(int level) {
    if (level == null) {
      return UserLevel.None;
    }
    switch (level) {
      case 1:
        return UserLevel.Partner;
        break;
      case 10:
        return UserLevel.Top;
        break;
      case 20:
        return UserLevel.First;
        break;
      case 30:
        return UserLevel.Second;
        break;
      case 40:
        return UserLevel.Others;
        break;
      default:
    }
    return UserLevel.None;
  }

  static String currentRoleLevel() {
    return roleLevel(UserManager.instance.user.info.roleLevel);
  }

  static String roleLevel(int level) {
    if (level == null) {
      return "";
    }
    String roleLevel = "";
    switch (level) {
      case 100:
      case 130:
      case 160:
        roleLevel = "钻石店铺";
        break;

      case 200:
        roleLevel = "黄金店铺";
        break;
      case 300:
        roleLevel = "白银店铺";
        break;
      case 400:
        roleLevel = "店主";
        break;
      case 500:
        roleLevel = "会员";
        break;
      default:
    }
    return roleLevel;
  }

  static String roleLevelWithEnum(UserRoleLevel level) {
    if (level == null) {
      return "";
    }
    String roleLevel = "";
    switch (level) {
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        roleLevel = "钻石店铺";
        break;
      case UserRoleLevel.Gold:
        roleLevel = "黄金店铺";
        break;
      case UserRoleLevel.Silver:
        roleLevel = "白银店铺";
        break;
      case UserRoleLevel.Master:
        roleLevel = "店主";
        break;
      case UserRoleLevel.Vip:
        roleLevel = "会员";
        break;
      default:
    }
    return roleLevel;
  }

  static String currentRoleLevel2() {
    return roleLevel2(UserManager.instance.user.info.roleLevel);
  }

  static String roleLevel2(int level) {
    if (level == null) {
      return "";
    }
    String roleLevel = "";
    switch (level) {
      case 100:
        roleLevel = "钻一";
        break;
      case 130:
        roleLevel = "钻二";
        break;
      case 160:
        roleLevel = "钻三";
        break;
      case 200:
        roleLevel = "黄金";
        break;
      case 300:
        roleLevel = "白银";
        break;
      case 400:
        roleLevel = "店主";
        break;
      case 500:
        roleLevel = "会员";
        break;
      default:
    }
    return roleLevel;
  }

  static UserRoleLevel currentRoleLevelEnum() {
    return roleLevelEnum(UserManager.instance.userBrief.level);
  }



  ///获取用户的名片的角色 icon
  static String getRoleLevelIcon(UserRoleLevel level) {
    switch (level) {
      case UserRoleLevel.Diamond_1:
      case UserRoleLevel.Diamond_2:
      case UserRoleLevel.Diamond_3:
        return R.ASSETS_USER_ICON_DIAMOND_PNG;
      case UserRoleLevel.Gold:
        return R.ASSETS_USER_ICON_GOLD_PNG;
      case UserRoleLevel.Silver:
        return R.ASSETS_USER_ICON_SLIVER_PNG;
      case UserRoleLevel.Master:
        return R.ASSETS_USER_ICON_MASTER_PNG;
      case UserRoleLevel.Vip:
        return R.ASSETS_USER_ICON_VIP_PNG;
      default:
        return R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG;
    }
  }

  ///当前用户的名片角色
  static String get roleLevelIcon => getRoleLevelIcon(currentRoleLevelEnum());
}
