import 'package:flutter/material.dart';
import 'package:recook/constants/app_image_resources.dart';

class ItemStyleOne extends StatefulWidget {
  String _title;
  Color _titleColor;
  String _subTitle;
  Color _backColor;
  EdgeInsets _padding;

  ItemStyleOne(this._title,
      {String subTitle,
      Color backColor = Colors.white,
      EdgeInsets padding =
          const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8)}) {
    this._backColor = backColor;
    this._subTitle = subTitle;
    this._padding = padding;
    this._titleColor = Colors.greenAccent;
  }

  @override
  _ItemStyleOneState createState() => _ItemStyleOneState();

  updateSubTitle(String subTitle) {
    _subTitle = subTitle;
  }
}

class _ItemStyleOneState extends State<ItemStyleOne> {
  @override
  Widget build(BuildContext context) {
    Widget current = Text(
      widget._title,
      style: TextStyle(color: widget._titleColor, fontSize: 16),
      maxLines: 1,
    );
    current = Row(crossAxisAlignment: CrossAxisAlignment.center,);
    return Container(
      color: widget._backColor,
      child: Padding(
        padding: widget._padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                widget._title,
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
