class RecommendUserModel {
  num id;
  String mobile;
  num kind;
  String kindStr;
  String createdAt;
  num state;
  String stateStr;
  String processTime;
  String reason;

  RecommendUserModel(
      {this.id,
        this.mobile,
        this.kind,
        this.kindStr,
        this.createdAt,
        this.state,
        this.stateStr,
        this.processTime,
        this.reason});

  RecommendUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    kind = json['kind'];
    kindStr = json['kind_str'];
    createdAt = json['created_at'];
    state = json['state'];
    stateStr = json['state_str'];
    processTime = json['process_time'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['kind'] = this.kind;
    data['kind_str'] = this.kindStr;
    data['created_at'] = this.createdAt;
    data['state'] = this.state;
    data['state_str'] = this.stateStr;
    data['process_time'] = this.processTime;
    data['reason'] = this.reason;
    return data;
  }
}