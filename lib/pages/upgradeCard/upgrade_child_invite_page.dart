/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  2:17 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/invite_list_model.dart';
import 'package:recook/pages/user/invite/invite_list_contact.dart';
import 'package:recook/pages/user/invite/invite_list_presenter_impl.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/no_data_view.dart';

class UpgradeChildInvitePageController {
  Function(String searchText) refresh;
}

class UpgradeChildInvitePage extends StatefulWidget {
  final int userId;

  final String searchText;
  final UpgradeChildInvitePageController controller;
  final Function(InviteModel) itemClick;

  const UpgradeChildInvitePage({
    Key key,
    this.userId,
    this.searchText = "",
    this.controller,
    this.itemClick,
  }) : super(key: key);

  // static setArguments(bool isOwner) {
  //   return isOwner;
  // }

  @override
  State<StatefulWidget> createState() {
    return _UpgradeChildInvitePage();
  }
}

class _UpgradeChildInvitePage extends BaseStoreState<UpgradeChildInvitePage>
    with MvpListViewDelegate<InviteModel>
    implements InviteListViewI {
  InviteListPresenterImpl _presenter;
  MvpListViewController<InviteModel> _controller;
  String _searchText;

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
    _searchText = TextUtils.isEmpty(widget.searchText) ? "" : widget.searchText;
    widget.controller.refresh = (searchText) {
      _searchText = searchText;
      _controller.requestRefresh();
      setState(() {});
    };
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Container(
      color: AppColor.frenchColor,
      child: MvpListView<InviteModel>(
        autoRefresh: true,
        delegate: this,
        controller: _controller,
        refreshCallback: () {
          // _presenter.fetch();
          _presenter.getInviteList(widget.userId, 0, _searchText);
        },
        loadMoreCallback: (page) {
          _presenter.getInviteList(widget.userId, page, _searchText);
          // _presenter.loadMore();
        },
        noDataView: NoDataView(
          title: TextUtils.isEmpty(_searchText) ? "还没有邀请任何人喔~" : "搜索不到该邀请用户...",
          height: 500,
        ),
        itemBuilder: (_, index) {
          // return GestureDetector(
          //   onTap: () {
          //     if (widget.itemClick != null) {
          //       widget.itemClick(_controller.getData()[index]);
          //     }
          //   },
          //   child: InviteDetailListItem(
          //     model: _controller.getData()[index],
          //     isUpgrade: true,
          //   ),
          // );
          InviteModel model = _controller.getData()[index];
          return UserGroupCard(
            name: model.nickname,
            wechatId: model.wechatNo,
            phone: model.phoneNum,
            shopRole: UserLevelTool.roleLevelEnum(model.roleLevel),
            groupCount: model.count,
            headImg: model.headImgUrl,
            id: model.userId,
            isRecommend: false,
            remarkName: model.remarkName,
            onTap: () {
              if (widget.itemClick != null) {
                widget.itemClick(_controller.getData()[index]);
              }
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onDetach() {}

  @override
  void onAttach() {}

  @override
  failure(String msg) {
    GSDialog.of(context).showError(globalContext, msg);
  }
}
