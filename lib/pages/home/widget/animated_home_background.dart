import 'package:flutter/material.dart';
import 'package:recook/constants/styles.dart';

class AnimatedHomeBackground extends StatefulWidget {
  final double? height;
  final Color? backgroundColor;
  AnimatedHomeBackground({Key? key, this.height, this.backgroundColor})
      : super(key: key);

  @override
  AnimatedHomeBackgroundState createState() => AnimatedHomeBackgroundState();
}

class AnimatedHomeBackgroundState extends State<AnimatedHomeBackground> {
  Color? displayColor;
  @override
  void initState() {
    super.initState();
    displayColor = widget.backgroundColor;
  }

  changeColor(Color color) {
    setState(() {
      displayColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: widget.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            displayColor!,
            displayColor!,
            AppColor.frenchColor,
          ],
        ),
      ),
    );
  }
}
