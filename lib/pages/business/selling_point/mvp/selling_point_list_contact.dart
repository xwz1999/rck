import 'package:jingyaoyun/models/goods_list_model.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class SellingPointListPresenterI
    extends MvpListViewPresenterI<Goods, SellingPointListViewI, SellingPointListModelI> {
  fetchList(int page,);
}

abstract class SellingPointListModelI extends MvpModel {
  fetchList(int page,);
}

abstract class SellingPointListViewI extends MvpView {
  
}
