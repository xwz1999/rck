import 'package:flutter/material.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UpgradeUsedView extends StatefulWidget {
  UpgradeUsedView({Key key}) : super(key: key);

  @override
  _UpgradeUsedViewState createState() => _UpgradeUsedViewState();
}

class _UpgradeUsedViewState extends State<UpgradeUsedView> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _refreshController.refreshCompleted();
      },
      body: ListView(),
    );
  }
}
