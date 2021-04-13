class ReturnReasonModel {
  String code;
  String msg;
  List<ReasonModel> data;

  ReturnReasonModel({this.code, this.msg, this.data});

  ReturnReasonModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new ReasonModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReasonModel {
  num id;
  num type;
  String content;
  num orderBy;

  ReasonModel({this.id, this.type, this.content, this.orderBy});

  ReasonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    content = json['content'];
    orderBy = json['orderBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['content'] = this.content;
    data['orderBy'] = this.orderBy;
    return data;
  }
}
