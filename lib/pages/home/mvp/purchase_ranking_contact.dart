import 'package:jingyaoyun/models/goods_list_model.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class PurchaseRankingPresenterI
    extends MvpListViewPresenterI<Goods, PurchaseRankingViewI, PurchaseRankingModelI> {
  fetchList(int page,);
}

abstract class PurchaseRankingModelI extends MvpModel {
  fetchList(int page,);
}

abstract class PurchaseRankingViewI extends MvpView {
  
}
