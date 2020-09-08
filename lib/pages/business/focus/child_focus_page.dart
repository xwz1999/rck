/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  2:17 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/pages/business/focus/mvp/focus_mvp_contact.dart';
import 'package:recook/pages/business/items/item_business_focus.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/pages/business/focus/mvp/focus_presenter_implementation.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/toast.dart';

class FocusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusPageState();
  }
}

class _FocusPageState extends BaseStoreState<FocusPage>
    with MvpListViewDelegate<MaterialModel>
    implements FocusViewI{

  FocusPresenterImpl _presenter;
  MvpListViewController<MaterialModel> _listViewController;

  @override
  void initState() {
    super.initState();
    _presenter = FocusPresenterImpl();
    _presenter.attach(this);
    _listViewController = MvpListViewController();
    int userId = UserManager.instance.user.info.id;
    _presenter.fetchList(userId, 0);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    int userId = 0;
    if (UserManager.instance.haveLogin) userId = UserManager.instance.user.info.id;
    return Container(
      color: AppColor.frenchColor,
      child: MvpListView<MaterialModel>(
        autoRefresh: false,
        delegate: this,
        controller: _listViewController,
        refreshCallback: () {
          _presenter.fetchList(userId, 0);
        },
        loadMoreCallback: (int page) {
          _presenter.fetchList(userId, page);
        },
        itemBuilder: (_, index) {
          MaterialModel indexModel = _listViewController.getData()[index];
          return BusinessFocusItem(
            model: indexModel,
            publishMaterialListener: (){
              AppRouter.push(context, RouteName.COMMODITY_PAGE,arguments: CommodityDetailPage.setArguments(indexModel.goods.id));
            },
            downloadListener: (){
              showLoading("保存图片中...");
              List<String> urls = indexModel.photos.map((f){
                return Api.getResizeImgUrl(f.url, 300);
              }).toList();
              ImageUtils.saveNetworkImagesToPhoto(
                urls, 
                (index){
                  DPrint.printf("保存好了---$index");
                },
                (success){
                  dismissLoading();
                  success ? showSuccess("保存完成!") : showError("保存失败!!");
                  if (!TextUtils.isEmpty(indexModel.text)) {
                    ClipboardData data = new ClipboardData(text:indexModel.text);
                    Clipboard.setData(data);
                    Toast.showCustomSuccess('文字内容已经保存到剪贴板');
                    // showSuccess('文字内容已经保存到剪贴板');
                  }
                }
              );
            },
            copyListener: (){
              if (!TextUtils.isEmpty(indexModel.text)) {
                ClipboardData data = new ClipboardData(text:indexModel.text);
                Clipboard.setData(data);
                Toast.showCustomSuccess('文字内容已经保存到剪贴板');
                // showSuccess('文字内容已经保存到剪贴板');
              }
            },
            picListener: (index){
              List<PicSwiperItem> picSwiperItem = [];
              for (Photos photo in indexModel.photos) {
                picSwiperItem.add(PicSwiperItem(Api.getImgUrl(photo.url)));
              }
              AppRouter.fade(
                    context, 
                    RouteName.PIC_SWIPER, 
                    arguments: PicSwiper.setArguments(
                      index: index, 
                      pics: picSwiperItem,
                    ),
                  );
              // MaterialModel _picModel = _listViewController.getData()[index];
              // AppRouter.push(
              //   context, 
              //   RouteName.PIC_SWIPER, 
              //   arguments: PicSwiper.setArguments(
              //     index: index, 
              //     pics: _picModel.photos.map<PicSwiperItem>(
              //       (f) => PicSwiperItem(Api.getResizeImgUrl(f.url, 300))).toList()
              //       )
              // );
            },
            focusListener: (){
              _attention(_listViewController.getData()[index]);
            },);
        },
        noDataView: NoDataView(title: "您还没有关注任何人喔~", height: 500,),
      ),
    );
  }
  //
  ///关注
  _attention(MaterialModel model) async {
    if (model.isAttention) {//取消关注
    HttpResultModel<BaseModel> resultModel = await GoodsDetailModelImpl.goodsAttentionCancel(
      UserManager.instance.user.info.id, model.userId);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    setState(() {model.isAttention = false;});
  }else{//关注
    HttpResultModel<BaseModel> resultModel = await GoodsDetailModelImpl.goodsAttentionCreate(
      UserManager.instance.user.info.id, model.userId);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    setState(() {model.isAttention = true;});
  }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  MvpListViewPresenterI<MaterialModel,MvpView, MvpModel> getPresenter() {
    return _presenter;
  }

  @override
  void onDetach() {
  }

  @override
  void onAttach() {
  }
}
