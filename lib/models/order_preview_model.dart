import 'package:json_annotation/json_annotation.dart';

import 'package:jingyaoyun/models/base_model.dart';

part 'order_preview_model.g.dart';

/*
{
    "code":"SUCCESS",
    "data":{
        "id":50,
        "userId":2,
        "actualAmount":0.01,
        "coupon":null,
        "addr":{
            "id":45,
            "addressId":17,
            "province":"河北省",
            "city":"邯郸市",
            "district":"复兴区",
            "address":"123",
            "receiverName":"呵呵",
            "mobile":"18131231231",
            "isDeliveryArea":0
        },
        "brands":[
            {
                "id":50,
                "brandId":1,
                "brandName":"测试品牌",
                "brandLogoUrl":"/photo/fb3701c8f6adde26d60d2da988ee09c9.png",
                "actualAmount":0.01,
                "expressFee":0,
                "comment":"",
                "goods":[
                    {
                        "id":47,
                        "brandDetailId":50,
                        "goodsId":10,
                        "goodsName":"美女装 网红品牌 夏装",
                        "skuId":10,
                        "skuName":"红色",
                        "price":0.01,
                        "mainPhotoUrl":"/photo/1561431788095859.jpg",
                        "quantity":1,
                        "FreightID":1,
                        "commission":0,
                        "couponAmount":0,
                        "balanceAmount":0,
                        "actualAmount":0.01,
                        "promotion":null
                    }
                ],
                "coupon":null
            }
        ]
    },
    "msg":"操作成功"
}
 */

