class HotVideoModel {
  String? title;
  String? shareUrl;
  String? author;
  String? itemCover;
  int? hotValue;
  String? hotWords;
  int? playCount;
  int? diggCount;
  int? commentCount;

  HotVideoModel(
      {this.title,
        this.shareUrl,
        this.author,
        this.itemCover,
        this.hotValue,
        this.hotWords,
        this.playCount,
        this.diggCount,
        this.commentCount});

  HotVideoModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shareUrl = json['share_url'];
    author = json['author'];
    itemCover = json['item_cover'];
    hotValue = json['hot_value'];
    hotWords = json['hot_words'];
    playCount = json['play_count'];
    diggCount = json['digg_count'];
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['share_url'] = this.shareUrl;
    data['author'] = this.author;
    data['item_cover'] = this.itemCover;
    data['hot_value'] = this.hotValue;
    data['hot_words'] = this.hotWords;
    data['play_count'] = this.playCount;
    data['digg_count'] = this.diggCount;
    data['comment_count'] = this.commentCount;
    return data;
  }
}