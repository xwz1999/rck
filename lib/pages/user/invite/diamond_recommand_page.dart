import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/invite/diamond_recommand_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

class DiamondRecommandPage extends StatefulWidget {
  DiamondRecommandPage({Key key}) : super(key: key);

  @override
  _DiamondRecommandPageState createState() => _DiamondRecommandPageState();
}

class _DiamondRecommandPageState extends State<DiamondRecommandPage> {
  List<DiamondRecommandModel> models = [];
  GSRefreshController _gsRefreshController = GSRefreshController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      _gsRefreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        leading: RecookBackButton(),
        appBackground: Colors.white,
        title: Text(
          '我的推荐',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshWidget(
        controller: _gsRefreshController,
        onRefresh: () {
          HttpManager.post(UserApi.diamond_recommand_list, {
            'userId': UserManager.instance.user.info.id,
          }).then((resultData) {
            _gsRefreshController.refreshCompleted();
            setState(() {
              models = resultData.data == null
                  ? []
                  : resultData.data['data'] == null
                      ? []
                      : (resultData.data['data'] as List)
                          .map((e) => DiamondRecommandModel.fromJson(e))
                          .toList();
            });
          });
        },
        body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: rSize(5)),
          itemBuilder: (context, index) {
            return _buildCard(models[index]);
          },
          itemCount: models.length,
        ),
      ),
    );
  }

  _buildCard(DiamondRecommandModel model) {
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
                  Api.getImgUrl(model.headImgUrl),
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
                  model.nickname,
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
                      model.phoneNum,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: rSP(12),
                      ),
                    ),
                    SizedBox(width: rSize(20)),
                    Image.asset(
                      R.ASSETS_INVITE_DETAIL_TIME_PNG,
                      height: rSize(12),
                      width: rSize(12),
                    ),
                    SizedBox(width: rSize(5)),
                    Text(
                      model.createdAt,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: rSP(12),
                      ),
                    ),
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
