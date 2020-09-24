// import 'package:flutter/material.dart';
// import 'package:recook/const/resource.dart';
// import 'package:recook/constants/constants.dart';
// import 'package:recook/constants/styles.dart';
// import 'package:recook/widgets/recook_back_button.dart';

// class ReviewDetailPage extends StatefulWidget {
//   final int id;
//   ReviewDetailPage({Key key, this.id}) : super(key: key);

//   @override
//   _ReviewDetailPageState createState() => _ReviewDetailPageState();
// }

// class _ReviewDetailPageState extends State<ReviewDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.frenchColor,
//       appBar: AppBar(
//         brightness: Brightness.light,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: RecookBackButton(),
//         centerTitle: true,
//         title: Text(
//           '我的评价',
//           style: TextStyle(
//             color: Color(0xFF333333),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(rSize(15)),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(rSize(8)),
//           ),
//           padding: EdgeInsets.all(rSize(10)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   FadeInImage.assetNetwork(
//                     placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
//                     //TODO
//                     // image: Api.getImgUrl(widget.model.mainPhotoUrl),
//                     height: rSize(56),
//                     width: rSize(56),
//                   ),
//                   SizedBox(width: rSize(10)),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           //todo
//                           // widget.model.goodsName,
//                           '',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           softWrap: false,
//                           style: TextStyle(
//                             color: Color(0xFF333333),
//                             fontWeight: FontWeight.bold,
//                             fontSize: rSP(14),
//                           ),
//                         ),
//                         SizedBox(height: rSize(6)),
//                         Text(
//                           '型号规格 ${widget.model.skuName}',
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontSize: rSP(13),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               TextField(
//                 onChanged: (value) {
//                   setState(() {});
//                 },
//                 controller: _controller,
//                 minLines: 5,
//                 maxLines: 100,
//                 style: TextStyle(
//                   color: Color(0xFF333333),
//                   fontSize: rSP(14),
//                 ),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: '宝贝满足你的期待吗？说说你的使用心得，和大家分享吧',
//                   hintStyle: TextStyle(
//                     color: Color(0xFF999999),
//                     fontSize: rSP(14),
//                   ),
//                 ),
//               ),
//               GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: rSize(8),
//                   mainAxisSpacing: rSize(8),
//                 ),
//                 itemBuilder: (context, index) {
//                   if (index == _mediaModels.length) {
//                     return Material(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(rSize(4)),
//                       child: Ink.image(
//                         image: AssetImage(R.ASSETS_USER_UPLOAD_IMAGES_WEBP),
//                         child: InkWell(
//                           onTap: () {
//                             ActionSheet.show(
//                               context,
//                               items: ['拍照', '从手机相册选择'],
//                               listener: (index) {
//                                 if (index == 0) {
//                                   ImagePicker.builder()
//                                       .pickImage(
//                                     source:
//                                         flutterImagePicker.ImageSource.camera,
//                                   )
//                                       .then(
//                                     (model) {
//                                       if (model != null)
//                                         _mediaModels.add(model);
//                                       setState(() {});
//                                     },
//                                   );
//                                 } else if (index == 1) {
//                                   ImagePicker.builder(
//                                     maxSelected: 6 - _mediaModels.length,
//                                     pickType: PickType.onlyImage,
//                                   ).pickAsset(context).then(
//                                     (models) {
//                                       if (models != null && models.isNotEmpty)
//                                         _mediaModels.addAll(models);
//                                       setState(() {});
//                                     },
//                                   );
//                                 }
//                                 Navigator.pop(context);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   } else {
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(rSize(4)),
//                       child: Image.file(
//                         _mediaModels[index].file,
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   }
//                 },
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount:
//                     _mediaModels.length == 6 ? 6 : _mediaModels.length + 1,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
