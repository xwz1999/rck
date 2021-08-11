class CountryListModel {
  int id;
  String name;
  String icon;
  int parentId;
  List<Country> children;

  CountryListModel(
      {this.id, this.name, this.icon, this.parentId, this.children});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    parentId = json['parent_id'];
    if (json['children'] != null) {
      children = new List<Country>();
      json['children'].forEach((v) {
        children.add(new Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['parent_id'] = this.parentId;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  int id;
  String name;
  String icon;
  int parentId;

  Country({this.id, this.name, this.icon, this.parentId});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['parent_id'] = this.parentId;
    return data;
  }
}
