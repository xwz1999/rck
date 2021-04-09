import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

 
typedef AsyncImageWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, String url);
 
typedef AsyncImageFileWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, File file);
 
typedef AsyncImageMemoryWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, Uint8List bytes);
 
enum AspectRatioImageType { NETWORK, FILE, ASSET, MEMORY }
 
///有宽高的Image
class AspectRatioImage extends StatelessWidget {
  final String url;
  final ImageProvider provider;
  final AsyncImageWidgetBuilder<ui.Image> builder;
 
  AspectRatioImage.network(url, {Key key, @required this.builder})
      : provider = NetworkImage(url),
        this.url = url;
 
 
  @override
  Widget build(BuildContext context) {
    final ImageConfiguration config = createLocalImageConfiguration(context);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(config);
    ImageStreamListener listener;
    listener = ImageStreamListener(
          (ImageInfo image, bool sync) {
        completer.complete(image.image);
        stream.removeListener(listener);
      },
      onError: (dynamic exception, StackTrace stackTrace) {
        completer.complete();
        stream.removeListener(listener);
          FlutterError.reportError(FlutterErrorDetails(
            context: ErrorDescription('image failed to precache'),
            library: 'image resource service',
            exception: exception,
            stack: stackTrace,
            silent: true,
          ));
      },
    );
    stream.addListener(listener);
 
    return FutureBuilder(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot, url);
          } else {
            return Container();
          }
        });
  }
}
