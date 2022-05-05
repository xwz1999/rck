
import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/home/widget/plus_minus_view.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/selected_list.dart';
import 'package:recook/widgets/toast.dart';

typedef ChooseClickListener = Function(SkuChooseModel skuModel);

class SkuChoosePage extends StatefulWidget {
  final GoodsDetailModel model;
  final List<SelectedListItemModel> itemModels;
  final List<String> results;
  final ChooseClickListener listener;
  final int userId;

  const SkuChoosePage(
      {Key key,
      this.model,
      @required this.itemModels,
      @required this.results,
      this.listener, this.userId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SkuChoosePageState();
  }
}

class _SkuChoosePageState extends BaseStoreState<SkuChoosePage> {
  Sku _sku;
  String _commission, _price;
  List<String> _skuDes;
  StringBuffer _stringBuffer;
  int _num;
  List _photoList = [];
  List<PicSwiperItem> picSwiperItem = [];
  StateSetter _refreshState;
  /// 存放 sku id 列表
  List selectedIds = [];

  @override
  void initState() {
    super.initState();
    ///为了图片和规格选择顺序对应 先进行排序
    widget.model.data.sku.sort((a,b)=>a.combineId.compareTo(b.combineId));
    _num = 1;
    _stringBuffer = StringBuffer();
    _skuDes = [];
    _skuClicked();
    ///将所有的规格图片存入
    widget.model.data.sku.forEach((element) {
      _photoList.add(element.picUrl);
      picSwiperItem.add(PicSwiperItem(Api.getImgUrl(element.picUrl)));
    });


    // bool hasPromotion = widget.model.data.promotion != null;
    // bool hasPromotion = true;
    double minPrice=0.0, maxPrice, maxCommission, minCommission;




    widget.model.data.sku.forEach((element) {
      if(minPrice==0.0){
        minPrice = element.discountPrice;
        minCommission = element.commission;

        maxPrice = element.discountPrice;
        maxCommission = element.commission;

      }else
      if(element.discountPrice<minPrice){
        minPrice = element.discountPrice;
        minCommission = element.commission;

      }else{

        maxPrice = element.discountPrice;
        maxCommission = element.commission;
      }

    });


    if (maxPrice == minPrice) {
      _price = (maxPrice-maxCommission).toStringAsFixed(2);
    } else {
      _price = "${(minPrice-minCommission).toStringAsFixed(2)}-${(maxPrice-maxCommission).toStringAsFixed(2)}";
    }

    if (maxCommission == minCommission) {
      _commission = maxCommission.toStringAsFixed(2);
    } else {
      _commission =
          "${minCommission.toStringAsFixed(2)}-${maxCommission.toStringAsFixed(2)}";
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: _buildBody(context),
    );
  }

