class AirItemModel {
  Items items;
  int pageNo;
  int pageSize;
  int totalCount;

  AirItemModel({this.items, this.pageNo, this.pageSize, this.totalCount});

  AirItemModel.fromJson(Map<String, dynamic> json) {
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.toJson();
    }
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class Items {
  List<Item> item;

  Items({this.item});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['item'] != null) {
      item = new List<Item>();
      json['item'].forEach((v) {
        item.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String itemId;
  String itemName;
  String inPrice;

  Item({this.itemId, this.itemName, this.inPrice});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    itemName = json['itemName'];
    inPrice = json['inPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['itemName'] = this.itemName;
    data['inPrice'] = this.inPrice;
    return data;
  }
}
