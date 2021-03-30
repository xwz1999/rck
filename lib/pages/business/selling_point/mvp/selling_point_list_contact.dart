import 'package:recook/models/goods_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class SellingPointListPresenterI
    extends MvpListViewPresenterI<Goods, SellingPointListViewI, SellingPointListModelI> {
  fetchList(int page,);
}

abstract class SellingPointListModelI extends MvpModel {
  fetchList(int page,);
}

abstract class SellingPointListViewI extends MvpView {
  
}
