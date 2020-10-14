/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-03  14:32 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/goods_detail_images_model.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/models/order_preview_model.dart';

class GoodsDetailModelImpl {
  /// 商品详情
  static Future<GoodsDetailModel> getDetailInfo(int goodsID, int userID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.goods_detail_info, {"goodsID": goodsID, "userId": userID});

    if (!res.result) {
      return GoodsDetailModel(res.code, null, res.msg);
    }
    GoodsDetailModel model = GoodsDetailModel.fromJson(res.data);
    DPrint.printf(model.msg);
    return model;
  }

  // 立即购买
  static Future<OrderPreviewModel> createOrderPreview(
      int userID, int skuID, String skuName, int quantity,
      {int liveId}) async {
    Map param = {
      "userID": userID,
      "skuID": skuID,
      "skuName": skuName,
      "quantity": quantity,
    };
    if (liveId != null) param.putIfAbsent('liveId', () => liveId);
    ResultData res = await HttpManager.post(
      OrderApi.order_create_preview,
      param,
    );

    if (!res.result) {
      return OrderPreviewModel(res.code, null, res.msg);
    }

    OrderPreviewModel model = OrderPreviewModel.fromJson(res.data);
    return model;
  }

  /// 详情图片
  static Future<GoodsDetailImagesModel> getDetailImages(int goodsID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.goods_detail_images, {"goodsID": goodsID});

    if (!res.result) {
      return GoodsDetailImagesModel(code: res.code, data: null, msg: res.msg);
    }
    GoodsDetailImagesModel model = GoodsDetailImagesModel.fromJson(res.data);
    DPrint.printf(model.msg);
    return model;
  }

  /// 发圈动态
  static Future<MaterialListModel> getDetailMoments(
      int userID, int goodsID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.goods_detail_moments, {"userID": userID, "goodsID": goodsID});
    if (!res.result) {
      return MaterialListModel(res.code, null, res.msg);
    }
    MaterialListModel model = MaterialListModel.fromJson(res.data);
    DPrint.printf(model.msg);
    return model;
  }

  /// 发布发圈动态
  static Future<HttpResultModel<BaseModel>> getDetailMomentsCreate(
      Map<String, dynamic> params) async {
    ResultData res =
        await HttpManager.post(GoodsApi.goods_detail_moments_create, params);
    if (!res.result) {
      return HttpResultModel(res.code, null, res.msg, false);
    }
    BaseModel model = BaseModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  /// 关注
  static Future<HttpResultModel<BaseModel>> goodsAttentionCreate(
      int userId, int followId) async {
    ResultData res = await HttpManager.post(AttentionApi.attention_create,
        {"userId": userId, "followId": followId});
    if (!res.result) {
      return HttpResultModel(res.code, null, res.msg, false);
    }
    BaseModel model = BaseModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  /// 取消关注
  static Future<HttpResultModel<BaseModel>> goodsAttentionCancel(
      int userId, int followId) async {
    ResultData res = await HttpManager.post(AttentionApi.attention_cancel,
        {"userId": userId, "followId": followId});
    if (!res.result) {
      return HttpResultModel(res.code, null, res.msg, false);
    }
    BaseModel model = BaseModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  /// 添加收藏
  static Future<HttpResultModel<BaseModel>> favoriteAdd(
      int userID, int goodsID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.goods_favorite_add, {"userID": userID, "goodsID": goodsID});
    if (!res.result) {
      return HttpResultModel(res.code, null, res.msg, false);
    }
    BaseModel model = BaseModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  /// 取消收藏
  static Future<HttpResultModel<BaseModel>> favoriteCancel(
      int userID, int goodsID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.goods_favorite_cancel, {"userId": userID, "goodsId": goodsID});
    if (!res.result) {
      return HttpResultModel(res.code, null, res.msg, false);
    }
    BaseModel model = BaseModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }
}
