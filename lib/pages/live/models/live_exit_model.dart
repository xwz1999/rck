class LiveExitModel {
  String nickname;
  String headImgUrl;
  int duration;
  String salesVolume;
  int monthDuration;
  String anticipatedRevenue;
  int buy;
  int look;
  int praise;
  int fans;

  LiveExitModel(
      {this.nickname,
      this.headImgUrl,
      this.duration,
      this.salesVolume,
      this.monthDuration,
      this.anticipatedRevenue,
      this.buy,
      this.look,
      this.praise,
      this.fans});

  LiveExitModel.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    duration = json['duration'];
    salesVolume = json['salesVolume'];
    monthDuration = json['monthDuration'];
    anticipatedRevenue = json['anticipatedRevenue'];
    buy = json['buy'];
    look = json['look'];
    praise = json['praise'];
    fans = json['Fans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['duration'] = this.duration;
    data['salesVolume'] = this.salesVolume;
    data['monthDuration'] = this.monthDuration;
    data['anticipatedRevenue'] = this.anticipatedRevenue;
    data['buy'] = this.buy;
    data['look'] = this.look;
    data['praise'] = this.praise;
    data['Fans'] = this.fans;
    return data;
  }
}
