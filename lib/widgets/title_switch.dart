import 'package:flutter/material.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/widgets/custom_image_button.dart';

class TitleSwitchController {
  Function(int index) changeIndex;
}

class TitleSwitch extends StatefulWidget {
  /// Whether this switch is on or off.
  ///
  /// Must not be null.
  final int index;
  final double height;
  final double width;
  final List<String> titles;
  final TextStyle normalStyle;
  final TextStyle selectedStyle;
  final Widget backgroundWidget;
  final Function(int) selectIndexBlock;
  final TitleSwitchController controller;
  const TitleSwitch({
    Key key,
    @required this.index, 
    this.height=30, 
    this.width=170, 
    this.titles, 
    this.normalStyle, 
    this.selectedStyle, 
    this.backgroundWidget, 
    this.selectIndexBlock, 
    this.controller
    }) : super(key: key);

  @override
  _TitleSwitchState createState() => _TitleSwitchState();
}

class _TitleSwitchState extends State<TitleSwitch> {
  int _index = 0;
  @override
  void initState() {
    _index = widget.index;
    widget.controller?.changeIndex = (idx){
      _index = idx;
      if (mounted) setState(() {});
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0, right: 0, bottom: 0, top: 0,
            child: widget.backgroundWidget??Container(),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0, top: 0,
            child: Container(
              child: _titlesWidget(),
            ),
          ),
        ],
      ),
    );
  }

  _titlesWidget(){
    List<Widget> list = <Widget>[];
    for (String title in widget.titles) {
      bool selected = widget.titles.indexOf(title) == _index;
      list.add(
        CustomImageButton(
          width: widget.width/widget.titles.length,
          height: widget.height,
          backgroundColor: selected?AppColor.themeColor:Colors.white.withAlpha(0),
          color: selected?Colors.white:Colors.black,
          title: title,
          borderRadius: BorderRadius.circular(widget.height/2),
          style: selected?
            widget.selectedStyle??TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.w400 )
            :widget.normalStyle??TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400 ),
          onPressed: (){
            _index = widget.titles.indexOf(title);
            print("index = ${_index.toString()}");
            if (widget.selectIndexBlock!=null) {
              widget.selectIndexBlock(_index);
            }
            setState(() {});
          },
        )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: list
    );
  }

}