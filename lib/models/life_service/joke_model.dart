class JokeModel {
  String? content;
  String? hashId;
  int? unixtime;
  String? updatetime;

  JokeModel({this.content, this.hashId, this.unixtime, this.updatetime});

  JokeModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    hashId = json['hashId'];
    unixtime = json['unixtime'];
    updatetime = json['updatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['hashId'] = this.hashId;
    data['unixtime'] = this.unixtime;
    data['updatetime'] = this.updatetime;
    return data;
  }
}