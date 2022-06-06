import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_detail_model.dart'
    show Attributes, Children, Sku;

class LiveSKUWidget extends StatefulWidget {
  final List<Attributes> attributes;
  final List<Sku> skus;
  final Function(List<Children> children) onPick;
  LiveSKUWidget(
      {Key? key,
      required this.attributes,
      required this.skus,
      required this.onPick})
      : super(key: key);

  @override
  _LiveSKUWidgetState createState() => _LiveSKUWidgetState();
}

class _LiveSKUWidgetState extends State<LiveSKUWidget> {
  List<Children> attrs = [];

  @override
  void initState() {
    super.initState();
    attrs = widget.attributes.map((e) => e.children!.first).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.attributes
          .map((attr) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    attr.name!,
                    style: TextStyle(
                      color: Color(0xFF141414),
                      fontSize: rSP(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _AttrPicker(
                    attr: attr,
                    onPick: (Children oldAttr, Children pickedAttr) {
                      int index = attrs
                          .indexWhere((element) => element.id == oldAttr.id);
                      attrs[index] = pickedAttr;
                      widget.onPick(attrs);
                    },
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class _AttrPicker extends StatefulWidget {
  final Attributes attr;
  final Function(Children oldAttr, Children pickedAttr) onPick;
  _AttrPicker({Key? key, required this.attr, required this.onPick})
      : super(key: key);

  @override
  __AttrPickerState createState() => __AttrPickerState();
}

class __AttrPickerState extends State<_AttrPicker> {
  Children? pickedChild;
  @override
  void initState() {
    pickedChild = widget.attr.children!.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.attr.children!
          .map((e) => MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: rSize(5)),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: pickedChild!.id == e.id
                        ? Color(0xFFC92219)
                        : Color(0xFF999999),
                  ),
                  borderRadius: BorderRadius.circular(rSize(2)),
                ),
                minWidth: 0,
                height: rSize(22),
                child: Text(
                  e.value!,
                  style: TextStyle(
                    color: pickedChild!.id == e.id
                        ? Color(0xFFC92219)
                        : Color(0xFF999999),
                  ),
                ),
                onPressed: () {
                  widget.onPick(pickedChild!, e);
                  pickedChild = e;
                  setState(() {});
                },
              ))
          .toList(),
    );
  }
}
