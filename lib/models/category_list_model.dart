class CategoryListModel {
  First? first;
  List<First>? child;

  CategoryListModel({this.first, this.child});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    first = json['first'] != null ? new First.fromJson(json['first']) : null;
    if (json['child'] != null) {
      child = [];
      json['child'].forEach((v) {
        child!.add(new First.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.first != null) {
      data['first'] = this.first!.toJson();
    }
    if (this.child != null) {
      data['child'] = this.child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class First {
  int? id;
  String? name;
  int? parentId;
  int? depth;
  String? logoUrl;
  int? location;
  int? show;
  int? gysShow;
  bool? isAllow;

  First(
      {this.id,
      this.name,
      this.parentId,
      this.depth,
      this.logoUrl,
      this.location,
      this.show,
      this.gysShow,
      this.isAllow});

  First.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parentId'];
    depth = json['depth'];
    logoUrl = json['logoUrl'];
    location = json['location'];
    show = json['show'];
    gysShow = json['gysShow'];
    isAllow = json['is_allow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parentId'] = this.parentId;
    data['depth'] = this.depth;
    data['logoUrl'] = this.logoUrl;
    data['location'] = this.location;
    data['show'] = this.show;
    data['gysShow'] = this.gysShow;
    data['is_allow'] = this.isAllow;
    return data;
  }
}