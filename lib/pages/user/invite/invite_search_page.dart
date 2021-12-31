import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/invite_list_model.dart';
import 'package:jingyaoyun/pages/user/invite/invite_list_contact.dart';
import 'package:jingyaoyun/pages/user/invite/invite_list_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/invite/item_invite_detail_list.dart';
import 'package:jingyaoyun/pages/user/invite/user_invite_detail.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:jingyaoyun/widgets/no_data_view.dart';
import 'package:jingyaoyun/widgets/progress/sc_dialog.dart';

class InviteSearchPage extends StatefulWidget {
  InviteSearchPage({Key key}) : super(key: key);

  @override
  _InviteSearchPageState createState() => _InviteSearchPageState();
}

class _InviteSearchPageState extends BaseStoreState<InviteSearchPage>
    with MvpListViewDelegate<InviteModel>
    implements InviteListViewI {
  InviteListPresenterImpl _presenter;
  MvpListViewController<InviteModel> _controller;
  TextEditingController _textEditController;
  FocusNode _contentFocusNode = FocusNode();
  String _searchText = "";
  bool _displayList = true;
  List<String> _searchHistory = [];
  bool _startSearch = false;
  @override
  void initState() {
    super.initState();
    getSearchListFromSharedPreferences();
    _textEditController = TextEditingController();
    _presenter = InviteListPresenterImpl();
    _presenter.attach(this);
    _controller = MvpListViewController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      // appBar: CustomAppBar(title: "搜索"),
      appBar: CustomAppBar(
        elevation: 0,
        title: _buildTitle(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: TextUtils.isEmpty(_textEditController.text)
            ? <Widget>[
                Container(
                  width: 10,
                )
              ]
            : _rightActions(getStore()),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            child: _buildList(context),
          ),
          Positioned(
              child: Offstage(
                  offstage: !TextUtils.isEmpty(_textEditController.text) &&
                      _startSearch,
                  child: Container(
                    color: AppColor.frenchColor,
                    child: Container(
                        child: ListView(
                      children: <Widget>[
                        _searchHistoryWidget(),
                      ],
                    )),
                  ))),
        ],
      ),
    );
  }

  _buildList(BuildContext context) {
    return MvpListView<InviteModel>(
      noDataView: NoDataView(
        title: "换个关键词搜索一下吧~",
        height: 500,
      ),
      autoRefresh: false,
      delegate: this,
      controller: _controller,
      type: ListViewType.list,
      refreshCallback: () {
        if (TextUtils.isEmpty(_searchText)) {
          refreshSuccess([]);
          return;
        }
        _presenter.getInviteList(
          UserManager.instance.user.info.id,
          0,
          _searchText,
        );
      },
      loadMoreCallback: (int page) {
        _presenter.getInviteList(
          UserManager.instance.user.info.id,
          page,
          _searchText,
        );
      },
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            AppRouter.push(context, RouteName.USER_INVITE_DETAIL,
                arguments: UserInviteDetail.setArguments(
                    _controller.getData()[index]));
          },
          child: InviteDetailListItem(
            model: _controller.getData()[index],
          ),
        );
      },
      // gridViewBuilder:() => _buildGridView(),
    );
  }

  List<Widget> _rightActions(store) {
    return <Widget>[
      Container(
        margin: EdgeInsets.only(right: rSize(10), left: rSize(10)),
        child: CustomImageButton(
          title: "搜索",
          // buttonSize: 60,
          color: TextUtils.isEmpty(_searchText) ? Colors.grey : Colors.black,
          fontSize: 15 * 2.sp,
          onPressed: () {
            if (TextUtils.isEmpty(_searchText)) return;
            _startSearch = true;
            _contentFocusNode.unfocus();
            _presenter.getInviteList(
                UserManager.instance.user.info.id, 0, _searchText);
            setState(() {});
          },
        ),
      )
    ];
  }

  Widget _buildTitle() {
    return Container(
        height: 30,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 242, 242, 242),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.search,
                size: 20,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                keyboardType: TextInputType.text,
                controller: _textEditController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_submitted) {
                  _startSearch = true;
                  _contentFocusNode.unfocus();
                  _presenter.getInviteList(
                      UserManager.instance.user.info.id, 0, _submitted);
                  setState(() {});
                },
                focusNode: _contentFocusNode,
                onChanged: (text) {
                  _startSearch = false;
                  _searchText = text;
                  _controller.replaceData([]);
                  setState(() {});
                },
                placeholder: "请输入昵称/备注/手机号",
                placeholderStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xff999999),
                ),
                decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
                style: TextStyle(
                    color: Colors.black,
                    textBaseline: TextBaseline.ideographic),
              ),
            )
          ],
        ));
  }

  @override
  failure(String msg) {
    GSDialog.of(context).showError(globalContext, msg);
  }

  @override
  MvpListViewPresenterI<InviteModel, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }

  @override
  refreshSuccess(List<InviteModel> data) {
    super.refreshSuccess(data);
    if (data != null && data.length > 0) {
      if (_searchHistory.contains(_searchText)) {
        _searchHistory.remove(_searchText);
        List<String> list = [_searchText];
        list.addAll(_searchHistory);
        _searchHistory = list;
      } else {
        List<String> list = [_searchText];
        list.addAll(_searchHistory);
        _searchHistory = list;
        while (_searchHistory.length > 15) {
          _searchHistory.removeLast();
        }
      }
      saveSearchListToSharedPreferences(_searchHistory);
      setState(() {});
    }
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  bool get wantKeepAlive => true;

  _searchHistoryWidget() {
    List<Widget> choiceChipList = [];
    if (_searchHistory != null && _searchHistory.length > 0) {
      for (var text in _searchHistory) {
        choiceChipList.add(Padding(
          padding: EdgeInsets.only(right: 10, bottom: 5),
          child: ChoiceChip(
            backgroundColor: Colors.white,
            // disabledColor: Colors.blue,
            labelStyle: TextStyle(fontSize: 15 * 2.sp, color: Colors.black),
            labelPadding: EdgeInsets.only(left: 20, right: 20),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onSelected: (bool value) {
              _startSearch = true;
              _textEditController.text = text;
              _searchText = text;
              setState(() {});
              _presenter.getInviteList(
                  UserManager.instance.user.info.id, 0, text);
            },
            label: Text(text),
            selected: false,
          ),
        ));
      }
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      '历史搜索',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    (_searchHistory != null && _searchHistory.length > 0)
                        ? FlatButton(
                            onPressed: () {
                              _searchHistory = [];
                              saveSearchListToSharedPreferences(_searchHistory);
                              setState(() {});
                            },
                            child: Text(
                              "清除",
                              style: TextStyle(
                                  color: Color(0xff666666), fontSize: 12),
                            ))
                        : Container(),
                  ],
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Wrap(
              children: choiceChipList,
            ),
          ),
          // Spacer()
        ],
      ),
    );
  }

  getSearchListFromSharedPreferences() async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    if (UserManager.instance.haveLogin) {
      _searchHistory = prefs.getStringList(
          UserManager.instance.user.info.id.toString() +
              "userInviteSearhHistory");
      if (_searchHistory == null) {
        _searchHistory = [];
      }
      setState(() {});
    }
  }

  saveSearchListToSharedPreferences(List<String> value) async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        UserManager.instance.user.info.id.toString() + "userInviteSearhHistory",
        value);
  }
}
