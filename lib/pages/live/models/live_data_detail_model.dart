class LiveDataDetailModel {
  int id;
  int startAt;
  int endAt;
  String salesVolume;
  String anticipatedRevenue;
  int buy;
  int look;
  int praise;
  int fans;

  LiveDataDetailModel(
      {this.id,
      this.startAt,
      this.endAt,
      this.salesVolume,
      this.anticipatedRevenue,
      this.buy,
      this.look,
      this.praise,
      this.fans});
  LiveDataDetailModel.zero() {
    id = 0;
    startAt = 0;
    endAt = 0;
    salesVolume = '';
    anticipatedRevenue = '';
    buy = 0;
    look = 0;
    praise = 0;
    fans = 0;
  }
  LiveDataDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startAt = json['startAt'];
    endAt = json['endAt'];
    salesVolume = json['salesVolume'];
    anticipatedRevenue = json['anticipatedRevenue'];
    buy = json['buy'];
    look = json['look'];
    praise = json['praise'];
    fans = json['fans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startAt'] = this.startAt;
    data['endAt'] = this.endAt;
    data['salesVolume'] = this.salesVolume;
    data['anticipatedRevenue'] = this.anticipatedRevenue;
    data['buy'] = this.buy;
    data['look'] = this.look;
    data['praise'] = this.praise;
    data['fans'] = this.fans;
    return data;
  }
}