/*
{
 ID                        uint             `gorm:"column:id;primary_key" json:"id"`
 ParentID                  uint             `gorm:"column:parent_id" json:"parent_id" `                                   // 分享者id，链接购买则是分享者id。其他方式则是自己上级的id
 UserID                    uint             `gorm:"column:user_id" json:"userId"`                                         // 下单者
 IsSubordinate             uint             `gorm:"column:is_subordinate" json:"isSubordinate"`                           // 是否为上下级：0不是 1是
 Title                     string           `gorm:"column:title" json:"-"`                                                // 订单简要标题
 BrandCouponTotalAmount    float64          `gorm:"column:brand_coupon_total_amount" json:"brandCouponTotalAmount"`       // 品牌优惠券抵扣总金额
 UniverseCouponTotalAmount float64          `gorm:"column:universe_coupon_total_amount" json:"universeCouponTotalAmount"` // 购物券抵扣总金额
 CoinTotalAmount           float64          `gorm:"column:coin_total_amount" json:"coinTotalAmount"`                      // 瑞币抵扣总金额
 ExpressTotalFee           float64          `gorm:"column:express_total_fee" json:"expressTotalFee"`                      // 总快递费
 GoodsTotalAmount          float64          `gorm:"column:goods_total_amount" json:"goodsTotalAmount"`                    // 商品总金额
 GoodsTotalCommission      float64          `gorm:"column:goods_total_commission" json:"goodsTotalCommission"`            // 商品总返还金额
 ActualTotalAmount         float64          `gorm:"column:actual_total_amount" json:"actualTotalAmount"`                  // 实际支付的金额
 Channel                   uint             `gorm:"column:channel" json:"-"`                                              // 下单渠道：0详情页直接购买 1购物车结算购买'
 ShippingMethod            uint             `gorm:"column:shipping_method" json:"shippingMethod"`                         // 配送方式 0快递 1自提
 StoreID                   uint             `gorm:"column:store_id" json:"-"`                                             // 门店id
 BuyerMessage              string           `gorm:"column:buyer_message" json:"buyerMessage"`                             // 买家留言。不超过50个字
 CreatedAt                 formatime.Second `gorm:"column:created_at" json:"-"`                                           // 创建时间
 coupon: {
  ID               uint             `gorm:"column:id;primary_key" json:"id"`
  OrderID          uint             `gorm:"column:order_id" json:"-"`
  BrandID          uint             `gorm:"column:brand_id" json:"-"`
  PersonalCouponID uint             `gorm:"column:personal_coupon_id" json:"-"`
  Scope            uint             `gorm:"column:scope" json:"scope"`
  CouponID         uint             `gorm:"column:coupon_id" json:"-"`
  CouponName       string           `gorm:"column:coupon_name" json:"couponName"`
  DeductedAmount   float64          `gorm:"column:deducted_amount" json:"deductedAmount"`
  EndTime          formatime.Second `gorm:"column:end_time" json:"-"`
 },
 addr:{
  OrderID        uint   `gorm:"column:order_id" json:"-"`
  AddressID      uint   `gorm:"column:address_id" json:"addressId"`
  Province       string `gorm:"column:province" json:"province"`               // 省
  City           string `gorm:"column:city" json:"city"`                       // 市
  District       string `gorm:"column:district" json:"district"`               // 区县
  Address        string `gorm:"column:address" json:"address"`                 // 具体地址
  ReceiverName   string `gorm:"column:receiver_name" json:"receiverName"`      // 收件人姓名
  Mobile         string `gorm:"column:mobile" json:"mobile"`                   // 手机号码
  IsDeliveryArea uint   `gorm:"column:is_delivery_area" json:"isDeliveryArea"` // 是否属于发货地区 1属于发货地区 0不属于
 },
 brand:[
  {
   BrandID                 uint                        `json:"brandId"`
   BrandName               string                      `json:"brandName"`
   BrandLogoUrl            string                      `json:"brandLogoUrl"`
   BrandExpressTotalAmount float64                     `json:"brandExpressTotalAmount"`
   BrandGoodsTotalAmount   float64                     `json:"brandGoodsTotalAmount"`
   BrandGoodsTotalCount    uint                        `json:"brandGoodsTotalCount"`
   goods: [
    OrderID              uint             `gorm:"column:order_id" json:"orderId"`
    VendorID             uint             `gorm:"column:vendor_id" json:"vendorId"`           // 供应商ID: 0表示自营
    BrandID              uint             `gorm:"column:brand_id" json:"brandId"`             // 品牌
    BrandName            string           `gorm:"column:brand_name" json:"brandName"`         // 品牌名称
    GoodsID              uint             `gorm:"column:goods_id" json:"goodsId"`             // 商品ID
    GoodsName            string           `gorm:"column:goods_name" json:"goodsName"`         // 商品名快照
    Hash                 string           `gorm:"column:hash" json:"-"`                       // 商品哈希值如果商品信息更新了
    SkuID                uint             `gorm:"column:sku_id" json:"skuId"`                 // 商品sku_id
    SkuName              string           `gorm:"column:sku_name" json:"skuName"`             // SKU名字组合起来
    SkuCode              string           `gorm:"column:sku_code" json:"skuCode"`             // 条形码或者编码
    MainPhotoURL         string           `gorm:"column:main_photo_url" json:"mainPhotoUrl"`  // 主图快照 先读sku 没有则读取主图
    Quantity             uint             `gorm:"column:quantity" json:"quantity"`            // 商品数量
    FreightID            uint             `gorm:"column:freight_id" json:"-"`                 // 运费模板
    Weight               float64          `gorm:"column:weight" json:"-"`                     // 重量
    PromotionId          uint             `gorm:"column:promotion_id" json:"-"`               // 活动ID
    PromotionName        string           `gorm:"column:promotion_name" json:"promotionName"` // 活动名称
    PromotionStartTime   formatime.Second `gorm:"column:promotion_start_time" json:"-"`
    PromotionEndTime     formatime.Second `gorm:"column:promotion_end_time" json:"-"`
    UnitPrice            float64          `gorm:"column:unit_price" json:"unitPrice"`                             // 单价
    TotalCommission      float64          `gorm:"column:total_commission" json:"totalCommission"`                 // 提成总额
    BrandCouponAmount    float64          `gorm:"column:brand_coupon_amount" json:"brandCouponAmount"`            // 品牌优惠券抵扣金额
    UniverseCouponAmount float64          `gorm:"column:universe_coupon_amount" json:"universeBrandCouponAmount"` // 购物券抵扣金额
    CoinAmount           float64          `gorm:"column:coin_amount" json:"coinAmount"`                           // 瑞币抵扣金额
    GoodsAmount          float64          `gorm:"column:goods_amount" json:"goodsAmount"`                         // 商品总金额 单价x数量，不含其他费用减除
    ExpressFee           float64          `gorm:"column:express_fee" json:"expressFee"`                           // 快递费
    ActualAmount         float64          `gorm:"column:actual_amount" json:"actualAmount"`                       // 实际支付的金额
    coupon: {
     ID               uint             `gorm:"column:id;primary_key" json:"id"`
     OrderID          uint             `gorm:"column:order_id" json:"-"`
     BrandID          uint             `gorm:"column:brand_id" json:"-"`
     PersonalCouponID uint             `gorm:"column:personal_coupon_id" json:"-"`
     Scope            uint             `gorm:"column:scope" json:"scope"`
     CouponID         uint             `gorm:"column:coupon_id" json:"-"`
     CouponName       string           `gorm:"column:coupon_name" json:"couponName"`
     DeductedAmount   float64          `gorm:"column:deducted_amount" json:"deductedAmount"`
     EndTime          formatime.Second `gorm:"column:end_time" json:"-"`
    }
   ] 
  }
 ]
}
*/

