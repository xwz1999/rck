import 'package:flutter/widgets.dart';

abstract class BaseAdapter<T> {
  final _listData = [];

  IndexedWidgetBuilder getBuilder() {
    return (context, index) {
      return createItem(context, index);
    };
  }

  Widget createItem(BuildContext context, int index);

  T getItem(int index) {
    return _listData[index];
  }

  void addData(T data) {
    if (data != null) {
      _listData.add(data);
    }
  }

  void replaceData(List<T> datas) {
    _listData.clear();
    if (datas != null) {
      _listData.addAll(datas);
    }
  }

  int itemCount() {
    return _listData.length;
  }
}
