/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  2:17 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/invite_list_model.dart';
import 'package:jingyaoyun/pages/user/invite/invite_list_contact.dart';
import 'package:jingyaoyun/pages/user/invite/invite_list_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/invite/item_invite_detail_list.dart';
import 'package:jingyaoyun/pages/user/invite/user_invite_detail.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:jingyaoyun/widgets/no_data_view.dart';

class ChildInvitePage extends StatefulWidget {
  final int userId;
  final bool isSendUpgradeCard;
  const ChildInvitePage({Key key, this.userId, this.isSendUpgradeCard=false}) : super(key: key);

  // static setArguments(bool isOwner) {
  //   return isOwner;
  // }

  @override
  State<StatefulWidget> createState() {
    return _ChildInvitePage();
  }
}

class _ChildInvitePage extends BaseStoreState<ChildInvitePage>
    with MvpListViewDelegate<InviteModel> implements InviteListViewI{
  
  InviteListPresenterImpl _presenter;
  MvpListViewController<InviteModel> _controller;
  num _inviteCount = 0;

  @override
  MvpListViewPresenterI<InviteModel, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }

  @override
  void initState() {
    super.initState();
    _presenter = InviteListPresenterImpl();
    _presenter.attach(this);
    _controller = MvpListViewController();
    _getInviteCount();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("合计邀请人数: $_inviteCount人", style: TextStyle(color: Colors.black, fontSize: 12),),
          ),
          Expanded(
            child: Container(
              color: AppColor.frenchColor,
              child: MvpListView<InviteModel>(
                autoRefresh: true,
                delegate: this,
                controller: _controller,
                refreshCallback: () {
                  // _presenter.fetch();
                  _presenter.getInviteList(widget.userId, 0, "");
                },
                loadMoreCallback: (page) {
                  _presenter.getInviteList(widget.userId, page, "");
                  // _presenter.loadMore();
                },
                noDataView: NoDataView(title: "还没有邀请任何人喔~", height: 500,),
                itemBuilder: (_,index){
                  return GestureDetector(
                    onTap: (){
                      AppRouter.push(context, RouteName.USER_INVITE_DETAIL, arguments: UserInviteDetail.setArguments(_controller.getData()[index]));
                    },
                    child: InviteDetailListItem(model: _controller.getData()[index],),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _getInviteCount() async{
    ResultData resultData = await HttpManager.post(UserApi.invite_count, {
      'userId': UserManager.instance.user.info.id
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    if (resultData.data['data']['count']!=null && resultData.data['data']['count'] is int) {
      _inviteCount = resultData.data['data']['count'];
      if (mounted) setState(() {}); 
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onDetach() {
  }

  @override
  void onAttach() {
  }
  
  @override
  failure(String msg){
    GSDialog.of(context).showError(globalContext, msg);
  }
}