  Container _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: DeviceInfo.bottomBarHeight == 0
              ? 20
              : DeviceInfo.bottomBarHeight),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.white),
      height: DeviceInfo.screenHeight * 0.8,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _header(context),
            Container(
              color: Colors.grey[300],
              height: 0.3,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            _plusMinusView(),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      height: rSize(110),
      padding: EdgeInsets.symmetric(vertical: rSize(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
               CustomCacheImage(
                imageClick: () async{
                  var data = await  AppRouter.fade(
                    context,
                    RouteName.PIC_SWIPER,
                    arguments: PicSwiper.setArguments(
                      index: _sku==null?0: widget.model.data.sku.indexOf(_sku),
                      pics: picSwiperItem,
                    ),
                  );
                  print(data);
                  _sku = widget.model.data.sku[data];


                   for(int i=0;i<widget.itemModels[0].items.length;i++){
                     if(_sku.combineId.indexOf(widget.itemModels[0].items[i].id.toString())!=-1){
                       widget.itemModels[0].selectedIndex = i;
                       widget.itemModels[0].items[i].canSelected = true;
                     }
                   }

                  ///规格尺寸选项最多两种
                  ///combineId用，隔开时 有两种类型
                  if(_sku.combineId.indexOf(',')!=-1){
                   for(int i=0;i<widget.itemModels[1].items.length;i++){
                     if(_sku.combineId.indexOf(widget.itemModels[1].items[i].id.toString())!=-1){
                       widget.itemModels[1].selectedIndex = i;
                       widget.itemModels[1].items[i].canSelected = true;
                     }
                   }
                  }
                  _skuClicked();



                },
                width: rSize(100),
                height: rSize(100),
                fit: BoxFit.cover,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                imageUrl: _sku == null
                    ? Api.getImgUrl(widget.model.data.mainPhotos[0].url)
                    : Api.getImgUrl(_sku.picUrl),
              ),

               Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          final skuNotNull =
                              _sku != null && _sku.commission != null;
                          return RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    "￥${_sku != null ? (_sku.discountPrice-_sku.commission).toStringAsFixed(2) : _price}",
                                // "￥ ${_sku.discountPrice}",
                                style: AppTextStyle.generate(18 * 2.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),

                            ]),
                          );
                        },
                      ),
                      Text(
                        "库存 ${_sku != null ? _sku.inventory : widget.model.data.inventory}件",
                        style: AppTextStyle.generate(13 * 2.sp,
                            // fontWeight: FontWeight.w300,
                            color: Colors.grey),
                      ),
                      widget.model.data.isFerme == 1
                          ? Row(
                              children: [
                                Container(
                                  width: 32 * 2.w,
                                  height: 14 * 2.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE5ED),
                                    borderRadius:
                                        BorderRadius.circular(7.5 * 2.w),
                                  ),
                                  child: Text(
                                    '包税',
                                    style: TextStyle(
                                      color: Color(0xFFCC1B4F),
                                      fontSize: 10 * 2.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10 * 2.w,
                                ),
                                Text(
                                  '进口税¥${widget.model.data.price.min.ferme.toStringAsFixed(2)},由瑞库客承担',
                                  style: TextStyle(
                                      color: Color(0xFF141414),
                                      fontSize: 12 * 2.sp),
                                ),
                              ],
                            )
                          : SizedBox(),
                      Text(
                        "${_stringBuffer.toString()}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.generate(14 * 2.sp,
                            // fontWeight: FontWeight.w300,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),

          ),
          CustomImageButton(
            icon: Icon(
              AppIcons.icon_cancle_circle,
              size: 18,
            ),
            padding: EdgeInsets.all(5),
            color: Colors.grey[500],
            onPressed: () {
              Navigator.maybePop(context);
            },
          )
        ],
      ),
    );
  }

  Expanded _plusMinusView() {
    return Expanded(
        child: SelectedList<SelectedListItemChildModel>(
      data: widget.itemModels,
      bottom: () {
        Widget pw = PlusMinusView(
          minValue: 1,
          maxValue: _sku != null
              ? (_sku.inventory < 50 ? _sku.inventory : 50)
              : (widget.model.data.inventory < 50
                  ? widget.model.data.inventory
                  : 50),
          onInputComplete: (String getNum) {
            _num = int.parse(getNum);
          },
          onValueChanged: (int getNum) {
            _num = getNum;
          },
        );
        return Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text("数量",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ),
            Expanded(child: pw),
          ],
        );
      },
      listener: (int section, int index) {
        _skuClicked();
      },
    ));
  }

  Container _bottomBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: CustomImageButton(
              title: "加入购物车",
              color: Colors.white,
              height: 40,
              boxDecoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xff979797), Color(0xff5d5e5d)]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              fontSize: 16 * 2.sp,
              onPressed: () {
                if (_sku == null) {
                  Toast.showInfo(_stringBuffer.toString(),
                      color: Colors.black87);
                  return;
                }
                if (_num > _sku.inventory) {
                  Toast.showInfo("所选数量大于库存数量");
                  return;
                }
                if (_num > 50) {
                  Toast.showInfo("单次购买数量不能超过50");
                  return;
                }
                if (widget.listener != null) {
                  widget.listener(
                      SkuChooseModel(0, _num, _sku, _skuDes.join("-")));
                }
              },
            ),
          ),
          Container(
            width: 2,
          ),
          Expanded(
            child: CustomImageButton(
              title: "立即购买",
              color: Colors.white,
              height: 40,
              boxDecoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xffc81a3e), Color(0xfffa4968)]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              fontSize: 16 * 2.sp,
              onPressed: () {
                if (_sku == null) {
                  Toast.showInfo(_stringBuffer.toString(), color: Colors.black);
                  return;
                }
                if (_num > 50) {
                  Toast.showInfo("每单限购50件");
                  return;
                }
                if (_num > _sku.inventory) {
                  Toast.showInfo("所选数量大于库存数量");
                  return;
                }

                if (_sku.inventory <= 0) {
                  Toast.showInfo('该物品为空');
                  CRoute.popBottom(context);
                  return;
                }

                if (widget.listener != null) {
                  widget.listener(
                      SkuChooseModel(1, _num, _sku, _skuDes.join("+")));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _skuClicked() {
    List<SelectedListItemModel> selectedSections = [];
    List<SelectedListItemModel> unSelectedSections = [];

    widget.itemModels.forEach((SelectedListItemModel model) {
      if (model.selectedIndex != null) {
        selectedSections.add(model);
      } else {
        unSelectedSections.add(model);
      }
    });

    /// 已选的每行与其他已选行 是否可以组成已有的sku，不判断未选择的
    selectedSections.forEach((model) {
      List<SelectedListItemModel> tempList = List.of(selectedSections);
      tempList.remove(model);

      List ids = tempList.map((SelectedListItemModel tempModel) {
        return tempModel.items[tempModel.selectedIndex].id;
      }).toList();

      model.items.forEach((item) {
        if (model.items.indexOf(item) != model.selectedIndex) {
          ids.add(item.id);
          ids.sort();
          String id = ids.join("-");
          if (widget.results.contains(id)) {
            item.canSelected = true;
          } else {
            print("没有的sku ---- $id");
            item.canSelected = false;
          }
          ids.remove(item.id);
        }
      });
    });

    /// 已选的 id 数组
    List selectedIds = selectedSections
        .map((model) => model.items[model.selectedIndex].id)
        .toList();

    /// 通过已选择的 id 数组和未选择的 id 逐个匹配，判断未选择的是否有sku
    unSelectedSections.forEach((model) {
      model.items.forEach((item) {
        selectedIds.add(item.id);
        selectedIds.sort();
        String id = selectedIds.join("-");
        if (widget.results.contains(id)) {
          item.canSelected = true;
        } else {
          print("没有的sku ---- $id");
          item.canSelected = false;
        }
        selectedIds.remove(item.id);
      });
    });

    bool selectedComplete = true;
    _stringBuffer.clear();
    _stringBuffer.write("请选择");

    widget.itemModels.forEach((SelectedListItemModel model) {
      if (model.selectedIndex == null) {
        selectedComplete = false;
        _stringBuffer.write("  ${model.sectionTitle}");
      }
    });

    if (selectedComplete) {
      _stringBuffer.clear();
      _skuDes.clear();
      _stringBuffer.write("已选择: ");
      widget.itemModels.forEach((SelectedListItemModel model) {
        _stringBuffer.write("${model.items[model.selectedIndex].itemTitle}");
        _skuDes.add(model.items[model.selectedIndex].itemTitle);
      });

      widget.model.data.sku.forEach((sku) {
        selectedIds.sort();
        String selectedIdStr = selectedIds.join("-");
        List skuList = sku.combineId.split(",");
        skuList.sort();
        if (skuList.join("-") == selectedIdStr) {
          _sku = sku;
          selectedIds.clear();
          return;
        }
      });
    } else {
      _sku = null;
      selectedIds.clear();
    }
    setState(() {

    });
    // if (_headerImageState != null) {
    //   _headerImageState(() {});
    // }
    //
    // if (_refreshState != null) {
    //   _refreshState(() {});
    // }
  }
}

class SkuChooseModel {
  int selectedIndex;
  int num;
  Sku sku;
  String des;

  SkuChooseModel(this.selectedIndex, this.num, this.sku, this.des);
}
