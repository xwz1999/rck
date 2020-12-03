import 'package:json_annotation/json_annotation.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/goods_detail_model.dart';

part 'shopping_cart_list_model.g.dart';

/*
{
    "code":"SUCCESS",
    "data":[
        {
            "id":3,
            "brandID":1,
            "brandLogo":"/photo/fb3701c8f6adde26d60d2da988ee09c9.png",
            "brandName":"测试品牌",
            "children":[
                {
                    "id":1,
                    "goodsId":14,
                    "goodsName":"Beanpole 户外女装速干衣服 男女通用",
                    "mainPhotoUrl":"/photo/1561447903300379.png",
                    "skuName":"M-港版-紫色",
                    "skuId":28,
                    "quantity":1,
                    "valid":0,
                    "price":75
                },
                {
                    "id":2,
                    "goodsId":14,
                    "goodsName":"Beanpole 户外女装速干衣服 男女通用",
                    "mainPhotoUrl":"/photo/1561447930784699.jpg",
                    "skuName":"M-港版-黑色",
                    "skuId":37,
                    "quantity":2,
                    "valid":0,
                    "price":75
                }
            ]
        },
        {
            "id":4,
            "brandID":4,
            "brandLogo":"/photo/fb3701c8f6adde26d60d2da988ee09c9.png",
            "brandName":"测试品牌2",
            "children":[
                {
                    "id":3,
                    "goodsId":16,
                    "goodsName":"阿迪达斯三叶草☘️ 经典 古天乐同款小白衣服",
                    "mainPhotoUrl":"/photo/1561704981951966.jpg",
                    "skuName":"蓝色",
                    "skuId":42,
                    "quantity":1,
                    "valid":0,
                    "price":97.02
                }
            ]
        }
    ],
    "msg":"操作成功"
}


 */
@JsonSerializable()
class ShoppingCartListModel extends BaseModel {
  List<ShoppingCartBrandModel> data;

  ShoppingCartListModel(
    code,
    this.data,
    msg,
  ) : super(code, msg);

  factory ShoppingCartListModel.fromJson(Map<String, dynamic> srcJson) =>
      _$ShoppingCartListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ShoppingCartListModelToJson(this);
}

@JsonSerializable()
class ShoppingCartBrandModel extends Object {
  int id;

  int brandID;

  String brandLogo;

  String brandName;

  List<ShoppingCartGoodsModel> children;

  bool selected;
  bool isShowMore;
  ShoppingCartBrandModel(
      this.id, this.brandID, this.brandLogo, this.brandName, this.children,this.selected ) {
    this.selected = false; isShowMore = false;
  }

  factory ShoppingCartBrandModel.fromJson(Map<String, dynamic> srcJson) =>
      _$ShoppingCartBrandModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ShoppingCartBrandModelToJson(this);
  bool isAllWaitPromotionStart(){
    // 判断当前所以商品是否都在等待活动开始
    if (this.children == null || this.children.length == 0) {
      return false;
    }
    for (ShoppingCartGoodsModel _model in this.children) {
      if (!_model.isWaitPromotionStart()) {
        // 只要有一个商品没有在等待活动开始  就是否
        return false;
      }
    }
    return true;
  }
}

@JsonSerializable()
class ShoppingCartGoodsModel extends Object {
  int shoppingTrolleyId;
  int goodsId;

  String goodsName;

  String mainPhotoUrl;

  String skuName;

  int skuId;

  int quantity;

  bool valid;

  double price;

  bool selected;
  String promotionName;
  Promotion promotion;
  num commission;
  num originalPrice;
  int isImport;
  int isFerme;
  int storehouse;
  num ferme;
  ShoppingCartGoodsModel(
      this.shoppingTrolleyId,
      this.goodsId,
      this.goodsName,
      this.mainPhotoUrl,
      this.skuName,
      this.skuId,
      this.quantity,
      this.valid,
      this.price,
      this.promotionName,
      this.selected,
      this.promotion,
      this.commission,
      this.originalPrice,
      this.isImport,
      this.isFerme,
      this.storehouse,
      this.ferme,
      ) {
    this.selected = false;
  }

  factory ShoppingCartGoodsModel.fromJson(Map<String, dynamic> srcJson) =>
      _$ShoppingCartGoodsModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ShoppingCartGoodsModelToJson(this);

  ShoppingCartGoodsModel.empty();

  bool isWaitPromotionStart(){
    if (this.promotion != null && this.promotion.isWaitPromotionStart()) {
      return true;
    }
    return false;
  }
}
