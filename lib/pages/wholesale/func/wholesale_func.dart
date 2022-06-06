
import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/guide_order_item_model.dart';
import 'package:recook/models/order_list_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_list_contact.dart';
import 'package:recook/pages/user/model/recommend_user_model.dart';
import 'package:recook/pages/user/order/order_list_page.dart';
import 'package:recook/pages/wholesale/models/goods_dto.dart';
import 'package:recook/pages/wholesale/models/vip_card_model.dart';
import 'package:recook/pages/wholesale/models/wholesale_acitivty_model.dart';
import 'package:recook/pages/wholesale/models/wholesale_banner_model.dart';
import 'package:recook/pages/wholesale/models/wholesale_car_model.dart';
import 'package:recook/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:recook/pages/wholesale/models/wholesale_detail_model.dart';
import 'package:recook/pages/wholesale/models/wholesale_good_model.dart';
import 'package:recook/pages/wholesale/models/wholesale_order_preview_model.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/utils/text_utils.dart';
import 'package:recook/widgets/progress/re_toast.dart';

import '../wholesale_order_list_page.dart';


class WholesaleFunc {

  ///获取VIP体验卡
  static Future<List<VipCardModel>> getVipCardList() async {

    ResultData result = await HttpManager.post(APIV2.userAPI.getVipGoods, {});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => VipCardModel.fromJson(e))
            .toList();
      }else
        return [];
    }else
      return [];
  }

  ///是否领取过7天体验卡
  static Future<bool?> get7() async {

    ResultData result = await HttpManager.post(APIV2.userAPI.get7, {});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return result.data['data']['is_used'];
      }else
        return true;
    }else
      return true;
  }

  ///激活7天体验卡
  static Future<bool> active7() async {

    ResultData result = await HttpManager.post(APIV2.userAPI.active7, {});
    if (result.data != null) {
      if (result.data['code'] != null) {
        if(result.data['code']=='FAIL'){
          return false;
        }else{
          return true;
        }
      }else
        return false;
    }else
      return false;
  }


  static Future<List<WholesaleGood>> getLikeGoodsList(int? userId,{isSale}) async {
    Map<String, dynamic> params = {
      "user_id": userId,
    };

    if (isSale!=null) {
      params.putIfAbsent("is_sale", () => isSale);
    }

    ResultData result = await HttpManager.post(APIV2.userAPI.getLikeGoodsList, params);

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => WholesaleGood.fromJson(e))
            .toList();
      }else
        return [];
    }else
      return [];
  }

  ///获取客服信息
  static Future<WholesaleCustomerModel?> getCustomerInfo() async {
    ///channel 1 购物车购买 0直接购买
    ResultData res = await HttpManager.post(APIV2.wholesaleAPI.getCustomerInfo, {
    });

    // if (!res.result) {
    //   Toast.showInfo(res.msg, color: Colors.black87);
    //   return null;
    // }
    WholesaleCustomerModel? model;
    if(res.data!=null){
      if(res.data['code']=='FAIL'){
        ReToast.err(text: res.data['msg']);
      }
      if(res.data['data']!=null){
        model = WholesaleCustomerModel.fromJson(res.data['data']);
      }else
        model = null;
    }else
      model = null;

    return model;
  }

  ///更新预览订单
  static Future<dynamic> updateOrder(int? addressId,int? previewId,String message) async {
    final cancel = ReToast.loading();
    ResultData result = await HttpManager.post(APIV2.wholesaleAPI.updatePreviewOrder, {
      "preview_id": previewId,
      "address_id": addressId,
      "buyer_message": message,
    });
    cancel();
    BaseModel model = BaseModel.fromJson(result.data);
    if (model.code != HttpStatus.SUCCESS) {
      ReToast.err(text: model.msg);
      return;
    }
    return result;
  }



  ///预览订单
  static Future<WholesaleOrderPreviewModel?> createOrderPreview(
      List<GoodsDTO> list, int channel) async {
    ///channel 1 购物车购买 0直接购买
    ResultData res = await HttpManager.post(APIV2.wholesaleAPI.previewOrder, {
      "user_id": UserManager.instance!.user.info!.id,
      "sku_list": list.map((e) => e.toJson()).toList(),
      'channel': channel
    });

    WholesaleOrderPreviewModel? model;


  if(res.data!=null){
    if(res.data['code']=='FAIL'){
      ReToast.err(text: res.data['msg']);
    }

    if(res.data['data']!=null){
      model = WholesaleOrderPreviewModel.fromJson(res.data['data']);
    }else
      model = null;
  }else
    model = null;

    return model;
  }

  static Future<dynamic> UpdateShopCar(List<GoodsDTO> list) async {
    final cancel = ReToast.loading();
    ResultData result =
        await HttpManager.post(APIV2.wholesaleAPI.updateShopCar, {
      "user_id": UserManager.instance!.user.info!.id,
      "sku_list": list.map((e) => e.toJson()).toList(),
    });
    cancel();
    BaseModel model = BaseModel.fromJson(result.data);
    if (model.code != HttpStatus.SUCCESS) {
      ReToast.err(text: model.msg);
      return;
    }
  }

  static Future<dynamic> addToShoppingCart(List<GoodsDTO> list) async {
    final cancel = ReToast.loading();
    ResultData result = await HttpManager.post(APIV2.wholesaleAPI.addShopCar, {
      "user_id": UserManager.instance!.user.info!.id,
      "sku_list": list.map((e) => e.toJson()).toList(),
    });
    cancel();
    BaseModel model = BaseModel.fromJson(result.data);
    if (model.code != HttpStatus.SUCCESS) {
      ReToast.err(text: model.msg);

      return;
    }

    ReToast.success(text: '加入成功');
  }

  static Future<dynamic> deleteShopCart(List<GoodsDTO> list) async {
    final cancel = ReToast.loading();
    ResultData result =
        await HttpManager.post(APIV2.wholesaleAPI.deleteShopCar, {
      "user_id": UserManager.instance!.user.info!.id,
      "sku_list": list.map((e) => e.toJson()).toList(),
    });
    cancel();
    BaseModel model = BaseModel.fromJson(result.data);
    if (model.code != HttpStatus.SUCCESS) {
      ReToast.err(text: model.msg);

      return;
    }

    ReToast.success(text: '删除成功');
  }

  ///获取购车列表
  static Future<List<WholesaleCarModel>> getCarList() async {
    ResultData result =
        await HttpManager.post(APIV2.wholesaleAPI.getShopCarList, {
      'user_id': UserManager.instance!.user.info!.id,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => WholesaleCarModel.fromJson(e))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  ///获取商品详情
  static Future<WholesaleDetailModel> getDetailInfo(
      int? goodsID, int? userID) async {
    ResultData result = await HttpManager.post(GoodsApi.goods_detail_info_new, {
      "goodsID": goodsID,
      "userId": userID,
      "is_sale": true,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return WholesaleDetailModel.fromJson(result.data['data']);
      } else
        return WholesaleDetailModel();
    } else
      return WholesaleDetailModel();
  }

  ///获取批发活动列表  先获取活动id再根据活动id异步获取商品列表
  static Future<List<WholesaleActivityModel>> getActivityList() async {
    ResultData result =
        await HttpManager.post(APIV2.wholesaleAPI.getActivityList, {});
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => WholesaleActivityModel.fromJson(e))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  ///获取批发活动商品列表
  static Future<List<WholesaleGood>> getGoodsList(
      int page, SortType type,{String? keyword,int? activity_id, int? categoryID}) async {
    String url = '';
    switch (type) {
      case SortType.comprehensive:
        url = GoodsApi.goods_sort_comprehensive;
        break;
      case SortType.salesAsc:
      case SortType.salesDesc:
        url = GoodsApi.goods_sort_sales;
        break;
      case SortType.priceAsc:
      case SortType.priceDesc:
        url = GoodsApi.goods_sort_price;
        break;
    }
    Map<String, dynamic> params = {
      "is_sale": true,
      'user_id': UserManager.instance!.user.info!.id,
      'page': page,
    };

    if (activity_id!=null) {
      params.putIfAbsent("activity_id", () => activity_id);
    }


    if(categoryID!=null){
      params.putIfAbsent("secondCategoryID", () => categoryID);
    }

    if (!TextUtils.isEmpty(keyword)) {
      params.putIfAbsent("keyword", () => keyword);
    }
    if (type == SortType.priceAsc || type == SortType.salesAsc) {
      params.putIfAbsent("order", () => "asc");
    } else if (type == SortType.priceDesc || type == SortType.salesDesc) {
      params.putIfAbsent("order", () => "desc");
    }
    DPrint.printf('${url + params.toString()}');

    ResultData result = await HttpManager.post(url, params);
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => WholesaleGood.fromJson(e))
            .toList();
      } else
        return [];
    } else
      return [];
  }



  static Future<List<OrderModel>> getOrderList(WholesaleOrderListType? type,int page,OrderPositionType? positionType) async {
    late String url;
    switch (type) {
      case WholesaleOrderListType.all:
        url = OrderApi.order_list_all;
        break;
      case WholesaleOrderListType.unPay:
        url = OrderApi.order_list_unpaid;
        break;
      case WholesaleOrderListType.undelivered:
        url = OrderApi.order_list_undelivered;
        break;
      case WholesaleOrderListType.unReceipt:
        url = OrderApi.order_list_receipt;
        break;
      case WholesaleOrderListType.unDeal:
        url = OrderApi.order_list_undeal;
        break;
      case null:
        url = OrderApi.order_list_all;
        break;
    }

    ResultData result =
    await HttpManager.post(url, {"userId": UserManager.instance!.user.info!.id,
      "page": page, "orderType": '','is_sale':true});
    if (result.data != null) {
      if (result.data['data'] != null) {
        return
            (result.data['data'] as List)
                .map((e) => OrderModel.fromJson(e))
                .toList();
      }
      else
        return [];
    }
    else
      return [];
  }

  static Future<List<GuideOrderItemModel>> getSonOrder(WholesaleOrderListType? type,int page) async {
    int status = 0;
    switch (type) {
      case WholesaleOrderListType.all:
        status = 0;
        break;
      case WholesaleOrderListType.unPay:
        status = 1;
        break;
      case WholesaleOrderListType.undelivered:
        status = 2;
        break;
      case WholesaleOrderListType.unReceipt:
        status = 3;
        break;
      case WholesaleOrderListType.unDeal:
        status = 4;
        break;

      case null:
        status = 0;
        break;
    }
    Map<String, dynamic> params = {
      "page": page,
      "limit": 15,
      "status": status,
      'is_sale':true
    };
    ResultData result = await HttpManager.post(
      APIV2.orderAPI.guideOrderList,
      params,
    );
    if (result.data == null) return [];
    if (result.data['data'] == null) return [];
    if (result.data['data']['list'] == null) return [];
    return (result.data['data']['list'] as List)
        .map((e) => GuideOrderItemModel.fromJson(e))
        .toList();
  }

  ///获取购物车列表
  // static Future<List<WholesaleActivityModel>> getGoodsList(int activity_id) async {
  //   ResultData result =
  //   await HttpManager.post(APIV2.wholesaleAPI.getGoodsList, {
  //     "is_sale": true,
  //     'activity_id':activity_id,
  //   });
  //   if (result.data != null) {
  //     if (result.data['data'] != null) {
  //       return (result.data['data'] as List)
  //           .map((e) => WholesaleActivityModel.fromJson(e))
  //           .toList();
  //     }
  //     else
  //       return [];
  //   }
  //   else
  //     return [];
  // }

  ///获取banner图
  static Future<List<WholesaleBannerModel>> getBannerList() async {
    ResultData result =
        await HttpManager.post(APIV2.wholesaleAPI.getBannerList, {});
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => WholesaleBannerModel.fromJson(e))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  //推荐申请
  static Future<ResultData> recommendUser(int kind, String mobile,
      String address, String businessPhoto, String mainPhoto, String code
      //1=云店铺 2=VIP店铺
      ) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.recommendUser, {
      "kind": kind,
      'mobile': mobile,
      'address': address,
      'business_photo': businessPhoto,
      'main_photo': mainPhoto,
      'code': code
    });

    return result;
  }

  //推荐申请列表
  static Future<List<RecommendUserModel>> getRecommendUserList(
      int? lastId, int size, int? state) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.recommendUserList, {
      'last_id': lastId,
      'size': size,
      'state': state,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => RecommendUserModel.fromJson(e))
            .toList();
      } else
        return [];
    } else
      return [];
  }