@JsonSerializable()
class OrderPreviewModel extends BaseModel {
  OrderDetail data;

  OrderPreviewModel(code, this.data, msg) : super(code, msg);

  factory OrderPreviewModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderPreviewModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderPreviewModelToJson(this);
}

@JsonSerializable()
class OrderDetail extends Object {
  int id; //'订单id',
  int parentId; //'分享者id，链接购买则是分享者id。其他方式则是自己上级的id',
  int userId; //'下单者',
  int isSubordinate; //'是否为上下级：0不是 1是',
  double brandCouponTotalAmount; //'品牌优惠券抵扣总金额，即使发生售后也不变，交易快照',
  double universeCouponTotalAmount; //'购物券抵扣总金额，即使发生售后也不变，交易快照',
  double coinTotalAmount; //'瑞币抵扣总金额，即使发生售后也不变，交易快照',
  double expressTotalFee; //'总快递费，即使发生售后也不变，交易快照',
  double goodsTotalAmount; //商品总金额，单价x数量，不含其他费用减除，即使发生售后也不变，交易快照
  double goodsTotalCommission; //'商品总返还金额，即使发生售后也不变，交易快照',
  double actualTotalAmount; //'实际支付的金额，商品总金额+快递费-瑞比-优惠券，即使发生售后也不变，交易快照',
  int shippingMethod; //'0快递 1自提',
  String buyerMessage; //'买家留言。不超过50个字',
  int totalGoodsCount; //该订单下商品数总和
  num userRole;

  // double coinAmount;
  // double actualAmount;
  // int shippingMethod;
  // String buyerMessage;

  Coupon coupon;
  Addr addr;
  List<Brands> brands;
  CoinStatus coinStatus;

  ///海外订单
  bool hasAuth;
  // Balance balance;

  OrderDetail(
      this.id,
      this.parentId,
      this.userId,
      this.isSubordinate,
      this.brandCouponTotalAmount,
      this.universeCouponTotalAmount,
      this.coinTotalAmount,
      this.expressTotalFee,
      this.goodsTotalAmount,
      this.goodsTotalCommission,
      this.actualTotalAmount,
      this.shippingMethod,
      this.buyerMessage,
      this.totalGoodsCount,
      this.coupon,
      this.addr,
      this.brands,
      this.userRole,
      this.coinStatus,
      this.hasAuth);

  factory OrderDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}

