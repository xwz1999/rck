import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/styles.dart';
class MemberInviteView extends StatefulWidget {
  final Function? listener;
  const MemberInviteView({Key? key, this.listener}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MemberInviteViewState();
  }
}

class _MemberInviteViewState extends State<MemberInviteView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _contentWidget(),
      onTap: () {
        if (widget.listener != null) {
          widget.listener!();
        }
      },
    );
  }

  Container _contentWidget() {
    TextStyle lineStyle =
        TextStyle(color: Colors.grey, fontSize: 11 * 2.sp, letterSpacing: -2);
    TextStyle greyStyle =
        TextStyle(color: Colors.grey, fontSize: 11 * 2.sp, letterSpacing: 2);
    TextStyle redStyle = TextStyle(
        color: AppColor.themeColor, fontSize: 11 * 2.sp, letterSpacing: 2);
    return Container(
      margin: EdgeInsets.only(
        left: rSize(10),
        right: rSize(10),
        top: rSize(8),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: Stack(children: [
        Container(
          height: 60,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Positioned(
                left: 13,
                width: 54,
                height: 54,
                child: Image.asset(
                  'assets/userpage_member_invite_1.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 73,
                width: 57,
                height: 29,
                child: Image.asset(
                  'assets/userpage_member_invite_2.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 14,
                left:
                    (MediaQuery.of(context).size.width - 165 - 2 * rSize(10)) /
                        2,
                width: 165,
                height: 16,
                child: Image.asset(
                  'assets/userpage_member_invite_3.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 89,
                width: 34,
                height: 12,
                child: Image.asset(
                  'assets/userpage_member_invite_4.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                right: 13,
                width: 54,
                height: 54,
                child: Image.asset(
                  'assets/userpage_member_invite_5.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                  top: 33,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(text: "----", style: lineStyle),
                      TextSpan(text: "只需邀请", style: greyStyle),
                      TextSpan(text: "10", style: redStyle),
                      TextSpan(text: "人", style: greyStyle),
                      TextSpan(text: "----", style: lineStyle),
                    ]),
                  ))
            ],
          ),
        ),
      ]),
    );
  }
}
