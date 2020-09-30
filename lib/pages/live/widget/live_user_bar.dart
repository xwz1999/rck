import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class LiveUserBar extends StatefulWidget {
  final bool initAttention;
  final VoidCallback onAttention;
  final String title;
  final String subTitle;
  LiveUserBar({
    Key key,
    @required this.initAttention,
    @required this.onAttention,
    @required this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  _LiveUserBarState createState() => _LiveUserBarState();
}

class _LiveUserBarState extends State<LiveUserBar> {
  bool _internalAttention = false;
  @override
  void initState() {
    super.initState();
    _internalAttention = widget.initAttention;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: rSize(36),
      padding: EdgeInsets.fromLTRB(rSize(2), rSize(2), rSize(5), rSize(2)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rSize(18)),
        color: Colors.black.withOpacity(0.1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: rSize(16),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rSize(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(12),
                  ),
                ),
                widget.subTitle == null
                    ? SizedBox()
                    : Text(
                        widget.subTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(10),
                        ),
                      ),
              ],
            ),
          ),
          _internalAttention
              ? SizedBox()
              : SizedBox(
                  width: rSize(56),
                  height: rSize(26),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(rSize(13)),
                    ),
                    child: Text(
                      '+ 关注',
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: rSP(12),
                        height: 1,
                      ),
                    ),
                    onPressed: () {
                      widget.onAttention();
                      setState(() {
                        _internalAttention = true;
                      });
                    },
                    color: Color(0xFFDB2D2D),
                  ),
                ),
        ],
      ),
    );
  }
}