class IdiomModel {
  String? lastWord;
  List<String>? data;
  int? totalCount;

  IdiomModel({this.lastWord, this.data, this.totalCount});

  IdiomModel.fromJson(Map<String, dynamic> json) {
    lastWord = json['last_word'];
    data = json['data'].cast<String>();
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_word'] = this.lastWord;
    data['data'] = this.data;
    data['total_count'] = this.totalCount;
    return data;
  }
}