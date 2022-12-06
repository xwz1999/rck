
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recook/constants/header.dart';

typedef OnRefresh = Function();
typedef OnLoadMore = Function();

class RefreshWidget extends StatefulWidget {
  RefreshWidget(
      {this.body,
      this.onRefresh,
      this.onLoadMore,
      this.isInNest = false,
      GSRefreshController? controller,
      this.enableOverScroll = true,
      this.color = const Color(0xff555555),
      this.refreshingText: "正在努力获取数据...",
      this.completeText: "刷新完成",
      this.failedText: "网络出了一点问题呢",
      this.idleText: "下拉刷新",
      this.upIdleText: "上拉加载更多",
      this.releaseText: "松开刷新",
      this.loadingText: "正在加载中...",
      this.noDataText: "已经到底了",
      this.noPartner: "这是我最后的底线",
      this.headerTriggerDistance,
      this.header,
      GridView? child,
      this.noData})
      : this.controller = controller ?? GSRefreshController();

  final Widget? body;
  final Color color;
  final OnRefresh? onRefresh;
  final OnLoadMore? onLoadMore;
  final bool isInNest;
  final bool enableOverScroll;
  final GSRefreshController controller;

  final double? headerTriggerDistance;
  final String refreshingText;
  final String completeText;
  final String failedText;
  final String idleText;
  final String upIdleText;
  final String releaseText;

  final String loadingText;
  final String noDataText;
  final String noPartner;
  final Widget? header;
  //不为空的时候 nodataText无效
  final String? noData;

  @override
  State<StatefulWidget> createState() {
    return _RefreshWidgetState();
  }
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
     // autoLoad: true,
      hideFooterWhenNotFull: true,
      headerTriggerDistance: widget.headerTriggerDistance ?? rSize(60),
      child: SmartRefresher(
        // enableOverScroll: widget.enableOverScroll,

        enablePullDown: widget.onRefresh != null,
        enablePullUp: widget.onLoadMore != null,
        header: widget.header != null
            ? widget.header
            : ClassicHeader(
                textStyle: TextStyle(fontSize: 14 * 2.sp, color: widget.color),
                idleIcon: Icon(
                  Icons.arrow_downward,
                  size: 20 * 2.sp,
                  color: widget.color,
                ),
                releaseIcon: Icon(
                  Icons.arrow_upward,
                  size: 20 * 2.sp,
                  color: widget.color,
                ),
                // refreshingIcon:CircularProgressIndicator(),
                completeIcon: Icon(
                  Icons.check,
                  size: 20 * 2.sp,
                  color: widget.color,
                ),
                spacing: rSize(5),

                refreshingText: '',//widget.refreshingText,
                completeText: widget.completeText,
                failedText: widget.failedText,
                idleText: widget.idleText,
                releaseText: widget.releaseText,
              ),
        footer: widget.noData == 'part'
            ? ClassicFooter(
                textStyle:
                    TextStyle(fontSize: 14 * 2.sp, color: Color(0xff555555)),
                idleText: widget.upIdleText,
                idleIcon: Icon(
                  Icons.arrow_upward,
                  size: 20 * 2.sp,
                  color: Color(0xff555555),
                ),
                noMoreIcon: Image.asset(
                  ShopImageName.shop_page_smile,
                  width: 22,
                  height: 12,
                ),
                iconPos: widget.noData == 'part'
                    ? IconPosition.top
                    : IconPosition.left,
                loadingText: widget.loadingText,
                failedText: "网络出了一点问题呢",
                noDataText: widget.noData == 'part'
                    ? widget.noPartner
                    : widget.noDataText,
                canLoadingText: '',
              )
            : ClassicFooter(
                textStyle:
                    TextStyle(fontSize: 14 * 2.sp, color: Color(0xff555555)),
                idleText: widget.upIdleText,
                idleIcon: Icon(
                  Icons.arrow_upward,
                  size: 20 * 2.sp,
                  color: Color(0xff555555),
                ),
                loadingText: widget.loadingText,
                failedText: "网络出了一点问题呢",
                noDataText: widget.noDataText,
                canLoadingText: '',
              ),
        controller: widget.controller._controller!,
        onRefresh: () {
          widget.controller.resetNoData();
          widget.onRefresh!();
        },
        onLoading: widget.onLoadMore,
        child: widget.body,
//      isNestWrapped: widget.isInNest,
      ),
    );
  }
}

class GSRefreshController {
  RefreshController? _controller;

  GSRefreshController({
    bool initialRefresh = false,
  }) {
    _controller = RefreshController(initialRefresh: initialRefresh);
  }

  GSRefreshController.auto() {
    _controller = RefreshController(initialRefresh: true);
  }

  void requestRefresh() {
    _controller!.requestRefresh();
  }

  void requestLoadMore() {
    _controller!.requestLoading();
  }

  void refreshCompleted({bool resetFooterState = false}) {
    _controller!.refreshCompleted(resetFooterState: resetFooterState);
  }

  /// request failed,the header display failed state
  void refreshFailed() {
    _controller!.refreshFailed();
  }

  /// not show success or failed, it will set header state to idle and spring back at once
  void refreshToIdle() {
    _controller!.refreshToIdle();
  }

  /// after data returned,set the footer state to idle
  void loadComplete() {
    _controller!.loadComplete();
  }

  /// If catchError happen,you may call loadFailed indicate fetch data from network failed
  void loadFailed() {
    _controller!.loadFailed();
  }

  /// load more success without error,but no data returned
  void loadNoData() {
    _controller!.loadNoData();
  }

  /// reset footer noData state  to idle
  void resetNoData() {
    _controller!.resetNoData();
  }

  bool isRefresh() {
    return _controller!.isRefresh;
  }

  bool isLoading() {
    return _controller!.isLoading;
  }

  bool get isNoData =>
      (_controller?.footerStatus ?? LoadStatus.canLoading) == LoadStatus.noMore;

  void dispose() {
    _controller!.dispose();
  }
}
