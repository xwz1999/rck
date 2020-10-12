import 'package:flutter/material.dart';

class BrandGoodsView extends StatefulWidget {
  BrandGoodsView({Key key}) : super(key: key);

  @override
  _BrandGoodsViewState createState() => _BrandGoodsViewState();
}

class _BrandGoodsViewState extends State<BrandGoodsView>
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
