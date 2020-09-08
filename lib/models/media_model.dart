/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-28  14:09 
 * remark    : 
 * ====================================================
 */

import 'dart:io';

import 'dart:typed_data';

enum MediaType{
  video,
  image
}


class MediaModel {
  int width;
  int height;
  MediaType type;
  File file;
  UploadResult result;
  Uint8List thumbData;

  MediaModel({this.width, this.height, this.type, this.file,this.result, this.thumbData});
}

class UploadResult {
  bool result;
  String msg;
  String url;

  UploadResult(this.result, this.msg, this.url);
}