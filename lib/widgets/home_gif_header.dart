

import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;


class HomeGifHeader extends RefreshIndicator{
  HomeGifHeader(): super(height:ScreenUtil.statusBarHeight + 80.0, refreshStyle: RefreshStyle.Follow);
  @override
  State<StatefulWidget> createState() {
    return _HomeGifHeaderState();
  }
  
}

class _HomeGifHeaderState extends RefreshIndicatorState<HomeGifHeader> with SingleTickerProviderStateMixin{
  GifController _gifController;

  @override
  void initState() {
    _gifController = GifController(vsync: this, value: 1);
    super.initState();
  }
  @override
  void onModeChange(RefreshStatus mode) {
    if (mode == RefreshStatus.refreshing) {
      _gifController.repeat(min: 0, max: 38, period: Duration(milliseconds: 1500));
    }
    super.onModeChange(mode);
  }
  @override
  Future<void> endRefresh() async {
    double value = _gifController.value;
    if (value < 38) {
      await Future.delayed(Duration(milliseconds: ((39-value)/39*1500).toInt()-100), () {
        _gifController.value = 38;
        // _gifController.stop();
      });
      return super.endRefresh();
    }else{
      return super.endRefresh();
    }
    // _gifController.value = 38;
  }
  @override
  void resetValue() {
    _gifController.value = 0;
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return Container(
      height: ScreenUtil.statusBarHeight+80,
      width: 80,
      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
      child: GifImage(
        image: AssetImage('assets/HomeRefreshHeader3.gif'),
        controller: _gifController,
        height: 80,
        width: 80,
        fit: BoxFit.fitHeight,
      ),
    );
  }
  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }
}
