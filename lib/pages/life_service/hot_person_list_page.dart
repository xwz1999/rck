import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/hot_person_model.dart';

import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/refresh_widget.dart';

import 'hot_person_detail_page.dart';

///热门达人
class HotPersonListPage extends StatefulWidget {
  final int index;

  const HotPersonListPage({Key? key, required this.index}) : super(key: key);

  @override
  _HotPersonListPageState createState() => _HotPersonListPageState();
}

class _HotPersonListPageState extends State<HotPersonListPage>
    with TickerProviderStateMixin {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  List<HotPersonModel> hotPersonList = [];

  @override
  void initState() {
    super.initState();
    hotPersonList = [
      HotPersonModel(
          nickname: '冬冬和37',
          followerCount: 13971653,
          effectValue: 6661462,
          avatar:
              'https:\/\/p6.douyinpic.com\/aweme\/100x100\/aweme-avatar\/tos-cn-avt-0015_557462ba1632b1bd0185ae348cc315fb.jpeg?from=2956013662',
          videoList: [
            VideoList(
                title: '当我又用钢丝球逗我姥@37 #vlog日常',
                itemCover:
                    'https:\/\/p6-sign.douyinpic.com\/tos-cn-p-0015\/199d6896022349e4a98f5a0edcbe6426_1656330257~c5_300x400.jpeg?x-expires=1657677600&x-signature=QQ9XmYyck700ocW%2FkKGMeJRPkFg%3D&from=2563711402_large,',
                shareUrl:
                    'https:\/\/www.iesdouyin.com\/share\/video\/7113884163974941985\/?region=CN&mid=7113884244014893861&u_code=0&titleType=title&did=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&iid=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&with_sec_did=1')
          ]),
      HotPersonModel(
          nickname: '冬冬和37',
          followerCount: 13971653,
          effectValue: 6661462,
          avatar:
          'https:\/\/p6.douyinpic.com\/aweme\/100x100\/aweme-avatar\/tos-cn-avt-0015_557462ba1632b1bd0185ae348cc315fb.jpeg?from=2956013662',
          videoList: [
            VideoList(
                title: '当我又用钢丝球逗我姥@37 #vlog日常',
                itemCover:
                'https:\/\/p6-sign.douyinpic.com\/tos-cn-p-0015\/199d6896022349e4a98f5a0edcbe6426_1656330257~c5_300x400.jpeg?x-expires=1657677600&x-signature=QQ9XmYyck700ocW%2FkKGMeJRPkFg%3D&from=2563711402_large,',
                shareUrl:
                'https:\/\/www.iesdouyin.com\/share\/video\/7113884163974941985\/?region=CN&mid=7113884244014893861&u_code=0&titleType=title&did=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&iid=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&with_sec_did=1')
          ]),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      controller: _refreshController,
      color: AppColor.themeColor,
      onRefresh: () async {
        _refreshController.refreshCompleted();
        //setState(() {});
      },
      body: ListView.builder(
        itemCount: hotPersonList.length,
        padding: EdgeInsets.only(
          left: 12.rw,
          right: 12.rw,
          top: 0.rw,
        ),
        itemBuilder: (BuildContext context, int index) =>
            _itemWidget(hotPersonList[index]),
      ),
    );
  }

  _itemWidget(HotPersonModel model) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>HotPersonDetailPage(hotPersonModel: model,));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 30.rw),
        child: Row(
          children: [
            CustomCacheImage(
              borderRadius: BorderRadius.circular(22.rw),
              imageUrl: model.avatar ?? '',
              fit: BoxFit.fill,
              width: 44.rw,
              height: 44.rw,
            ),
            32.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.nickname??'',style: TextStyle(
                  fontSize: 16.rsp,color: Color(0xFF333333),fontWeight: FontWeight.bold
                )),
                Text('粉丝数：${_getNumWithW(model.followerCount??0)}',style: TextStyle(
                  fontSize: 12.rsp,color: Color(0xFF999999),
                )),
              ],
            ),

            Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${model.effectValue}',style: TextStyle(
                  fontSize: 16.rsp,color: Color(0xFFFF4825),fontWeight: FontWeight.bold
                )),

                Text('影响力指数',style: TextStyle(
                  fontSize: 12.rsp,color: Color(0xFF999999),
                )),
              ],
            ),
            30.wb,
            Icon(
              Icons.keyboard_arrow_right,
              color: Color(0xFF999999),
              size: 28 * 2.sp,
            ),

          ],
        ),
      ),
    );
  }

  _getNumWithW(int num){
    if(num>=10000){
      return (num/10000).toStringAsFixed(1)+'w';
    }
    else{
      return '$num}';
    }
  }
}
