class JokeModel {
  String? content;
  String? hashId;
  int? unixtime;

  JokeModel({this.content, this.hashId, this.unixtime});

  JokeModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    hashId = json['hashId'];
    unixtime = json['unixtime'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['hashId'] = this.hashId;
    data['unixtime'] = this.unixtime;

    return data;
  }
}