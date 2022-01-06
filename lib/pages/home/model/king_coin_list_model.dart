// class KingCoinListModel {
//   String url;
//   int sortId;
//
//   KingCoinListModel({this.url, this.sortId});
//
//   KingCoinListModel.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     sortId = json['sort_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = this.url;
//     data['sort_id'] = this.sortId;
//     return data;
//   }
// }
class KingCoinListModel {
  int sortId;
  List<KingCoin> data;

  KingCoinListModel({this.sortId, this.data});

  KingCoinListModel.fromJson(Map<String, dynamic> json) {
    sortId = json['sort_id'];
    if (json['data'] != null) {
      data = new List<KingCoin>();
      json['data'].forEach((v) {
        data.add(new KingCoin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort_id'] = this.sortId;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KingCoin {
  int id;
  String url;
  String createdAt;
  int sortId;
  int status;
  String name;
  int kingNameId;
  KingName kingName;

  KingCoin(
      {this.id,
        this.url,
        this.createdAt,
        this.sortId,
        this.status,
        this.name,
        this.kingNameId,
        this.kingName});

  KingCoin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    createdAt = json['created_at'];
    sortId = json['sort_id'];
    status = json['status'];
    name = json['name'];
    kingNameId = json['king_name_id'];
    kingName = json['KingName'] != null
        ? new KingName.fromJson(json['KingName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['sort_id'] = this.sortId;
    data['status'] = this.status;
    data['name'] = this.name;
    data['king_name_id'] = this.kingNameId;
    if (this.kingName != null) {
      data['KingName'] = this.kingName.toJson();
    }
    return data;
  }
}

class KingName {
  int id;
  String name;

  KingName({this.id, this.name});

  KingName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}