import 'package:json_annotation/json_annotation.dart';

import 'package:jingyaoyun/models/base_model.dart';

part 'PayInfoModel.g.dart';

@JsonSerializable()
class PayInfoModel extends BaseModel{
  @JsonKey(name: "data")
  PayInfo payInfo;
  PayInfoModel(this.payInfo, code, msg) : super(code, msg);

  factory PayInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PayInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayInfoModelToJson(this);
}


@JsonSerializable()
class PayInfo{
  String noncestr;
  String sign;
  String prepayid;
  String appid;
  String partnerid;
  String package;
  String timestamp;


  PayInfo(this.noncestr, this.sign, this.prepayid, this.appid, this.partnerid,
      this.package, this.timestamp);

  factory PayInfo.fromJson(Map<String, dynamic> json) =>
      _$PayInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PayInfoToJson(this);
}

