class AkuVideoListModel {
  List<AkuVideo>? list;
  int? total;

  AkuVideoListModel({this.list, this.total});

  AkuVideoListModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new AkuVideo.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class AkuVideo {
  int? id;
  String? title;
  String? subTitle;
  int? type;//1为视频 2为图文
  int? isDraft;
  String? createDTime;
  String? textBody;
  String? coverUrl;
  String? videoUrl;
  num? numberOfHits;

  AkuVideo(
      {this.id,
      this.title,
      this.subTitle,
      this.type,
      this.isDraft,
      this.createDTime,
      this.textBody,
      this.coverUrl,
      this.videoUrl,
      this.numberOfHits,
      });

  AkuVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    type = json['type'];
    isDraft = json['is_draft'];
    createDTime = json['create_d_time'];
    textBody = json['text_body'];
    coverUrl = json['cover_url'];
    videoUrl = json['video_url'];
    numberOfHits = json['number_of_hits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['type'] = this.type;
    data['is_draft'] = this.isDraft;
    data['create_d_time'] = this.createDTime;
    data['text_body'] = this.textBody;
    data['cover_url'] = this.coverUrl;
    data['video_url'] = this.videoUrl;
    data['number_of_hits'] = this.numberOfHits;
    return data;
  }
}
