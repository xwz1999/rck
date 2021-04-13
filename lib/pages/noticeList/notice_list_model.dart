class NoticeListModel {
  String code;
  String msg;
  List<NoticeData> data;

  NoticeListModel({this.code, this.msg, this.data});

  NoticeListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new NoticeData.fromJson(v));
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

class NoticeData {
  num id;
  int type;
  num userId;
  String content;
  String creatTime;
  int isShow;

  NoticeData(
      {this.id,
      this.type,
      this.userId,
      this.content,
      this.creatTime,
      this.isShow});

  NoticeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    userId = json['userId'];
    content = json['content'];
    creatTime = json['creatTime'];
    isShow = json['isShow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['content'] = this.content;
    data['creatTime'] = this.creatTime;
    data['isShow'] = this.isShow;
    return data;
  }
}
