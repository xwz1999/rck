class TencentIMUserModel {
  String identifier;
  String sign;

  TencentIMUserModel({this.identifier, this.sign});

  TencentIMUserModel.empty() {
    identifier = '';
    sign = '';
  }
  TencentIMUserModel.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['sign'] = this.sign;
    return data;
  }
}
