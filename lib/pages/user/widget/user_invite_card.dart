import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/utils/user_level_tool.dart';

class UserInviteCard extends StatelessWidget {
  final String? headerImg;
  final String? nickName;
  final String? phone;
  final int? groupCount;
  final UserRoleLevel? roleLevel;
  const UserInviteCard(
      {Key? key,
      this.headerImg,
      this.nickName,
      this.phone,
      this.groupCount,
      this.roleLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: rSize(15),
        vertical: rSize(5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rSize(5)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(rSize(12)),
      child: Row(
        children: [
          Container(
            width: rSize(46),
            height: rSize(46),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFFEC053),
                width: rSize(1),
              ),
              borderRadius: BorderRadius.circular(rSize(23)),
              image: DecorationImage(
                image: NetworkImage(
                  Api.getImgUrl(headerImg)!,
                ),
              ),
            ),
          ),
          SizedBox(width: rSize(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickName!,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: rSP(14),
                  ),
                ),
                SizedBox(height: rSize(6)),
                Row(
                  children: [
                    Image.asset(
                      R.ASSETS_INVITE_DETAIL_PHONE_PNG,
                      height: rSize(12),
                      width: rSize(12),
                    ),
                    SizedBox(width: rSize(5)),
                    Text(
                      phone!,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: rSP(12),
                      ),
                    ),
                    SizedBox(width: rSize(20)),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      R.ASSETS_INVITE_DETAIL_EDIT_PNG,
                      height: rSize(12),
                      width: rSize(12),
                    ),
                    SizedBox(width: rSize(5)),
                    Text(
                      phone!,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: rSP(12),
                      ),
                    ),
                    // UserLevelTool
                    SizedBox(width: rSize(20)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
