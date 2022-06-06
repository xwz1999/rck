class RechargeRecordModel {
  String? code;
  String? msg;
  Data? data;

  RechargeRecordModel({this.code, this.msg, this.data});

  RechargeRecordModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<RechargeRecord>? list;
  int? total;

  Data({this.list, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new RechargeRecord.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}


class RechargeRecord {
  int? id;
  num? amount;
  String? attach;
  String? createdAt;
  int? state;
  int? companyId;
  String? reason;
  bool? isCompany;
  String? applyUserName;
  String? applyTime;

  RechargeRecord(
      {this.id,
        this.amount,
        this.attach,
        this.createdAt,
        this.state,
        this.companyId,
        this.reason,
        this.isCompany,
        this.applyUserName,
        this.applyTime});

  RechargeRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    attach = json['attach'];
    createdAt = json['created_at'];
    state = json['state'];
    companyId = json['company_id'];
    reason = json['reason'];
    isCompany = json['is_company'];
    applyUserName = json['apply_user_name'];
    applyTime = json['apply_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['attach'] = this.attach;
    data['created_at'] = this.createdAt;
    data['state'] = this.state;
    data['company_id'] = this.companyId;
    data['reason'] = this.reason;
    data['is_company'] = this.isCompany;
    data['apply_user_name'] = this.applyUserName;
    data['apply_time'] = this.applyTime;
    return data;
  }
}