// //获取商品属性
// static Future<AirItemModel> getAirTicketGoodsList() async {
//   ResultData result =
//   await HttpManager.post(APIV2.ticketAPI.getAirTicketGoodsList, {
//     "id": UserManager.instance.user.info.id,
//   });
//
//   if (result.data != null) {
//     if (result.data['data'] != null) {
//       if (result.data['data']['air_items_list_response'] != null)
//         return AirItemModel.fromJson(
//             result.data['data']['air_items_list_response']);
//       else
//         return AirItemModel();
//     }
//     else
//       return AirItemModel();
//   }
//   else
//     return AirItemModel();
//
// }
//
// //获取城市和机场列表
// static Future<List<AirportCityModel>> getCityAirportList() async {
//   ResultData result =
//   await HttpManager.post(APIV2.ticketAPI.getCityAirportList, {});
//   if (result.data != null) {
//     if (result.data['data'] != null) {
//       return (result.data['data'] as List)
//           .map((e) => AirportCityModel.fromJson(e))
//           .toList();
//     }
//     else
//       return [];
//   }
//   else
//     return [];
// }
//
// //获取两个城市之间的航线//输入的是两个城市间的站点选择城市则输入所有的站点
// static Future<List<AirLineModel>> getAirLineList(
//     List<String> from, String itemId, String date, List<String> to) async {
//   ResultData result = await HttpManager.post(APIV2.ticketAPI.getAirLineList, {
//     'id': UserManager.instance.user.info.id,
//     'from': from,
//     'item_id': itemId,
//     'date': date,
//     'to': to
//   });
//   if (result.data != null) {
//     if (result.data['data'] != null) {
//       return (result.data['data'] as List)
//           .map((e) => AirLineModel.fromJson(e))
//           .toList();
//     }
//     else
//       return [];
//   }
//   else
//     return [];
// }
//
// //获取订单列表
// static Future<List<AirOrderModel>> getAirOrderList() async {
//   ResultData result =
//   await HttpManager.post(APIV2.ticketAPI.getAirOrderList, {
//     'user_id': UserManager.instance.user.info.id,
//   });
//   if (result.data != null) {
//     if (result.data['data'] != null) {
//       return (result.data['data'] as List)
//           .map((e) => AirOrderModel.fromJson(e))
//           .toList();
//     }
//     else
//       return [];
//   }
//   else
//     return [];
// }
//
// //取消订单
// static Future<String> changeOrderStatus(
//     int orderId,
//     ) async {
//   ResultData result = await HttpManager.post(APIV2.ticketAPI.changeOrderStatus, {
//     'user_id':UserManager.instance.user.info.id,
//     "order_id": orderId,
//     'status':5
//   });
//   if (result.data != null) {
//     return result.data['code'];
//   }
//   else
//     return null;
// }

}
