import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/shop/member_benefits_page.dart';
import 'package:recook/pages/shop/shop_page.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';

class NormalShopPage extends StatefulWidget {
  NormalShopPage({Key key}) : super(key: key);

  @override
  _NormalShopPageState createState() => _NormalShopPageState();
}

class _NormalShopPageState extends BaseStoreState<NormalShopPage> {
  @override
  void initState() {
    super.initState();
    UserManager.instance.refreshUserRole.addListener(_refreshUserRoleTabBar);
  }

  _refreshUserRoleTabBar() {
    setState(() {});
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return _bodyWidget();
  }

  _widget() {
    return (UserLevelTool.currentUserLevelEnum() == UserLevel.Others ||
                UserLevelTool.currentUserLevelEnum() == UserLevel.First ||
                UserLevelTool.currentUserLevelEnum() == UserLevel.Second) &&
            UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
        ? MemberBenefitsPage()
        : ShopPage();
  }

  _bodyWidget() {
    if (UserManager.instance.haveLogin) {
      // 登录了就渲染用户界面
      return _widget();
    } else {
      //没登录就渲染一个登录按钮
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: rSize(120)),
                width: rSize(70),
                height: rSize(70),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1.0 / 1.0,
                    child: Image.asset(AppImageName.recook_icon_300,
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Container(
                height: 150,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 100),
                child: CustomImageButton(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  title: " 登录 ",
                  backgroundColor: AppColor.themeColor,
                  color: Colors.white,
                  fontSize: ScreenAdapterUtils.setSp(16),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  onPressed: () {
                    AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                  },
                ),
              ),
            ],
          )
        ],
      );
    }
  }
}
