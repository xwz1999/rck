class KingCoinListModel {
  String url;
  int sortId;

  KingCoinListModel({this.url, this.sortId});

  KingCoinListModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    sortId = json['sort_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['sort_id'] = this.sortId;
    return data;
  }
}