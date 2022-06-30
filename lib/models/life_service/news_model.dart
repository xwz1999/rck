class NewsModel {
  String? uniquekey;
  String? title;
  String? date;
  String? category;
  String? authorName;
  String? url;
  String? thumbnailPicS;
  String? isContent;

  NewsModel(
      {this.uniquekey,
        this.title,
        this.date,
        this.category,
        this.authorName,
        this.url,
        this.thumbnailPicS,
        this.isContent});

  NewsModel.fromJson(Map<String, dynamic> json) {
    uniquekey = json['uniquekey'];
    title = json['title'];
    date = json['date'];
    category = json['category'];
    authorName = json['author_name'];
    url = json['url'];
    thumbnailPicS = json['thumbnail_pic_s'];
    isContent = json['is_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uniquekey'] = this.uniquekey;
    data['title'] = this.title;
    data['date'] = this.date;
    data['category'] = this.category;
    data['author_name'] = this.authorName;
    data['url'] = this.url;
    data['thumbnail_pic_s'] = this.thumbnailPicS;
    data['is_content'] = this.isContent;
    return data;
  }
}