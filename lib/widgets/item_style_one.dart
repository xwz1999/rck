import 'package:flutter/material.dart';

import 'package:recook/constants/app_image_resources.dart';

class ItemStyleOne extends StatefulWidget {
  final String title;

  const ItemStyleOne({Key key, this.title}) : super(key: key);
  // Color _titleColor;
   //String _subTitle;
  // Color _backColor;
  // EdgeInsets _padding;


  @override
  _ItemStyleOneState createState() => _ItemStyleOneState();

  // updateSubTitle(String subTitle) {
  //   _subTitle = subTitle;
  // }
}

class _ItemStyleOneState extends State<ItemStyleOne> {
  Color _backColor = Colors.white;
  // Color _titleColor = Colors.greenAccent;
      EdgeInsets _padding =
  const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8);
  @override
  Widget build(BuildContext context) {
    // Widget current = Text(
    //   widget._title,
    //   style: TextStyle(color: widget._titleColor, fontSize: 16),
    //   maxLines: 1,
    // );
    // current = Row(crossAxisAlignment: CrossAxisAlignment.center,);
    return Container(
      color: _backColor,
      child: Padding(
        padding: _padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Icon(
                  AppIcons.icon_next,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
              width: 24,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
