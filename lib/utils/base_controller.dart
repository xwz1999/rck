import 'package:flutter/material.dart';

class BaseController {
  List<ValueNotifier> _cacheList = List();

  addValueNotifier(ValueNotifier notify) {
    _cacheList.add(notify);
  }

  void dispose() {
    _cacheList.forEach((e) => e?.dispose());
  }
}
