import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/constants.dart';

class RecookCheckBox extends StatelessWidget {
  final bool state;
  const RecookCheckBox({Key key, this.state = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: rSize(16),
      width: rSize(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          rSize(8),
        ),
        border: state
            ? null
            : Border.all(
                width: rSize(1),
                color: Color(0xFFC9C9C9),
              ),
        color: state ? Color(0xFFDB2D2D) : Colors.transparent,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: rSize(12),
      ),
    );
  }
}
