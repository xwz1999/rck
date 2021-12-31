import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/goods_list_model.dart';
import 'package:jingyaoyun/pages/business/selling_point/mvp/selling_point_list_contact.dart';
import 'package:jingyaoyun/pages/business/selling_point/mvp/selling_point_list_model_impl.dart';

class SellingPointListPresenterImpl extends SellingPointListPresenterI {
  @override
  SellingPointListModelI initModel() {
    return SellingPointListModelImpl();
  }

  @override
  fetchList(int page,) {
    getModel().fetchList(page,).then((ResultData response) {
      if (!response.result) {
        getRefreshView().refreshFailure(response.msg);
      } else {
//        getRefreshView().refreshSuccess([]);
        GoodsListModel model = GoodsListModel.fromJson(response.data);
        if (model.code == HttpStatus.SUCCESS) {
          if (page == 0) {
            getRefreshView().refreshSuccess(model.data);
          } else {
            getRefreshView().loadMoreSuccess(model.data);
          }
        } else {
          if (page == 0) {
            getRefreshView().refreshFailure(model.msg);
          } else {
            getRefreshView().loadMoreFailure(error : model.msg);
          }
        }
      }
    });
  }
}
