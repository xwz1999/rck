import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';

class RecookListTile extends StatelessWidget {
  ///prefix widget
  final Widget prefix;

  ///suffix widget
  final Widget suffix;

  ///title
  final dynamic title;

  ///title color
  final Color titleColor;

  /// show underline
  final bool underline;

  ///show forward arrow
  final bool arrow;

  /// on tap
  final VoidCallback onTap;
  const RecookListTile({
    Key key,
    this.prefix,
    this.suffix,
    @required this.title,
    this.underline = true,
    this.arrow = true,
    this.titleColor = const Color(0xFF333333),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: underline
              ? Border(
                  bottom: BorderSide(
                    color: Color(0xFFD6D6D6),
                    width: rSize(0.5),
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            rHBox(55),
            prefix ?? SizedBox(),
            prefix != null ? rWBox(8) : SizedBox(),
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: rSP(14),
                  color: titleColor,
                ),
                child: title is String
                    ? Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      )
                    : title,
              ),
            ),
            suffix != null ? rWBox(8) : SizedBox(),
            suffix ?? SizedBox(),
            arrow ? rWBox(8) : SizedBox(),
            arrow
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: rSize(12),
                    color: Color(0xFF333333),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
