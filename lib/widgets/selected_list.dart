

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

typedef SelectedItemClickListener = Function(int section, int index);
typedef ItemClick = Function(int index);
typedef WidgetBuilder = Function();

class SelectedList<T extends SelectedListItemChildModel>
    extends StatefulWidget {
  final List<SelectedListItemModel<T>>? data;
  final SelectedItemClickListener? listener;
  final WidgetBuilder? bottom;

  const SelectedList({Key? key, this.data, this.listener, this.bottom})
      : super(key: key);

  @override
  _SelectedListState createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        child: ListView.builder(
            itemCount: widget.bottom != null
                ? widget.data!.length + 1
                : widget.data!.length,
            itemBuilder: (context, index) {
              if (index == widget.data!.length) {
                return widget.bottom!();
              }

              return SelectedListItem(
                selectedBorderColor: Color(0xffc92219),
                selectedTextColor: Color(0xffc92219),
                itemModel: widget.data![index],
                itemClick: (int itemIndex) {
                  if (widget.listener != null) {
                    widget.listener!(index, itemIndex);
                  }
                  setState(() {});
                },
              );
            }));
  }
}

class SelectedListItem extends StatefulWidget {
  final Color? selectedBorderColor;
  final Border? radius;
  final Color selectedTextColor;
  final Color bgColor;
  final Color selectedBgColor;
  final SelectedListItemModel? itemModel;
  final ItemClick itemClick;

  const SelectedListItem({
    Key? key,
    this.selectedBorderColor,
    this.radius,
    this.bgColor = AppColor.frenchColor,
    this.selectedBgColor = const Color.fromARGB(255, 255, 249, 249),
    this.itemModel,
    this.selectedTextColor = const Color.fromARGB(255, 248, 57, 12),
    required this.itemClick,
  }) : super(key: key);

  @override
  _SelectedListItemState createState() => _SelectedListItemState();
}

class _SelectedListItemState extends State<SelectedListItem> {
  int? _index;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _index = widget.itemModel!.selectedIndex;
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      widget.itemClick(widget.itemModel!.selectedIndex!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              bottom: 8,
            ),
            child: Text(
              widget.itemModel!.sectionTitle!,
              style: TextStyle(color: Colors.black, fontSize: 14 * 2.sp),
            ),
          ),
          Wrap(
              alignment: WrapAlignment.start,
              spacing: 13,
              runSpacing: 7,
              children: _buildItems()),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 0.3,
            color: Colors.grey[200],
          )
        ],
      ),
    );
  }

  _buildItems() {
    List<Widget> _items = [];

    for (int index = 0; index < widget.itemModel!.items.length; index++) {
      SelectedListItemChildModel item = widget.itemModel!.items[index];
      if (widget.itemModel!.items.length == 1 && _isFirstLoad) {
        _isFirstLoad = false;
        setState(() {
          _index = index;
          widget.itemModel!.selectedIndex = index;
        });
      }
      print(widget.itemModel!.selectedIndex);
      bool selected = index == widget.itemModel!.selectedIndex;
      _items.add(GestureDetector(
        onTap: !item.canSelected
            ? null
            : () {
                setState(() {
                  if (selected) {
                    _index = null;
                    widget.itemModel!.selectedIndex = null;
                  } else {
                    _index = index;
                    widget.itemModel!.selectedIndex = index;
                  }
                });
                widget.itemClick(index);
              },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          constraints: BoxConstraints(
            minWidth: 50,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: selected ? widget.selectedBgColor : widget.bgColor,
              border: Border.all(
                  color: selected
                      ? widget.selectedBorderColor ?? widget.selectedTextColor
                      : widget.bgColor,
                  width: 0.6)),
          child: Opacity(
            opacity: !item.canSelected ? 0.3 : 1,
            child: Text(
              item.itemTitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: selected ? widget.selectedTextColor : Colors.black,
//                  fontWeight: FontWeight.w300,
                  fontSize: 13 * 2.sp),
            ),
          ),
        ),
      ));
    }

    return _items;
  }
}

class SelectedListItemModel<T extends SelectedListItemChildModel> {
  String? sectionTitle;
  List<T> items;
  int? selectedIndex;

  SelectedListItemModel(this.sectionTitle, this.items);
}

/*
  实现淘宝sku 可选不可选
 */
class SelectedListItemChildModel {
  String? itemTitle;
  bool canSelected;
  int? id;

  SelectedListItemChildModel(
      {this.id, this.itemTitle, this.canSelected = true});
}


class GoodsItem{
  int? id;
  String? name;
  String? value;


  GoodsItem(
      {this.id, this.name, this.value});
}
