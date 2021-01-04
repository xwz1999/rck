import 'package:flutter/material.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

class MyGroupPage extends StatefulWidget {
  MyGroupPage({Key key}) : super(key: key);

  @override
  _MyGroupPageState createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  bool _filterRecommand = false;
  _buildSearchButton() {
    return CustomImageButton(
      child: VxBox(
        child: [
          34.hb,
          20.wb,
          '请输入昵称/备注/手机号/微信号'.text.color(Colors.black45).size(12.sp).make(),
          Spacer(),
          Image.asset(
            R.ASSETS_HOME_TAB_SEARCH_PNG,
            color: Color(0xFF999999),
            height: 18.w,
            width: 18.w,
          ),
          20.wb,
        ].row(),
      )
          .white
          .withRounded(value: 17.w)
          .margin(EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w))
          .make(),
      onPressed: () {},
    );
  }

  _buildTitleBar() {
    return Row(
      children: [
        25.wb,
        '我的团队数:${12}'.text.color(Color(0xFF333333)).size(12).make(),
        Spacer(),
        '总团队数:${23}'.text.color(Color(0xFF333333)).size(12).make(),
        12.wb,
        CustomImageButton(
          onPressed: () {
            setState(() {
              _filterRecommand = !_filterRecommand;
            });
          },
          child: AnimatedContainer(
            height: 16.w,
            width: 58.w,
            curve: Curves.easeInOutCubic,
            alignment:
                _filterRecommand ? Alignment.centerLeft : Alignment.centerRight,
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: AnimatedContainer(
              width: 36.w,
              height: 16.w,
              curve: Curves.easeInOutCubic,
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                color: _filterRecommand ? Color(0xFF9C9C9C) : Color(0xFFFD6661),
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Text(
                  _filterRecommand ? '筛选' : '推荐',
                  key: ValueKey(_filterRecommand),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
        22.wb,
      ],
    );
  }

  _buildGroupCards() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
      separatorBuilder: (_, __) => 10.hb,
      itemBuilder: (context, index) {
        //TODO
        return UserGroupCard(
          name: 'TESTNAME(TEST)',
          groupCount: 6,
          phone: '18291010101',
          shopRole: UserRoleLevel.Vip,
          wechatId: 'TEST',
        );
      },
      itemCount: 10,
    ).expand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: RecookBackButton(),
        centerTitle: true,
        title: '我的团队'.text.black.bold.make(),
      ),
      body: Column(
        children: [
          _buildSearchButton(),
          _buildTitleBar(),
          10.hb,
          _buildGroupCards(),
        ],
      ),
    );
  }
}
