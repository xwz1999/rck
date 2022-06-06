import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';

class UserBaseCard extends StatefulWidget {
  final String date;
  final String detailDate;
  final List<Widget> children;
  UserBaseCard({
    Key? key,
    required this.date,
    required this.detailDate,
    required this.children,
  }) : super(key: key);

  @override
  _UserBaseCardState createState() => _UserBaseCardState();
}

class _UserBaseCardState extends State<UserBaseCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(rSize(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: rSize(45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.date,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: rSP(18),
                  ),
                ),
                SizedBox(height: rSize(10)),
                Text(
                  widget.detailDate,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: rSP(14),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
