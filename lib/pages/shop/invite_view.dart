import 'package:flutter/material.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/utils/app_router.dart';

class InviteView extends StatefulWidget {
  final bool single; // 只显示单行
  final Function() shareListener;
  const InviteView({Key key, this.shareListener, this.single=true}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _InviteViewState();
  }
}

class _InviteViewState extends State<InviteView>{
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
      ),
      // margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _titleWidget(),
          widget.single?
          Container()
          :GestureDetector(
            onTap: (){
              AppRouter.push(context, RouteName.SHOP_RECOMMEND_UPGRADE_PAGE);
            },
            child: _updateWidget(),
          ),
          _rowInviteView()
        ],
      )
    );
  }

  _titleWidget(){
    return Container(
      height: 40, width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15),
      child: Text("邀请升级", style: AppTextStyle.generate(16, fontWeight: FontWeight.w700),),
    );
  }

  _updateWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15), height: 90, width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0, right: 0, top: 0, bottom: 0,
            child: Image.asset("assets/invite_view_update_bg.png", fit: BoxFit.fill,),
          ),
          Positioned(
            right: 15, width: 110, height: 60, top: 15,
            child: Image.asset("assets/invite_view_update_icon.png", fit: BoxFit.fill,),
          ),
          Positioned(
            left: 0, top: 0, right: 0, bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("升级你的财富圈", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500 ,fontSize: ScreenAdapterUtils.setSp(19), color: Colors.white, ),),
                  Text("邀请好友·福利双赢",style: TextStyle( letterSpacing: 2,color: Colors.white, fontSize: 9),)
                ],
            ),
            )
          )
        ],
      ),
    );
  }

  _rowInviteView() {
  return Container(
    height: 90, padding: EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset( AppImageName.invite_bg, fit: BoxFit.cover,),
                  MaterialButton(
                    onPressed: () {
                      if (widget.shareListener != null) widget.shareListener();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text('邀请开店', style: TextStyle(fontWeight: FontWeight.w500 ,fontSize: ScreenAdapterUtils.setSp(19), color: Colors.white, ),),
                          // child: RichText(
                          //   text: TextSpan(
                          //     children: [
                          //       TextSpan(text: '邀请开店\n', style: TextStyle(fontWeight: FontWeight.w500 ,fontSize: ScreenAdapterUtils.setSp(19), color: Colors.white, ),),
                          //       TextSpan(text: '我的邀请码: ${UserManager.instance.user.info.invitationNo}', style: TextStyle(fontSize: 10, color: Colors.white, ),),
                          //     ]
                          //   ),
                          // ),
                        ),
                        Image.asset(AppImageName.invite_icon,height: 40, width:40)
                      ],
                    ),
                  ),
                ],
              ))),
        Container( width: 10,),
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset( AppImageName.my_invite_bg, fit: BoxFit.cover,),
                MaterialButton(
                  onPressed: () {
                    AppRouter.push(context, RouteName.USER_INVITE,);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("我的邀请", style: TextStyle(fontWeight: FontWeight.w500 ,fontSize: ScreenAdapterUtils.setSp(19), color: Colors.white, ),),
                      Image.asset(AppImageName.my_invite_icon, width: 40, height: 40,)
                    ],
                  ),
                )
              ],
            ))),
        ],
      ),
    );
  }

  
}