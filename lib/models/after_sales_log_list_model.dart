class AfterSalesLogListModel {
  String code;
  String msg;
  List<AfterSalesLogModel> data;

  AfterSalesLogListModel({this.code, this.msg, this.data});

  AfterSalesLogListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new AfterSalesLogModel.fromJson(v));
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

class AfterSalesLogModel {
  int id;
  int asId;
  String title;
  String content;
  String ctime;

  AfterSalesLogModel(
      {this.id, this.asId, this.title, this.content, this.ctime});

  AfterSalesLogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    asId = json['asId'];
    title = json['title'];
    content = json['content'];
    ctime = json['ctime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['asId'] = this.asId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['ctime'] = this.ctime;
    return data;
  }
}
