/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  5:20 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'goods_list_contact.dart';

class GoodsListModelImpl extends GoodListModelI {
  @override
  Future<ResultData> fetchSearchList(String keyword, int page) async {
    String url = GoodsApi.goods_search_list;

    Map<String, dynamic> params = {
      "page": page,
    };
    ResultData resultData = await HttpManager.post(url, params);
    return resultData;
  }

  @override
  Future<ResultData> fetchList(int categoryID, int page, SortType type,
      {String keyword}) async {
    String url;
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
      "page": page,
    };

    if (!TextUtils.isEmpty(keyword)&&categoryID==-99) {
      params.putIfAbsent("keyword", () => keyword);
    } else {
      params.putIfAbsent("secondCategoryID", () => categoryID);
    }

    if (type == SortType.priceAsc || type == SortType.salesAsc) {
      params.putIfAbsent("order", () => "asc");
    } else if (type == SortType.priceDesc || type == SortType.salesDesc) {
      params.putIfAbsent("order", () => "desc");
    }

    ResultData resultData = await HttpManager.post(url, params);
    return resultData;
  }

  @override
  Future<ResultData> fetchBrandList(
      int brandId, int page, SortType type) async {
    String url;
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

    Map<String, dynamic> params = {"brandId": brandId, "page": page};

    if (type == SortType.priceAsc || type == SortType.salesAsc) {
      params.putIfAbsent("order", () => "asc");
    } else if (type == SortType.priceDesc || type == SortType.salesDesc) {
      params.putIfAbsent("order", () => "desc");
    }
    DPrint.printf('${url + params.toString()}');
    ResultData resultData = await HttpManager.post(url, params);
    return resultData;
  }
}
