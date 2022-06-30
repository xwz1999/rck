class HotPersonModel {
  String? nickname;
  int? followerCount;
  int? effectValue;
  String? avatar;
  List<VideoList>? videoList;

  HotPersonModel(
      {this.nickname,
        this.followerCount,
        this.effectValue,
        this.avatar,
        this.videoList});

  HotPersonModel.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    followerCount = json['follower_count'];
    effectValue = json['effect_value'];
    avatar = json['avatar'];
    if (json['video_list'] != null) {
      videoList = [];
      json['video_list'].forEach((v) {
        videoList!.add(new VideoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['follower_count'] = this.followerCount;
    data['effect_value'] = this.effectValue;
    data['avatar'] = this.avatar;
    if (this.videoList != null) {
      data['video_list'] = this.videoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoList {
  String? itemCover;
  String? shareUrl;
  String? title;

  VideoList({this.itemCover, this.shareUrl, this.title});

  VideoList.fromJson(Map<String, dynamic> json) {
    itemCover = json['item_cover'];
    shareUrl = json['share_url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_cover'] = this.itemCover;
    data['share_url'] = this.shareUrl;
    data['title'] = this.title;
    return data;
  }
}