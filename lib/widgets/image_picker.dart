// /*
//  * ====================================================
//  * package   :
//  * author    : Created by nansi.
//  * time      : 2019-08-27  16:21
//  * remark    :
//  * ====================================================
//  */
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart' as flutterImgPicker;
// import 'package:image_picker/image_picker.dart';
// import 'package:recook/models/media_model.dart';
// import 'package:recook/utils/image_utils.dart';
// import 'package:recook/widgets/no_data_view.dart';
// import 'package:photo/photo.dart';
// import 'package:photo_manager/photo_manager.dart';
//
// class ImagePick implements LoadingDelegate {
//   int rowCount;
//   int maxSelected;
//   double padding;
//   double itemRadio;
//   Color themeColor;
//   Color dividerColor;
//   Color textColor;
//   Color disableColor;
//   int thumbSize;
//   I18nProvider provider;
//   SortDelegate sortDelegate;
//   CheckBoxBuilderDelegate checkBoxBuilderDelegate;
//   LoadingDelegate loadingDelegate;
//   PickType pickType;
//   BadgeDelegate badgeDelegate;
//   List<AssetPathEntity> photoPathList;
//
//   ImagePick(
//       {this.rowCount,
//       this.maxSelected,
//       this.padding,
//       this.itemRadio,
//       this.themeColor,
//       this.dividerColor,
//       this.textColor,
//       this.disableColor,
//       this.thumbSize,
//       this.provider,
//       this.sortDelegate,
//       this.checkBoxBuilderDelegate,
//       this.loadingDelegate,
//       this.pickType = PickType.all,
//       this.badgeDelegate = const DefaultBadgeDelegate(),
//       this.photoPathList});
//
//   static ImagePick builder({
//     int rowCount = 4,
//     int maxSelected = 9,
//     double padding = 0,
//     double itemRadio = 1.0,
//     Color themeColor = Colors.red,
//     Color dividerColor = Colors.white,
//     Color textColor = Colors.white,
//     Color disableColor,
//     int thumbSize = 100,
//     I18nProvider provider = I18nProvider.chinese,
//     SortDelegate sortDelegate,
//     LoadingDelegate loadingDelegate,
//     PickType pickType = PickType.all,
//     BadgeDelegate badgeDelegate = const DefaultBadgeDelegate(),
//     List<AssetPathEntity> photoPathList,
//   }) {
//     ImagePick picker = ImagePick(
//       rowCount: rowCount,
//       maxSelected: maxSelected,
//       padding: padding = 3,
//       itemRadio: itemRadio,
//       themeColor: themeColor,
//       dividerColor: dividerColor,
//       textColor: textColor,
//       disableColor: disableColor,
//       thumbSize: thumbSize,
//       provider: provider,
//       sortDelegate: sortDelegate,
//       checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
//         activeColor: Colors.white,
//         unselectedColor: Colors.white,
//         checkColor: Colors.blue,
//       ),
//       loadingDelegate: loadingDelegate,
//       pickType: pickType,
//       badgeDelegate: badgeDelegate,
//       photoPathList: photoPathList,
//     );
//
//     return picker;
//   }
//
//   Future<MediaModel> pickImage({@required flutterImgPicker.ImageSource source,
//       bool cropImage:false,
//       double maxWidth,
//       double maxHeight,
//       int imageQuality,
//       }) async {
//     final picker = ImagePicker();
//
//     var imagePath = await picker.getImage(source: source, maxWidth: maxWidth, maxHeight: maxHeight, imageQuality: imageQuality);
//
//       File imageFile =File(imagePath.path);
//       if (imageFile == null) {
//         return null;
//       }
//       if (cropImage) {
//         File cropFile = await ImageUtils.cropImage(imageFile);
//         if (cropFile == null) {
//           return null;
//         }
//         imageFile = cropFile;
//       }
//       // var size = await _calculateImageDimension(imageFile);
//       // double width = size.width;
//       // double height = size.height;
//       MediaModel mediaModel = MediaModel();
//       mediaModel.file = imageFile;
//       mediaModel.thumbData = await imageFile.readAsBytes();
//       var decodedImage = await decodeImageFromList(mediaModel.thumbData);
//       mediaModel.width = decodedImage.height.toInt();
//       mediaModel.height = decodedImage.width.toInt();
//       mediaModel.type = MediaType.image;
//       return mediaModel;
//   }
//
//   // Future<Size> _calculateImageDimension(file) {
//   //   Completer<Size> completer = Completer();
//   //   Image image = Image.file(file);
//   //   image.image.resolve(ImageConfiguration()).addListener(
//   //     ImageStreamListener(
//   //       (ImageInfo image, bool synchronousCall) {
//   //         var myImage = image.image;
//   //         Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
//   //         completer.complete(size);
//   //       },
//   //     ),
//   //   );
//   //   return completer.future;
//   // }
//
//   Future<List<MediaModel>> pickAsset(BuildContext context) async {
//     List<MediaModel> medias = [];
//     List<AssetEntity> entities = await PhotoPicker.pickAsset(
//         context: context,
//         /// The following are optional parameters.
//         themeColor: themeColor,
//         // the title color and bottom color
//         padding: padding,
//         // item padding
//         dividerColor: dividerColor,
//         // divider color
//         disableColor: disableColor??= Colors.grey.shade300,
//         // the check box disable color
//         itemRadio: itemRadio,
//         // the content item radio
//         maxSelected: maxSelected,
//         // max picker image count
//         provider: provider,
//         // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
//         rowCount: rowCount,
//         // item row count
//         textColor: textColor,
//         // text color
//         thumbSize: thumbSize,
//         // preview thumb size , default is 64
//         sortDelegate: sortDelegate,
//         // default is common ,or you make custom delegate to sort your gallery
//         checkBoxBuilderDelegate: checkBoxBuilderDelegate,
//         // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox
//
//         loadingDelegate: null,
//         // if you want to build custom loading widget,extends LoadingDelegate [see example/lib/main.dart]
//
//         badgeDelegate: badgeDelegate,
//         pickType: pickType,
//         // all/image/video
//         photoPathList: photoPathList
// //      List<AssetPathEntity> photoPathList, /// when [photoPathList] is not null , [pickType] invalid .
//         );
//
//     for (AssetEntity entity in entities) {
//         MediaModel mediaModel = MediaModel();
//         mediaModel.file = await entity.file;
//         mediaModel.width =  entity.size.width.toInt();
//         mediaModel.height =  entity.size.height.toInt();
//         mediaModel.thumbData = await entity.thumbData;
//         mediaModel.type = entity.type == AssetType.video ? MediaType.video : MediaType.image;
//         medias.add(mediaModel);
//     }
//     return medias;
//   }
//
//   @override
//   Widget buildBigImageLoading(BuildContext context, AssetEntity entity, Color themeColor) {
//     return NoDataView();
//   }
//
//   @override
//   Widget buildPreviewLoading(BuildContext context, AssetEntity entity, Color themeColor) {
//     return NoDataView();
//   }
// }
