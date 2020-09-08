import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareImageTool{

  static Future<ui.Image> getImageWithQRCode({String qrCode, double size}) async { 
    final image = await QrPainter(
      data: qrCode, 
      version: QrVersions.auto,
      gapless: false
    ).toImage(size);
    final a = await image.toByteData(format: ui.ImageByteFormat.png);
    var codec = await ui.instantiateImageCodec(a.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  static Future<ui.Image> getImageWithAsset(String asset) async {
    ByteData data = await rootBundle.load(asset);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  static Future<ui.Image> getImageWithNetwork(String imageUrl){
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    ImageProvider provider = ExtendedImage.network(imageUrl).image;
    ImageStream stream = provider.resolve(ImageConfiguration.empty);
    ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo frame, bool syncBool){
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }
  
}