@JsonSerializable()
class CoinStatus extends Object {
  /*
  coin	number	非必须
  isUseCoin	boolean	非必须
  isEnable	boolean	非必须
  */
  num coin;
  bool isUseCoin;
  bool isEnable;
  CoinStatus(this.coin, this.isUseCoin, this.isEnable);
  factory CoinStatus.fromJson(Map<String, dynamic> srcJson) =>
      _$CoinStatusFromJson(srcJson);
  Map<String, dynamic> toJson() => _$CoinStatusToJson(this);
}

@JsonSerializable()
class Coupon extends Object {
  int id;

  int brandId;

  int scope;

  String couponName; //'使用的优惠券名称'

  double deductedAmount; //'抵扣的金额',

  Coupon(
    this.id,
    this.brandId,
    this.scope,
    this.couponName,
    this.deductedAmount,
  );

  factory Coupon.fromJson(Map<String, dynamic> srcJson) =>
      _$CouponFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CouponToJson(this);
}

@JsonSerializable()
class Addr extends Object {
  int id;

  int addressId;

  String province;

  String city;

  String district;

  String address;

  String receiverName;

  String mobile;

  int isDeliveryArea;

  Addr(
    this.id,
    this.addressId,
    this.province,
    this.city,
    this.district,
    this.address,
    this.receiverName,
    this.mobile,
    this.isDeliveryArea,
  );

  factory Addr.fromJson(Map<String, dynamic> srcJson) =>
      _$AddrFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddrToJson(this);
}

@JsonSerializable()
class Brands extends Object {
  // int id;

  int brandId;

  String brandName;

  String brandLogoUrl;

  //
  double brandExpressTotalAmount; //该品牌下商品总运费
  double brandGoodsTotalAmount; //该品牌下商品瑞比抵扣掉的金额
  int brandGoodsTotalCount; //该品牌下商品总数量
  //
  // double actualAmount;

  // double expressFee;

  List<OrderGoods> goods;

  Coupon coupon;

  Brands(
      this.brandId,
      this.brandName,
      this.brandLogoUrl,
      this.brandExpressTotalAmount,
      this.brandGoodsTotalAmount,
      this.brandGoodsTotalCount,
      this.goods,
      this.coupon);

  factory Brands.fromJson(Map<String, dynamic> srcJson) =>
      _$BrandsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BrandsToJson(this);
}

@JsonSerializable()
class OrderGoods extends Object {
  int goodsId; //// 商品ID
  String goodsName; // 商品名快照
  int skuId; // 商品sku_id
  String skuName; // SKU名字组合起来
  String skuCode; // 条形码或者编码
  String mainPhotoUrl; // 主图快照 先读sku 没有则读取主图
  int quantity; // 商品数量
  String promotionName; // 活动名称

  double unitPrice; //单价
  double totalCommission; //提成总额
  double brandCouponAmount; //品牌优惠券抵扣金额
  double universeBrandCouponAmount; //购物券抵扣金额
  double coinAmount; //瑞币抵扣金额
  double goodsAmount; //商品总金额 单价x数量，不含其他费用减除
  double expressFee; //快递费
  double actualAmount; //实际支付的金额
  num isImport;
  num isFerme;
  num storehouse;

  OrderGoods(
    this.goodsId,
    this.goodsName,
    this.skuId,
    this.skuName,
    this.skuCode,
    this.mainPhotoUrl,
    this.quantity,
    this.promotionName,
    this.unitPrice,
    this.totalCommission,
    this.brandCouponAmount,
    this.universeBrandCouponAmount,
    this.coinAmount,
    this.goodsAmount,
    this.expressFee,
    this.actualAmount,
    this.isImport,
    this.isFerme,
    this.storehouse,
  );

  factory OrderGoods.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderGoodsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderGoodsToJson(this);
}

@JsonSerializable()
class Balance extends Object {
  int id;

  double deductedAmount;

  Balance(
    this.id,
    this.deductedAmount,
  );

  factory Balance.fromJson(Map<String, dynamic> srcJson) =>
      _$BalanceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}
