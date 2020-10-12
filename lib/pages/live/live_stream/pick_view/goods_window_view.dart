import 'package:flutter/material.dart';

class GoodsWindowView extends StatefulWidget {
  GoodsWindowView({Key key}) : super(key: key);

  @override
  _GoodsWindowViewState createState() => _GoodsWindowViewState();
}

class _GoodsWindowViewState extends State<GoodsWindowView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemBuilder: (context, index) {
        return SizedBox();
      },
      itemCount: 10,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
