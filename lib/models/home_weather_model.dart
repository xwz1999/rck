class HomeWeatherModel {
  String? cityid;
  String? date;
  String? week;
  String? updateTime;
  String? city;
  String? cityEn;
  String? country;
  String? countryEn;
  String? wea;
  String? weaImg;
  String? tem;
  String? tem1;
  String? tem2;
  String? win;
  String? winSpeed;
  String? winMeter;
  String? humidity;
  String? visibility;
  String? pressure;
  String? air;
  String? airPm25;
  String? airLevel;
  String? airTips;
  Alarm? alarm;
  dynamic aqi;

  HomeWeatherModel(
      {this.cityid,
      this.date,
      this.week,
      this.updateTime,
      this.city,
      this.cityEn,
      this.country,
      this.countryEn,
      this.wea,
      this.weaImg,
      this.tem,
      this.tem1,
      this.tem2,
      this.win,
      this.winSpeed,
      this.winMeter,
      this.humidity,
      this.visibility,
      this.pressure,
      this.air,
      this.airPm25,
      this.airLevel,
      this.airTips,
      this.alarm,
      this.aqi});

  HomeWeatherModel.fromJson(Map<String, dynamic> json) {
    cityid = json['cityid'];
    date = json['date'];
    week = json['week'];
    updateTime = json['update_time'];
    city = json['city'];
    cityEn = json['cityEn'];
    country = json['country'];
    countryEn = json['countryEn'];
    wea = json['wea'];
    weaImg = json['wea_img'];
    tem = json['tem'];
    tem1 = json['tem1'];
    tem2 = json['tem2'];
    win = json['win'];
    winSpeed = json['win_speed'];
    winMeter = json['win_meter'];
    humidity = json['humidity'];
    visibility = json['visibility'];
    pressure = json['pressure'];
    air = json['air'];
    airPm25 = json['air_pm25'];
    airLevel = json['air_level'];
    airTips = json['air_tips'];
    alarm = json['alarm'] != null ? new Alarm.fromJson(json['alarm']) : null;
    if(json['aqi'].runtimeType!=[].runtimeType){
      print(json['aqi'].runtimeType);
      aqi = ((json['aqi'] != null) ? new Aqi.fromJson(json['aqi']): null);
    }else{
      aqi = null;
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityid'] = this.cityid;
    data['date'] = this.date;
    data['week'] = this.week;
    data['update_time'] = this.updateTime;
    data['city'] = this.city;
    data['cityEn'] = this.cityEn;
    data['country'] = this.country;
    data['countryEn'] = this.countryEn;
    data['wea'] = this.wea;
    data['wea_img'] = this.weaImg;
    data['tem'] = this.tem;
    data['tem1'] = this.tem1;
    data['tem2'] = this.tem2;
    data['win'] = this.win;
    data['win_speed'] = this.winSpeed;
    data['win_meter'] = this.winMeter;
    data['humidity'] = this.humidity;
    data['visibility'] = this.visibility;
    data['pressure'] = this.pressure;
    data['air'] = this.air;
    data['air_pm25'] = this.airPm25;
    data['air_level'] = this.airLevel;
    data['air_tips'] = this.airTips;
    if (this.alarm != null) {
      data['alarm'] = this.alarm!.toJson();
    }
    if (this.aqi != null) {
      data['aqi'] = this.aqi.toJson();
    }
    return data;
  }
}

class Alarm {
  String? alarmType;
  String? alarmLevel;
  String? alarmContent;

  Alarm({this.alarmType, this.alarmLevel, this.alarmContent});

  Alarm.fromJson(Map<String, dynamic> json) {
    alarmType = json['alarm_type'];
    alarmLevel = json['alarm_level'];
    alarmContent = json['alarm_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alarm_type'] = this.alarmType;
    data['alarm_level'] = this.alarmLevel;
    data['alarm_content'] = this.alarmContent;
    return data;
  }
}

class Aqi {
  String? air;
  String? airLevel;
  String? airTips;
  String? pm25;
  String? pm25Desc;
  String? pm10;
  String? pm10Desc;
  String? o3;
  String? o3Desc;
  String? no2;
  String? no2Desc;
  String? so2;
  String? so2Desc;
  String? kouzhao;
  String? waichu;
  String? kaichuang;
  String? jinghuaqi;
  String? cityid;
  String? city;
  String? cityEn;
  String? country;
  String? countryEn;

  Aqi(
      {this.air,
      this.airLevel,
      this.airTips,
      this.pm25,
      this.pm25Desc,
      this.pm10,
      this.pm10Desc,
      this.o3,
      this.o3Desc,
      this.no2,
      this.no2Desc,
      this.so2,
      this.so2Desc,
      this.kouzhao,
      this.waichu,
      this.kaichuang,
      this.jinghuaqi,
      this.cityid,
      this.city,
      this.cityEn,
      this.country,
      this.countryEn});

  Aqi.fromJson(Map<String, dynamic> json) {
    air = json['air'];
    airLevel = json['air_level'];
    airTips = json['air_tips'];
    pm25 = json['pm25'];
    pm25Desc = json['pm25_desc'];
    pm10 = json['pm10'];
    pm10Desc = json['pm10_desc'];
    o3 = json['o3'];
    o3Desc = json['o3_desc'];
    no2 = json['no2'];
    no2Desc = json['no2_desc'];
    so2 = json['so2'];
    so2Desc = json['so2_desc'];
    kouzhao = json['kouzhao'];
    waichu = json['waichu'];
    kaichuang = json['kaichuang'];
    jinghuaqi = json['jinghuaqi'];
    cityid = json['cityid'];
    city = json['city'];
    cityEn = json['cityEn'];
    country = json['country'];
    countryEn = json['countryEn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['air'] = this.air;
    data['air_level'] = this.airLevel;
    data['air_tips'] = this.airTips;
    data['pm25'] = this.pm25;
    data['pm25_desc'] = this.pm25Desc;
    data['pm10'] = this.pm10;
    data['pm10_desc'] = this.pm10Desc;
    data['o3'] = this.o3;
    data['o3_desc'] = this.o3Desc;
    data['no2'] = this.no2;
    data['no2_desc'] = this.no2Desc;
    data['so2'] = this.so2;
    data['so2_desc'] = this.so2Desc;
    data['kouzhao'] = this.kouzhao;
    data['waichu'] = this.waichu;
    data['kaichuang'] = this.kaichuang;
    data['jinghuaqi'] = this.jinghuaqi;
    data['cityid'] = this.cityid;
    data['city'] = this.city;
    data['cityEn'] = this.cityEn;
    data['country'] = this.country;
    data['countryEn'] = this.countryEn;
    return data;
  }
}
