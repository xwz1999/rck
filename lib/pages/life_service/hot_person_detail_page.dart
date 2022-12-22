
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/hot_person_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/webView.dart';

///达人详情
class HotPersonDetailPage extends StatefulWidget {

  final HotPersonModel hotPersonModel;
  const HotPersonDetailPage({Key? key, required this.hotPersonModel}) : super(key: key);

  @override
  _HotPersonDetailPageState createState() => _HotPersonDetailPageState();
}

class _HotPersonDetailPageState extends State<HotPersonDetailPage> {

  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

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
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Stack(
      children: [
        Positioned(
            child: Image.asset(
          Assets.imgDrxq.path,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RecookBackButton(
                    white: true,
                  ),
                  Text('达人详情',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.rsp,
                      )),
                  SizedBox(
                    width: 110.w,
                  ),
                ],
              ),
            ),
            10.hb,

            Container(
              height: 126.rw,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12.rw),
              padding: EdgeInsets.symmetric(horizontal: 12.rw),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.rw),
                color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CustomCacheImage(
                        borderRadius: BorderRadius.circular(28.rw),
                        imageUrl: widget.hotPersonModel.avatar ?? '',
                        fit: BoxFit.fill,
                        width: 56.rw,
                        height: 56.rw,
                      ),
                      32.wb,
                      Text(widget.hotPersonModel.nickname??'',style: TextStyle(
                          fontSize: 16.rsp,color: Color(0xFF333333),fontWeight: FontWeight.bold
                      )),

                    ],
                  ),
                  24.hb,

                  Row(
                    children: [
                      Text('${_getNumWithW(widget.hotPersonModel.followerCount??0)}',style: TextStyle(
                          fontSize: 16.rsp,color: Color(0xFF333333),fontWeight: FontWeight.bold
                      )),
                      10.wb,
                      Text('粉丝数',style: TextStyle(
                          fontSize: 12.rsp,color: Color(0xFF999999),
                      )),

                      64.wb,
                      Text('${widget.hotPersonModel.effectValue}',style: TextStyle(
                          fontSize: 16.rsp,color: Color(0xFF333333),fontWeight: FontWeight.bold
                      )),
                      10.wb,
                      Text('影响力指数',style: TextStyle(
                          fontSize: 12.rsp,color: Color(0xFF999999),
                      )),

                    ],
                  ),
                ],
              ),
            ),

            48.hb,


            Expanded(
              child: RefreshWidget(
                controller: _refreshController,
                color: AppColor.themeColor,
                onRefresh: () async {
                  _refreshController.refreshCompleted();
                  //setState(() {});
                },
                body: ListView.builder(
                  itemCount: widget.hotPersonModel.videoList!.length,
                  padding: EdgeInsets.only(
                    left: 12.rw,
                    right: 12.rw,
                    top: 0.rw,
                  ),
                  itemBuilder: (BuildContext context, int index) =>
                      _itemWidget(widget.hotPersonModel.videoList![index]),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _itemWidget(VideoList model) {
    return GestureDetector(
      onTap: (){
        AppRouter.push(
          context,
          RouteName.WEB_VIEW_PAGE,
          arguments: WebViewPage.setArguments(
              url: model.shareUrl??'',
              hideBar: true,),
        );
      },
      child: Container(
        width: double.infinity,
        height: 110.rw,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 130.rw,
              height: 90.rw,
              child: Stack(
                children: [
                  CustomCacheImage(
                    borderRadius: BorderRadius.circular(4.rw),
                    imageUrl: model.itemCover ?? '',
                    fit: BoxFit.fitWidth,
                    width: 140.rw,
                    height: 94.rw,
                  ),
                ],
              ),
            ),
            24.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                    width: 200.rw,

                    child: Text(model.title??'',style: TextStyle(
                      fontSize: 16.rsp,color: Color(0xFF333333),
                    ),maxLines: 4,overflow: TextOverflow.ellipsis,)),
              ],
            )
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
