
import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';

typedef RefreshCallback = Function();
typedef LoadMoreCallback = Function(int page);
typedef ItemClickListener = Function(int index);
typedef GridViewBuilder = Widget Function();

// class SwipeItem extends SlideAction {
//   SwipeItem({
//     Key key,
//     @required Widget child,
//     VoidCallback onTap,
//     Color color,
//     Decoration decoration,
//     bool closeOnTap = true,
//   }) : super(
//           key: key,
//           child: child,
//           color: color,
//           decoration: decoration,
//           onTap: onTap,
//         );
// }
//
// class SwipeIconItem extends IconSlideAction {
//   SwipeIconItem({
//     Key key,
//     icon,
//     iconWidget,
//     caption,
//     Color color,
//     foregroundColor,
//     VoidCallback onTap,
//     bool closeOnTap = true,
//   }) : super(
//           icon: icon,
//           iconWidget: iconWidget,
//           caption: caption,
//           color: color,
//           foregroundColor: foregroundColor,
//           onTap: onTap,
//         );
// }

abstract class MvpListViewDelegate<T> {
  MvpListViewPresenterI<T, MvpView, MvpModel>? getPresenter();

  refreshSuccess(List<T> data) {}

  refreshFailure(String? error) {}

  loadMoreSuccess(List<T>? data) {}

  loadMoreWithNoMoreData() {}

  loadMoreFailure({String? error}) {}
}

enum ListViewType { grid, list }

class MvpListView<T> extends StatefulWidget {
  final bool autoRefresh;
  final RefreshCallback? refreshCallback;
  final LoadMoreCallback? loadMoreCallback;
  final MvpListViewDelegate<T> delegate;
  final IndexedWidgetBuilder? itemBuilder;
  final Widget? noDataView;
  final MvpListViewController? controller;
  final ItemClickListener? itemClickListener;
  final ListViewType type;
  final GridViewBuilder? gridViewBuilder;
  final EdgeInsetsGeometry padding;
  final int pageSize;
  final List<Widget> Function(int index)? swipeLeadingItems;
  final List<Widget> Function(int index)? swipeTrailingItems;
  final double swipeItemWidthRatio;
  // final SlidableController slidableController;
  const MvpListView(
      {required this.delegate,
      this.itemBuilder,
      this.refreshCallback,
      this.loadMoreCallback,
      this.autoRefresh = true,
      this.noDataView,
      this.controller,
      this.itemClickListener,
      this.gridViewBuilder,
      this.type = ListViewType.list,
      this.padding = const EdgeInsets.all(0),
      this.pageSize = 15,
      this.swipeLeadingItems,
      this.swipeTrailingItems,
      this.swipeItemWidthRatio = 0.2,
      //this.slidableController
      });

  @override
  State<StatefulWidget> createState() {
    return _MvpListViewState<T>();
  }
}

