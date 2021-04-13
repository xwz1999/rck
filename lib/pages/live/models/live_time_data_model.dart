class LiveTimeDataModel {
  int look;
  String salesVolume;
  String anticipatedRevenue;
  int buy;
  int praise;
  int fans;
  int count;
  int duration;
  List<LiveTimeDataBase> datePrise;
  List<LiveTimeDataBase> dateLook;
  List<LiveTimeDataBase> dateFans;
  List<LiveTimeDataBase> dateBuy;
  List<LiveTimeDataBase> dateSalesVolume;
  List<LiveTimeDataBase> dateAnticipatedRevenue;

  LiveTimeDataModel(
      {this.look,
      this.salesVolume,
      this.anticipatedRevenue,
      this.buy,
      this.praise,
      this.fans,
      this.count,
      this.duration,
      this.datePrise,
      this.dateLook,
      this.dateFans,
      this.dateBuy,
      this.dateSalesVolume,
      this.dateAnticipatedRevenue});
  LiveTimeDataModel.zero() {
    this.look = 0;
    this.salesVolume = "0";
    this.anticipatedRevenue = "0";
    buy = 0;
    praise = 0;
    fans = 0;
    count = 0;
    duration = 0;
    datePrise = [];
    dateLook = [];
    dateFans = [];
    dateBuy = [];
    dateSalesVolume = [];
    dateAnticipatedRevenue = [];
    // this.
  }
  LiveTimeDataModel.fromJson(Map<String, dynamic> json) {
    look = json['look'];
    salesVolume = json['salesVolume'];
    anticipatedRevenue = json['anticipatedRevenue'];
    buy = json['buy'];
    praise = json['praise'];
    fans = json['fans'];
    count = json['count'];
    duration = json['duration'];
    if (json['datePrise'] != null) {
      datePrise = [];
      json['datePrise'].forEach((v) {
        datePrise.add(new LiveTimeDataBase.fromJson(v));
      });
    }
    if (json['dateLook'] != null) {
      dateLook = [];
      json['dateLook'].forEach((v) {
        dateLook.add(new LiveTimeDataBase.fromJson(v));
      });
    }
    if (json['dateFans'] != null) {
      dateFans = [];
      json['dateFans'].forEach((v) {
        dateFans.add(new LiveTimeDataBase.fromJson(v));
      });
    }
    if (json['dateBuy'] != null) {
      dateBuy = [];
      json['dateBuy'].forEach((v) {
        dateBuy.add(new LiveTimeDataBase.fromJson(v));
      });
    }
    if (json['dateSalesVolume'] != null) {
      dateSalesVolume = [];
      json['dateSalesVolume'].forEach((v) {
        dateSalesVolume.add(new LiveTimeDataBase.fromJson(v));
      });
    }
    if (json['dateAnticipatedRevenue'] != null) {
      dateAnticipatedRevenue = [];
      json['dateAnticipatedRevenue'].forEach((v) {
        dateAnticipatedRevenue.add(new LiveTimeDataBase.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['look'] = this.look;
    data['salesVolume'] = this.salesVolume;
    data['anticipatedRevenue'] = this.anticipatedRevenue;
    data['buy'] = this.buy;
    data['praise'] = this.praise;
    data['fans'] = this.fans;
    data['count'] = this.count;
    data['duration'] = this.duration;
    if (this.datePrise != null) {
      data['datePrise'] = this.datePrise.map((v) => v.toJson()).toList();
    }
    if (this.dateLook != null) {
      data['dateLook'] = this.dateLook.map((v) => v.toJson()).toList();
    }
    if (this.dateFans != null) {
      data['dateFans'] = this.dateFans.map((v) => v.toJson()).toList();
    }
    if (this.dateBuy != null) {
      data['dateBuy'] = this.dateBuy.map((v) => v.toJson()).toList();
    }
    if (this.dateSalesVolume != null) {
      data['dateSalesVolume'] =
          this.dateSalesVolume.map((v) => v.toJson()).toList();
    }
    if (this.dateAnticipatedRevenue != null) {
      data['dateAnticipatedRevenue'] =
          this.dateAnticipatedRevenue.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LiveTimeDataBase {
  String date;
  dynamic count;

  LiveTimeDataBase({this.date, this.count});

  LiveTimeDataBase.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['count'] = this.count;
    return data;
  }
}
