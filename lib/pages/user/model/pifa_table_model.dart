class PiFaTableModel {
  num total;
  List<PiFaData> data;

  PiFaTableModel({this.total, this.data});

  PiFaTableModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new PiFaData.fromJson(v));
      });
    }else{
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PiFaData {
  String name;
  int count;
  double amount;

  PiFaData({this.name, this.count, this.amount});

  PiFaData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['amount'] = this.amount;
    return data;
  }
}