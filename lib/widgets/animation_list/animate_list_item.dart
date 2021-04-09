/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/24  10:59 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

class AnimateListItem extends StatelessWidget {
  const AnimateListItem(
      {Key key,
        @required this.animation,
        this.onTap,
        @required this.index,
        @required this.item})
      : assert(animation != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final int index;
  final Widget item;

  @override
  Widget build(BuildContext context) {
    print(" === ${animation.value}");
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 50,
            child: item,
          ),
        ),
      ),
    );
  }
}
  
 
