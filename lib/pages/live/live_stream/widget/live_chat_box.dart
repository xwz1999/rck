import 'dart:math';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class LiveChatBox extends StatelessWidget {
  final String sender;
  final String note;
  final bool userEnter;
  const LiveChatBox({Key key, this.sender, this.note, this.userEnter = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Color.fromRGBO(
      180 + Random().nextInt(55),
      180 + Random().nextInt(55),
      180 + Random().nextInt(55),
      1,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: rSize(5 / 2)),
      alignment: Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(rSize(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '$sender${TextUtil.isEmpty(sender) ? '' :':'}',
                  style: TextStyle(
                    color: color,
                    fontSize: rSP(13),
                  ),
                ),
                TextSpan(
                  text: note,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(13),
                  ),
                ),
              ]),
              maxLines: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: rSize(10),
              vertical: rSize(4),
            ),
            constraints: BoxConstraints(
              maxWidth: rSize(200),
            ),
            color: userEnter ?? false
                ? Colors.pink.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
