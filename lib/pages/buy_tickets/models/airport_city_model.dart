import 'package:azlistview/azlistview.dart';

class AirportCityModel extends ISuspensionBean {
  String city;
  List<AirPorts> airPorts;
  String tagIndex;
  String namePinyin;

  AirportCityModel({this.city, this.airPorts, this.tagIndex, this.namePinyin});

  AirportCityModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    if (json['AirPorts'] != null) {
      airPorts = new List<AirPorts>();
      json['AirPorts'].forEach((v) {
        airPorts.add(new AirPorts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    if (this.airPorts != null) {
      data['AirPorts'] = this.airPorts.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String getSuspensionTag() => tagIndex;
}

class AirPorts {
  int id;
  String cityName;
  String code;
  String quanpin;
  String name;
  String duanpin;

  AirPorts(
      {this.id,
      this.cityName,
      this.code,
      this.quanpin,
      this.name,
      this.duanpin});

  AirPorts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityName = json['city_name'];
    code = json['code'];
    quanpin = json['quanpin'];
    name = json['name'];
    duanpin = json['duanpin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_name'] = this.cityName;
    data['code'] = this.code;
    data['quanpin'] = this.quanpin;
    data['name'] = this.name;
    data['duanpin'] = this.duanpin;
    return data;
  }
}
