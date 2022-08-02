class BFRModel {
  int? bfr;
  String? remark;

  BFRModel({this.bfr, this.remark});

  BFRModel.fromJson(Map<String, dynamic> json) {
    bfr = json['bfr'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bfr'] = this.bfr;
    data['remark'] = this.remark;
    return data;
  }
}