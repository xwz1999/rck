import 'package:flutter/material.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/user/model/user_common_model.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

class MyGroupPage extends StatefulWidget {
  final UsersMode type;
  MyGroupPage({Key key, @required this.type}) : super(key: key);

  @override
  _MyGroupPageState createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  bool _filterRecommand = false;
  GSRefreshController _refreshController = GSRefreshController();
  TextEditingController _textController = TextEditingController();
  List<UserCommonModel> _models = [];
  int get _myGroupNumber => _models.length;
  int get _allGroupCount {
    int value = 0;
    _models.forEach((element) {
      value += element.count;
    });
    return value;
  }

  bool get _isGroup => widget.type == UsersMode.MY_GROUP;

  _buildSearchButton() {
    return CustomImageButton(
      child: VxBox(
        child: [
          34.hb,
          20.wb,
          TextField(
            controller: _textController,
            onEditingComplete: () {
              _refreshController?.requestRefresh();
            },
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: '请输入昵称/备注/手机号/微信号',
              hintStyle: TextStyle(
                color: Colors.black45,
                fontSize: 12.sp,
              ),
            ),
          ).expand(),
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
        '我的团队:$_myGroupNumber'.text.color(Color(0xFF333333)).size(12).make(),
        Spacer(),
        '总团队人数:$_allGroupCount'.text.color(Color(0xFF333333)).size(12).make(),
        12.wb,
        _isGroup
            ? CustomImageButton(
                onPressed: () {
                  setState(() {
                    _filterRecommand = !_filterRecommand;
                  });
                },
                child: AnimatedContainer(
                  height: 16.w,
                  width: 58.w,
                  curve: Curves.easeInOutCubic,
                  alignment: _filterRecommand
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                      color: _filterRecommand
                          ? Color(0xFFFD6661)
                          : Color(0xFF9C9C9C),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Text(
                        _filterRecommand ? '推荐' : '筛选',
                        key: ValueKey(_filterRecommand),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        22.wb,
      ],
    );
  }

  _buildGroupCards() {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _models = await UserFunc.usersList(
          widget.type,
          keyword: _textController.text,
        );
        _refreshController.refreshCompleted();
        setState(() {});
      },
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
        separatorBuilder: (_, __) => 10.hb,
        itemBuilder: (context, index) {
          final model = _models[index];
          if (_filterRecommand && !model.isRecommand) {
            return SizedBox();
          }
          return UserGroupCard(
            isRecommend: model.isRecommand,
            id: model.userId,
            name: model.nickname,
            groupCount: model.count,
            phone: model.phone,
            shopRole: model.roleLevelEnum,
            wechatId: model.wechatNo,
            headImg: model.headImgUrl,
          );
        },
        itemCount: _models.length,
      ),
    ).expand();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 300),
      () => _refreshController.requestRefresh(),
    );
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
