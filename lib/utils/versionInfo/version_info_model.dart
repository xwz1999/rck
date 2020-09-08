class VersionInfoModel {
  String code;
  String msg;
  Data data;

  VersionInfoModel({this.code, this.msg, this.data});

  VersionInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  VersionInfo versionInfo;

  Data({this.versionInfo});

  Data.fromJson(Map<String, dynamic> json) {
    versionInfo = json['versionInfo'] != null
        ? new VersionInfo.fromJson(json['versionInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.versionInfo != null) {
      data['versionInfo'] = this.versionInfo.toJson();
    }
    return data;
  }
}

class VersionInfo {
  String version;
  num build;
  String desc;
  String createdAt;

  VersionInfo({this.version, this.build, this.desc, this.createdAt});

  VersionInfo.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    build = json['build'];
    desc = json['desc'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['build'] = this.build;
    data['desc'] = this.desc;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