class _MvpListViewState<T> extends State<MvpListView>
    implements MvpRefreshViewI<T> {
  MvpListViewController<T>? _mvpController;
  // SlidableController _slidableController;

  int _page = 0;
  BuildContext? _context;

  @override
  void initState() {
    // if (widget.slidableController == null) {
    //   _slidableController = SlidableController();
    // } else {
    //   _slidableController = widget.slidableController;
    // }

    GSRefreshController gsRefreshController =
        GSRefreshController(initialRefresh: widget.autoRefresh);

    if (widget.controller == null) {
      _mvpController =
          MvpListViewController(controller: gsRefreshController, data: []);
    } else {
      _mvpController = widget.controller as MvpListViewController<T>?;
      if (_mvpController!.refreshController == null) {
        _mvpController!.refreshController = gsRefreshController;
      }
    }

    _mvpController!.operation.addListener(handleStateChanged);

    widget.delegate.getPresenter()?.attachRefreshView(this);
    super.initState();
  }

  handleStateChanged() {
    if (_mvpController!.operationValue != Operation.none) {
      _mvpController!.operation.removeListener(handleStateChanged);
      _mvpController!.operation.value = Operation.none;
      _mvpController!.operation.addListener(handleStateChanged);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Padding(
      padding: widget.padding,
      child: RefreshWidget(
        controller: _mvpController!.refreshController,
        onRefresh: widget.refreshCallback,
        onLoadMore: widget.loadMoreCallback == null ||
                _mvpController!.getData().length < widget.pageSize
            ? null
            : () {
                _page++;
                widget.loadMoreCallback!(_page);
              },
        body: _mvpController!.getData().length == 0 && widget.noDataView != null
            ? widget.noDataView
            : widget.type == ListViewType.list
                ? _buildListView()
                : _gridView(),
      ),
    );
  }

  ListView _buildListView() {
    assert(widget.itemBuilder != null);
    return ListView.builder(
//        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _mvpController!.getData().length,
        itemBuilder: (_, index) {
          if (widget.itemClickListener == null) {
            return  widget.itemBuilder!(context, index);
              //_listItem(_, index);
          }
          return CustomImageButton(
            padding: EdgeInsets.zero,
//            child: widget.itemBuilder(_, index),
            child:widget.itemBuilder!(context, index),
            //_listItem(_, index),
            onPressed: () {
              widget.itemClickListener!(index);
            },
          );
        });
  }

  _gridView() {
    assert(widget.gridViewBuilder != null, "需要您自己设置 gridview");
    return widget.gridViewBuilder!();
  }

  // final SlidableController slidableController = SlidableController();
  // _listItem(BuildContext context, int index) {
  //   Slidable.of(context)?.open();
  //   return Slidable(
  //     closeOnScroll: false,
  //     controller: _slidableController,
  //     actionExtentRatio: widget.swipeItemWidthRatio,
  //     child: widget.itemBuilder(context, index),
  //     actionPane: SlidableDrawerActionPane(),
  //     actions: widget.swipeLeadingItems == null
  //         ? null
  //         : widget.swipeLeadingItems(index),
  //     secondaryActions: widget.swipeTrailingItems == null
  //         ? null
  //         : widget.swipeTrailingItems(index),
  //   );
  // }

  @override
  loadMoreFailure({String? error}) {
    _page--;
    _mvpController!.refreshController!.loadFailed();
    return null;
  }

  @override
  loadMoreSuccess(List<T>? data) {
    _mvpController!.refreshController!.loadComplete();
    if (data!.length == 0) {
      loadMoreWithNoMoreData();
      return;
    }
    _mvpController!.getData().addAll(data);
    // _mvpController.addAll(data);
    DPrint.printf("总长度----${_mvpController!.getData().length}");
    widget.delegate.loadMoreSuccess(data);
    setState(() {});
  }

  @override
  loadMoreWithNoMoreData() {
    _page--;
    _mvpController!.refreshController!.loadNoData();
    widget.delegate.loadMoreWithNoMoreData();
  }

  @override
  refreshFailure(String? error) {
    _mvpController!.refreshController!.refreshFailed();
    widget.delegate.refreshFailure(error);
  }

  @override
  refreshSuccess(data) {
    _page = 0;
    _mvpController!.refreshController!.refreshCompleted(resetFooterState: true);
    _mvpController!.replaceData(data);
    widget.delegate.refreshSuccess(data);
    setState(() {});
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  @mustCallSuper
  void dispose() {
    widget.delegate.getPresenter()?.detach();
    _mvpController!.refreshController?.dispose();
    super.dispose();
  }

  @override
  failure(String? msg) {
    if (_context == null) return;
//    GSDialog.of(context).showError(_context, msg);
    Toast.showInfo(msg);
  }
}

// 扩展动画删除等操作时会用到
enum Operation { none, add, delete }

class MvpListViewController<T> {
  GSRefreshController? refreshController;
  List<T> _data;
  ValueNotifier<Operation> operation = ValueNotifier(Operation.none);

  get operationValue => operation.value;

  MvpListViewController({GSRefreshController? controller, List<T>? data})
      : _data = data ?? [],
        refreshController = controller;

  setController(GSRefreshController controller) {
    refreshController = controller;
  }

  stopRefresh() {
    assert(refreshController != null, "清先设置controller");
    refreshController!.refreshCompleted();
  }

  requestRefresh() {
    assert(refreshController != null, "清先设置controller");
    refreshController!.requestRefresh();
  }

  List<T> getData() {
    return _data;
  }

  replaceData(List<T> data) {
    _data = data;
    operation.value = Operation.add;
  }

  addItem(T item) {
    _data.add(item);
    operation.value = Operation.add;
  }

  addAll(List<T> items) {
    _data.addAll(items);
    operation.value = Operation.add;
  }

  insertItem(int index, T item) {
    assert(item != null);
    _data.insert(index, item);
    operation.value = Operation.add;
  }

  deleteItem(T data) {
    _data.remove(data);
    operation.value = Operation.delete;
  }
}
