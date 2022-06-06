import 'package:recook/models/evaluation_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class EvaluationListPresenterI
    extends MvpListViewPresenterI<Data, EvaluationListViewI, EvaluationListModelI> {
  getEvaluationList(int userId, int goodId, int page);
  loadMore(int userId, int goodsId, int page);
}

abstract class EvaluationListModelI extends MvpModel {
  getEvaluationList(int? userId, int? goodId, int page);
  loadMore(int userId, int goodsId, int page);
}

abstract class EvaluationListViewI extends MvpView {
}
