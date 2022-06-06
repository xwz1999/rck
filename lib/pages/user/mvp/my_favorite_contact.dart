import 'package:recook/models/my_favorites_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class MyFavoritePresenterI
    extends MvpListViewPresenterI<FavoriteModel, MyFavoriteViewI, MyFavoriteModelI> {

  getFavoritesList(int userId);
  favoriteAdd(int userID, int goodsID);
  favoriteCancel(int userID, FavoriteModel goods);
}

abstract class MyFavoriteModelI extends MvpModel {
  getFavoritesList(int? userId);
  favoriteAdd(int userID, int goodsID);
  favoriteCancel(int? userID, int? goodsID);
}

abstract class MyFavoriteViewI extends MvpView {
  cancelFavoriteSuccess(FavoriteModel goods);
}
