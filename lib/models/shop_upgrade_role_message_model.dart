//TODO CLEAN BOTTOM CODES.
@Deprecated("shop_upgrade_role_message_model need to be cleaned.")
class ShopUpgradeRoleMessageModel {
  String code;
  String msg;
  String data;

  ShopUpgradeRoleMessageModel({this.code, this.msg, this.data});

  ShopUpgradeRoleMessageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}
