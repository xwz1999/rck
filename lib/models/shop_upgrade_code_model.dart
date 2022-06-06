//TODO CLEAN BOTTOM CODES.
@Deprecated("shop_upgrade_code_model need to be cleaned.")
class ShopUpgradeCodeModel {
  String? code;
  String? msg;
  Data? data;

  ShopUpgradeCodeModel({this.code, this.msg, this.data});

  ShopUpgradeCodeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? usedCode;
  List<String>? unusedCode;

  Data({this.usedCode, this.unusedCode});

  Data.fromJson(Map<String, dynamic> json) {
    usedCode = json['usedCode'] != null ? json['usedCode'].cast<String>() : [];
    unusedCode =
        json['unusedCode'] != null ? json['unusedCode'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usedCode'] = this.usedCode;
    data['unusedCode'] = this.unusedCode;
    return data;
  }
}
