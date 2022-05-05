import 'package:flutter/material.dart';
import 'package:recook/constants/app_image_resources.dart';

// 升序 降序
enum SortType {SortAscending, SortDescending}

class SortWidget extends StatefulWidget {
  final SortType sortType;
  final Size size;
  final Function(SortType sortType) onChange;
  SortWidget({Key key, this.sortType=SortType.SortDescending, this.size, this.onChange}) : super(key: key);

  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  SortType _sortType;
  Size _size;
  @override
  void initState() { 
    super.initState();
    _sortType = widget.sortType;
    if (widget.size == null) {
      _size = Size(15, 18);
    }else{
      _size = widget.size;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _sortType = _sortType == SortType.SortAscending? SortType.SortDescending: SortType.SortAscending;
        setState(() { });
        if(widget.onChange!=null) widget.onChange(_sortType);
      },
      child: Container(
        color: Colors.white,
        width: _size.width, height: _size.height,
        child: Image.asset(_sortType == SortType.SortDescending? AppImageName.desc_sort: AppImageName.asc_sort, fit: BoxFit.fill,),
      ),
    );
  }
}
