import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class MorePeople extends StatefulWidget {
  final List<String> images;
  MorePeople({Key key, this.images}) : super(key: key);

  @override
  _MorePeopleState createState() => _MorePeopleState();
}

class _MorePeopleState extends State<MorePeople> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        _buildMore(),
        _buildAvatar(1),
        _buildAvatar(2),
        _buildAvatar(3),
      ],
    );
  }

  _buildMore() {
    return Container(
      height: rSize(28),
      width: rSize(28),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(rSize(14)),
      ),
    );
  }

  _buildAvatar(int index) {
    return Positioned(
      right: rSize(28 * index - 5.0 * index),
      child: CircleAvatar(
        radius: rSize(14),
        backgroundColor: Color.fromRGBO(
          Random().nextInt(100),
          Random().nextInt(100),
          Random().nextInt(100),
          1,
        ),
      ),
    );
  }
}
