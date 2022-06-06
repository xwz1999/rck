class MessageModel {
  List<Message>? list;
  int? total;

  MessageModel({this.list, this.total});

  MessageModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list =  [];
      json['list'].forEach((v) {
        list!.add(new Message.fromJson(v));
      });
    }else{
      list =  [];
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

class Message {
  int? id;
  int? userId;
  String? message;
  int? kind;
  bool? isRead;
  int? subId;
  String? createdAt;

  Message(
      {this.id,
        this.userId,
        this.message,
        this.kind,
        this.isRead,
        this.subId,
        this.createdAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    message = json['message'];
    kind = json['kind'];
    isRead = json['is_read'];
    subId = json['sub_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['kind'] = this.kind;
    data['is_read'] = this.isRead;
    data['sub_id'] = this.subId;
    data['created_at'] = this.createdAt;
    return data;
  }
}