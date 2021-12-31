import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';

class MorePeople extends StatefulWidget {
  final List<String> images;
  final VoidCallback onTap;
  MorePeople({Key key, this.images, @required this.onTap}) : super(key: key);

  @override
  _MorePeopleState createState() => _MorePeopleState();
}

class _MorePeopleState extends State<MorePeople> {
  int get size => widget.images.length;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          rWBox(28 * 4 - 15.0),
          size >= 4 ? _buildMore() : SizedBox(height: rSize(28)),
          size >= 1 ? _buildAvatar(1) : SizedBox(height: rSize(28)),
          size >= 2 ? _buildAvatar(2) : SizedBox(height: rSize(28)),
          size >= 3 ? _buildAvatar(3) : SizedBox(height: rSize(28)),
        ],
      ),
    );
  }

  _buildMore() {
    return Container(
      height: rSize(28),
      width: rSize(28),
      alignment: Alignment.center,
      child: Text(widget.images.length.toString()),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(rSize(14)),
      ),
    );
  }

  _buildAvatar(int index) {
    return Positioned(
      right: rSize(28 * (size >= 3 ? index : index - 1) - 5.0 * index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(rSize(14)),
        child: FadeInImage.assetNetwork(
          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
          image: Api.getImgUrl(widget.images[index - 1]),
          height: rSize(28),
          width: rSize(28),
        ),
      ),
    );
  }
}
