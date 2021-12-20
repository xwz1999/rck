// import 'package:flutter_txugcupload/flutter_txugcupload.dart';
//
// class VideoPublishListener extends TXVideoPublishListener {
//   final Function(int uploadBytes, int totalBytes) onVideoPublishProgress;
//   final Function(TXPublishResult result) onVideoPublishComplete;
//
//   VideoPublishListener({
//     this.onVideoPublishProgress,
//     this.onVideoPublishComplete,
//   });
//
//   @override
//   void onPublishProgress(int uploadBytes, int totalBytes) {
//     if (this.onVideoPublishProgress == null) return;
//
//     this.onVideoPublishProgress(uploadBytes, totalBytes);
//   }
//
//   @override
//   void onPublishComplete(TXPublishResult result) {
//     if (this.onVideoPublishComplete == null) return;
//
//     this.onVideoPublishComplete(result);
//   }
// }
