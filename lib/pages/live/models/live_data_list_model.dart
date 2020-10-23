class LiveDataListModel {
  int id;
  int startAt;
  int endAt;

  LiveDataListModel({this.id, this.startAt, this.endAt});

  LiveDataListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startAt = json['startAt'];
    endAt = json['endAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startAt'] = this.startAt;
    data['endAt'] = this.endAt;
    return data;
  }
}
