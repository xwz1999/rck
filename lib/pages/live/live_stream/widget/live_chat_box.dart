import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';

import 'package:recook/constants/header.dart';

enum ChatType {
  NORMAL,
  ENTER_LIVE,
  BUYING,
}

class LiveChatBox extends StatefulWidget {
  final String sender;
  final String note;
  final bool userEnter;
  final ChatType type;
  const LiveChatBox({
    Key key,
    this.sender,
    this.note,
    this.userEnter = false,
    this.type = ChatType.NORMAL,
  }) : super(key: key);

  @override
  _LiveChatBoxState createState() => _LiveChatBoxState();
}

class _LiveChatBoxState extends State<LiveChatBox> {
  @override
  Widget build(BuildContext context) {
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
                  text:
                      '${widget.sender}${TextUtil.isEmpty(widget.sender) ? '' : ':'}',
                  style: TextStyle(
                    color: Color(0xFF98EDFF),
                    fontSize: rSP(13),
                  ),
                ),
                TextSpan(
                  text: widget.note,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(13),
                    fontWeight: FontWeight.bold,
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
            color: widget.userEnter ?? false
                ? Colors.pink.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
