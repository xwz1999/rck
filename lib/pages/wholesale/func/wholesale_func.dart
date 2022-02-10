
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/model/recommend_user_model.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_banner_model.dart';


class WholesaleFunc {
  //推荐申请列表
  static Future<List<RecommendUserModel>> getRecommendUserList(int lastId,int size,int state) async {
    ResultData result =
    await HttpManager.post(APIV2.userAPI.recommendUserList, {
      'last_id':lastId,
      'size':size,
      'state':state,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => RecommendUserModel.fromJson(e))
            .toList();
      }
      else
        return [];
    }
    else
      return [];
  }

  ///获取banner图
  static Future<List<WholesaleBannerModel>> getBannerList() async {
    ResultData result =
    await HttpManager.post(APIV2.wholesaleAPI.getBannerList, {
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => WholesaleBannerModel.fromJson(e))
            .toList();
      }
      else
        return [];
    }
    else
      return [];
  }

  //推荐申请
  static Future<ResultData> recommendUser(
      int kind,String mobile,String address ,String businessPhoto ,String mainPhoto,String code  //1=云店铺 2=实体店
      ) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.recommendUser, {
      "kind": kind,
      'mobile':mobile,
      'address':address,
      'business_photo':businessPhoto,
      'main_photo':mainPhoto,
      'code':code
    });

        return result;

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
