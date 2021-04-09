/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-28  17:20 
 * remark    : 
 * ====================================================
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/utils/print_util.dart';

class ImageUtils {
  static Future<File> cropImage(file) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      androidUiSettings: AndroidUiSettings(toolbarTitle: "裁剪",toolbarColor: Colors.blue, toolbarWidgetColor: Colors.white ),
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    return croppedFile;
  }

  /// 返回bytes数组
  static Future<List<int>> compressImageWithBytes(String filePath,
      {int minWidth = 750,
      int minHeight = 1000,
      int quality = 50,
      int rotate = 0,
      bool autoCorrectionAngle = true,
      CompressFormat format = CompressFormat.jpeg,
      bool keepExif = false}) async {
    var result = await FlutterImageCompress.compressWithFile(
      filePath,
      quality: quality,
      minHeight: minHeight,
      minWidth: minWidth,
      rotate: rotate,
      autoCorrectionAngle: autoCorrectionAngle,
      format: format,
      keepExif: keepExif,
    );
    return result;
  }

  /// From [path] to [targetPath]
  static Future<File> compressAndGetFile(
    String path,
    String targetPath, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
  }) async {
    return await FlutterImageCompress.compressAndGetFile(path, targetPath);
  }

  // static Future<bool> saveNetworkImageToPhoto(String url, {bool useCache: true}) async {
  //   var data = await getNetworkImageData(url, useCache: useCache);
  //   var filePath = await ImagePickerSaver.saveFile(fileData: data);
  //   DPrint.printf(filePath);
  //   return filePath != null && filePath != "";
  // }
  static Future<bool> saveNetworkImagesToPhoto(
    List<String> urls, 
    void Function(int index) callBack,
    void Function(bool success) endBack,
    {bool useCache: true,}) async {
      //
      if (Platform.isAndroid) {
        PermissionStatus permissionStorage =
            await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
        if (permissionStorage != PermissionStatus.granted) {
          Map<PermissionGroup, PermissionStatus> permissionStatus =
              await PermissionHandler().requestPermissions([PermissionGroup.storage]);
          permissionStorage = permissionStatus[PermissionGroup.storage] ?? PermissionStatus.unknown;

          if (permissionStorage != PermissionStatus.granted) {
            print("❌----------has no Permission");
            return false;
          }
        }
      }
      //

    for (var i = 0; i < urls.length; i++) {
      String url = urls[i];
      var data = await getNetworkImageData(url, useCache: useCache);
      try {
        final result = await ImageGallerySaver.saveImage(data);
        if (Platform.isAndroid) {
          if (!TextUtils.isEmpty(result)){
            callBack(i);
          }else{
            endBack(false);
            return false;
          }
        }else if (Platform.isIOS){
          if (result) {
            callBack(i);
          }else{
            endBack(false);
            return false;
          }
        }
      } catch (e) {
        if (e is ArgumentError) {
          if (Platform.isIOS) {
            callBack(i);
            continue;
          }
        }
        DPrint.printf(e);
        endBack(false);
        return false;
      }
    }
    endBack(true);
    return true;
  }
  static Future<bool> saveImage(
    List<Uint8List> fileDatas, 
    void Function(int index) callBack,
    void Function(bool success) endBack) async {
      //
      if (Platform.isAndroid) {
        PermissionStatus permissionStorage =
            await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
        if (permissionStorage != PermissionStatus.granted) {
          Map<PermissionGroup, PermissionStatus> permissionStatus =
              await PermissionHandler().requestPermissions([PermissionGroup.storage]);
          permissionStorage = permissionStatus[PermissionGroup.storage] ?? PermissionStatus.unknown;

          if (permissionStorage != PermissionStatus.granted) {
            print("❌----------has no Permission");
            return false;
          }
        }
      }
      //
      for (var i = 0; i < fileDatas.length; i++) {
        Uint8List data = fileDatas[i];
        try {
          final result = await ImageGallerySaver.saveImage(data);
          if (Platform.isAndroid) {
            if (!TextUtils.isEmpty(result)){
              callBack(i);
            }else{
              endBack(false);
              return false;
            }
          }else if (Platform.isIOS){
            if (result) {
              callBack(i);
            }else{
              endBack(false);
              return false;
            }
          }
        } catch (e) {
          if (e is ArgumentError) {
            if (Platform.isIOS) {
              callBack(i);
              if (i == (fileDatas.length-1)) {
                endBack(true);
                return true;
              }
              continue;
            }
          }
          DPrint.printf(e);
          endBack(false);
          return false;
        }
      }
      endBack(true);
      return true;
  }
}


