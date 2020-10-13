class LiveBrandModel {
  int id;
  String name;
  String logoUrl;

  LiveBrandModel({this.id, this.name, this.logoUrl});

  LiveBrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logoUrl = json['logoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logoUrl'] = this.logoUrl;
    return data;
  }
}
