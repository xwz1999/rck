import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'picker_box.dart';

class ListPickBody extends StatefulWidget {
  final List items;
  final String title;
  const ListPickBody({
    key, required this.items,  this.title = '',
  });

  static Future<String?> listPicker(List items,String title) async {
    return await Get.bottomSheet(ListPickBody( items:
      items
    ,title: title,));
  }

  @override
  _ListPickBodyState createState() => _ListPickBodyState();
}

class _ListPickBodyState extends State<ListPickBody> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return PickerBox(
      onPressed: (){
        print(widget.items[index]);
        Get.back(result: widget.items[index]);
      },
      title: widget.title,
      height: 300.rw,
      child: CupertinoPicker(
        onSelectedItemChanged: (int value) {
          print(widget.items[value]);
          index = value;
        },
        itemExtent: 40.rw,
        children: [
            ...widget.items.map((e) => Container(alignment: Alignment.center, child: Text(e))).toList()
        ],
      ),
    );
  }
}
