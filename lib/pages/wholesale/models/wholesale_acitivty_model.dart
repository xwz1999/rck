class WholesaleActivityModel {
  int? id;
  String? name;
  String? icon;
  int? orderSort;
  int? status;

  WholesaleActivityModel(
      {this.id, this.name, this.icon, this.orderSort, this.status});

  WholesaleActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    orderSort = json['order_sort'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['order_sort'] = this.orderSort;
    data['status'] = this.status;
    return data;
  }
}