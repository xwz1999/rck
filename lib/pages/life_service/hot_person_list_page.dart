import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/hot_person_model.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/no_data_view.dart';
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
  int page = 0;
  bool _onLoad = true;
  @override
  void initState() {
    super.initState();
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
        page = 1;
        hotPersonList = await LifeFunc.getHotPersonList(widget.index,page)??[];
        _refreshController.refreshCompleted();
        _onLoad = false;
        setState(() {});
      },
      onLoadMore: () async {
        page+=10;
        await LifeFunc.getHotPersonList(widget.index,page).then((models) {
          setState(() {
            hotPersonList.addAll(models ?? []);
          });
          _refreshController.loadComplete();
        });
      },
      body:  _onLoad?SizedBox(): hotPersonList.isEmpty
          ? NoDataView(
        title: "没有数据哦～",
        height: 600,
      )
          :  ListView.builder(
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
                Container(
                  width: 150.rw,
                  child: Text(model.nickname??'',style: TextStyle(
                    fontSize: 16.rsp,color: Color(0xFF333333),fontWeight: FontWeight.bold,
                  )),
                ),
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
