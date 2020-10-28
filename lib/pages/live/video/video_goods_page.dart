import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/live/models/video_goods_model.dart';
import 'package:recook/widgets/refresh_widget.dart';

class VideoGoodsPage extends StatefulWidget {
  final Function(VideoGoodsModel model) onPick;
  VideoGoodsPage({Key key, @required this.onPick}) : super(key: key);

  @override
  _VideoGoodsPageState createState() => _VideoGoodsPageState();
}

class _VideoGoodsPageState extends State<VideoGoodsPage> {
  bool onSearch = false;
  String _keyword = '';
  int _page = 1;
  //history
  int _historyPage = 1;

  List<VideoGoodsModel> recentGoods = [];
  List<VideoGoodsModel> searchResultModels = [];

  GSRefreshController _controller = GSRefreshController();
  GSRefreshController _recentController = GSRefreshController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _recentController.requestRefresh();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _recentController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leadingWidth: rSize(30 + 28.0),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '取消',
            softWrap: false,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(rSize(16)),
          ),
          margin: EdgeInsets.only(
            left: rSize(5),
            right: rSize(15),
          ),
          child: TextField(
            onChanged: (text) {
              if (TextUtil.isEmpty(text)) {
                setState(() {
                  onSearch = false;
                });
              }
            },
            onSubmitted: (text) {
              setState(() {
                onSearch = true;
                _keyword = text;
              });
              Future.delayed(Duration(milliseconds: 100), () {
                if (mounted) _controller.requestRefresh();
              });
            },
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(13),
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: '搜索你想添加的商品',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: rSP(13),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: rSize(13), right: rSize(3)),
                child: Image.asset(
                  R.ASSETS_SEARCH_PNG,
                  height: rSize(16),
                  width: rSize(16),
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: onSearch
          ? RefreshWidget(
              controller: _controller,
              onRefresh: () {
                _page = 1;
                getSearchGoodsList().then((models) {
                  setState(() {
                    searchResultModels = models;
                  });
                  _controller.refreshCompleted();
                });
              },
              onLoadMore: () {
                _page++;
                getSearchGoodsList().then((models) {
                  setState(() {
                    searchResultModels.addAll(models);
                  });
                  if (models.isEmpty)
                    _controller.loadNoData();
                  else
                    _controller.loadComplete();
                });
              },
              body: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    height: rSize(0.5),
                    thickness: rSize(0.5),
                    color: Color(0xFFD6D6D6),
                    indent: rSize(15),
                    endIndent: rSize(15),
                  );
                },
                itemBuilder: (context, index) {
                  return _buildGoodsCard(searchResultModels[index]);
                },
                itemCount: searchResultModels.length,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(rSize(15)),
                  child: Text(
                    '最近购买的商品',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshWidget(
                    controller: _recentController,
                    onRefresh: () {
                      _historyPage = 1;
                      getHistory().then((models) {
                        setState(() {
                          recentGoods = models;
                        });
                        _recentController.refreshCompleted();
                      });
                    },
                    onLoadMore: () {
                      _historyPage++;
                      getHistory().then((models) {
                        setState(() {
                          recentGoods.addAll(models);
                        });
                        if (models.isEmpty)
                          _recentController.loadNoData();
                        else
                          _recentController.loadComplete();
                      });
                    },
                    body: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: rSize(0.5),
                          thickness: rSize(0.5),
                          color: Color(0xFFD6D6D6),
                          indent: rSize(15),
                          endIndent: rSize(15),
                        );
                      },
                      itemBuilder: (context, index) {
                        return _buildGoodsCard(recentGoods[index]);
                      },
                      itemCount: recentGoods.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  _buildGoodsCard(VideoGoodsModel model) {
    return MaterialButton(
      onPressed: () {
        widget.onPick(model);
        Navigator.pop(context);
      },
      padding: EdgeInsets.all(rSize(15)),
      child: Row(
        children: [
          Container(
            color: AppColor.frenchColor,
            child: FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: Api.getImgUrl(model.mainPhotoUrl),
              height: rSize(100),
              width: rSize(100),
            ),
          ),
          rWBox(10),
          Expanded(
            child: SizedBox(
              height: rSize(110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF0A0001),
                      fontSize: rSP(14),
                    ),
                  ),
                  Text(
                    model.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                        color: Colors.black54, fontWeight: FontWeight.w300),
                  ),
                  InkWell(
                    onTap: () {
                      AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                          arguments: BrandGoodsListPage.setArguments(
                            model.brandId,
                            model.brandName,
                          ));
                    },
                    child: Row(
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image: Api.getImgUrl(model.brandImg),
                          width: rSize(13),
                          height: rSize(13),
                        ),
                        rWBox(4),
                        Text(
                          model.brandName,
                          style: TextStyle(
                            color: Color(0xffc70404),
                            fontSize: ScreenAdapterUtils.setSp(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SmallCouponWidget(number: num.parse(model.coupon)),
                      rWBox(4),
                      Container(
                        height: rSize(18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(rSize(1)),
                          border: Border.all(
                            color: Color(0xFFCC1B4F),
                            width: rSize(0.5),
                          ),
                        ),
                        child: Text(
                          '赚${model.commission}',
                          style: TextStyle(
                            color: Color(0xFFCC1B4F),
                            fontSize: rSP(12),
                            height: 1,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '剩余',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(11),
                        ),
                      ),
                      Text(
                        '${model.inventory}件',
                        style: TextStyle(
                          color: Color(0xFFC91147),
                          fontSize: rSP(11),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Spacer(),
                      Text(
                        '¥',
                        style: TextStyle(
                          color: Color(0xFFC92219),
                          fontSize: rSP(12),
                        ),
                      ),
                      Text(
                        model.originalPrice,
                        style: TextStyle(
                          color: Color(0xFFC92219),
                          fontSize: rSP(18),
                        ),
                      ),
                      // Text(
                      //   '¥',
                      //   style: TextStyle(
                      //     color: Color(0xFFC92219),
                      //     fontSize: rSP(12),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<VideoGoodsModel>> getSearchGoodsList() async {
    ResultData resultData = await HttpManager.post(LiveAPI.goodsList, {
      'keyword': _keyword,
      'page': _page,
      'limit': 15,
    });

    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => VideoGoodsModel.fromJson(e))
          .toList();
  }

  Future<List<VideoGoodsModel>> getHistory() async {
    ResultData resultData = await HttpManager.post(LiveAPI.historyGoods, {
      'page': _historyPage,
      'limit': 15,
    });

    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => VideoGoodsModel.fromJson(e))
          .toList();
  }
}
