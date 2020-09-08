/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-05  10:48 
 * remark    : 
 * ====================================================
 */

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class CustomCacheImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final String placeholder;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final VoidCallback imageClick;
  final bool calculateHeight;

  const CustomCacheImage({
    Key key,
    this.imageUrl,
    this.width,
    this.height,
    this.placeholder,
    this.fit,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.imageClick,
    this.calculateHeight = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomCacheImageState();
  }
}

class _CustomCacheImageState extends State<CustomCacheImage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  String _placeHolder;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        lowerBound: 0.0,
        upperBound: 1.0);

    if (widget.placeholder != null) {
      _placeHolder = widget.placeholder;
    } else {
      if (widget.width != null && widget.height != null) {
        if (widget.width > widget.height) {
          _placeHolder = AppImageName.placeholder_2x1;
        } else if (widget.width == widget.height) {
          _placeHolder = AppImageName.placeholder_1x1;
        } else {
          _placeHolder = AppImageName.placeholder_1x2;
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//  print(widget.imageUrl);
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: ExtendedImage.network(
        widget.imageUrl,
        width: widget.width,
        height: widget.width,
        fit: BoxFit.fill,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              _controller.reset();
              return _placeHolder == null
                  ? null
                  : Image.asset(
                      _placeHolder,
                      fit: BoxFit.fill,
                    );
              break;
            case LoadState.completed:
              _controller.forward();
              if (widget.imageClick != null) {
                return GestureDetector(
                    onTap: () {
                      widget.imageClick();
                    },
                    child: FadeTransition(
                      opacity: _controller,
                      child: ExtendedRawImage(
                        image: state.extendedImageInfo?.image,
                        width: widget.width,
                        height: widget.height,
                        fit: widget.fit,
                      ),
                    ));
              } else {
                return FadeTransition(
                  opacity: _controller,
                  child: ExtendedRawImage(
                    image: state.extendedImageInfo?.image,
                    width: widget.width,
                    height: widget.height,
                    fit: widget.fit,
                  ),
                );
              }
              //
              break;
            case LoadState.failed:
              _controller.reset();
              return GestureDetector(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                    ),
                    Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  state.reLoadImage();
                },
              );
              break;
          }
          return null;
        },
        //cancelToken: cancellationToken,
      ),
    );
  }
}
