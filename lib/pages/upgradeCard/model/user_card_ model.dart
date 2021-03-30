class UserCardModel {
  int id;
  String code;
  int type;
  int source;
  String sourceName;
  int status;
  int giveUserId;
  String giveUserNickname;
  int useAt;
  int createdAt;

  UserCardModel(
      {this.id,
      this.code,
      this.type,
      this.source,
      this.sourceName,
      this.status,
      this.giveUserId,
      this.giveUserNickname,
      this.useAt,
      this.createdAt});

  UserCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    source = json['source'];
    sourceName = json['scourceName'];
    status = json['status'];
    giveUserId = json['giveUserId'];
    giveUserNickname = json['giveUserNickname'];
    useAt = json['useAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['type'] = this.type;
    data['source'] = this.source;
    data['status'] = this.status;
    data['giveUserId'] = this.giveUserId;
    data['giveUserNickname'] = this.giveUserNickname;
    data['useAt'] = this.useAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
