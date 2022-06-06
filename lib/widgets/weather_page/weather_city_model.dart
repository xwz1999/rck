import 'package:azlistview/azlistview.dart';

class WeatherCityModel extends ISuspensionBean {
  String? id;
  String? cityEn;
  String? cityZh;
  String? provinceEn;
  String? provinceZh;
  String? leaderEn;
  String? leaderZh;
  String? lat;
  String? lon;

  String? tagIndex;
  String? namePinyin;
  String? provinceZhPingyin;

  WeatherCityModel(
      {this.id,
      this.cityEn,
      this.cityZh,
      this.provinceEn,
      this.provinceZh,
      this.leaderEn,
      this.leaderZh,
      this.lat,
      this.lon, 
      this.tagIndex, 
      this.namePinyin, 
      this.provinceZhPingyin});
  
  @override
  String getSuspensionTag() => tagIndex!;

  WeatherCityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityEn = json['cityEn'];
    cityZh = json['cityZh'];
    provinceEn = json['provinceEn'];
    provinceZh = json['provinceZh'];
    leaderEn = json['leaderEn'];
    leaderZh = json['leaderZh'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cityEn'] = this.cityEn;
    data['cityZh'] = this.cityZh;
    data['provinceEn'] = this.provinceEn;
    data['provinceZh'] = this.provinceZh;
    data['leaderEn'] = this.leaderEn;
    data['leaderZh'] = this.leaderZh;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}
