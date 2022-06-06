import 'package:recook/pages/live/models/video_list_model.dart';

class LiveBaseInfoModel {
  int? follows;
  int? fans;
  int? praise;
  int? userId;
  String? nickname;
  String? headImgUrl;

  LiveBaseInfoModel(
      {this.follows,
      this.fans,
      this.praise,
      this.userId,
      this.nickname,
      this.headImgUrl});
  LiveBaseInfoModel.fromVideoListModel(VideoListModel model) {
    this.follows = 0;
    this.fans = 0;
    this.praise = 0;
    this.userId = model.userId;
    this.nickname = model.nickname;
    this.headImgUrl = model.headImgUrl;
  }
  LiveBaseInfoModel.fromJson(Map<String, dynamic> json) {
    follows = json['follows'];
    fans = json['fans'];
    praise = json['praise'];
    userId = json['userId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
  }

  LiveBaseInfoModel.zero() {
    follows = 0;
    fans = 0;
    praise = 0;
    nickname = '';
    headImgUrl = '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['follows'] = this.follows;
    data['fans'] = this.fans;
    data['praise'] = this.praise;
    data['userId'] = this.userId;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    return data;
  }
}
