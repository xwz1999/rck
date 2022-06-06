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
import 'package:recook/manager/user_manager.dart';

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
  Future<ResultData> fetchList(
      int? categoryID, int page, SortType type, int? countryId,
      {String? keyword,int? JDType}) async {
            print(countryId.toString()+'|423546756678678');
    late String url;
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

    if (!TextUtils.isEmpty(keyword)) {
      params.putIfAbsent("keyword", () => keyword);
    }


    if(categoryID!=-99){
      params.putIfAbsent("secondCategoryID", () => categoryID);
    }


    if (countryId != null) {
      params.putIfAbsent("country_id", () => countryId);

    }

      params.putIfAbsent("user_id", () => UserManager.instance!.user.info!.id);


    if (type == SortType.priceAsc || type == SortType.salesAsc) {
      params.putIfAbsent("order", () => "asc");
    } else if (type == SortType.priceDesc || type == SortType.salesDesc) {
      params.putIfAbsent("order", () => "desc");
    }
            if (JDType != null) {
              params.putIfAbsent("kind", () => JDType);

            }else{
              params.putIfAbsent("kind", () => 0);
            }

    print(params);

    ResultData resultData = await HttpManager.post(url, params);
    return resultData;
  }

  @override
  Future<ResultData> fetchBrandList(
      int? brandId, int page, SortType type) async {
    late String url;
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

    Map<String, dynamic> params = {"brandId": brandId, "page": page,'user_id':UserManager.instance!.user.info!.id};

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
