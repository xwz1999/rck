import 'package:json_annotation/json_annotation.dart';

import 'package:jingyaoyun/models/base_model.dart';

part 'logistic_list_model.g.dart';


@JsonSerializable()
class LogisticListModel extends BaseModel {

  List<LogisticDetailModel> data;

  LogisticListModel(code,this.data,msg,) : super(code,msg);

  factory LogisticListModel.fromJson(Map<String, dynamic> srcJson) => _$LogisticListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LogisticListModelToJson(this);

}


@JsonSerializable()
class LogisticDetailModel extends Object {

  List<String> picUrls;

  String name;

  String no;

  List<LogisticStatus> data;

  LogisticDetailModel(this.picUrls,this.name,this.no,this.data,);

  factory LogisticDetailModel.fromJson(Map<String, dynamic> srcJson) => _$LogisticDetailModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LogisticDetailModelToJson(this);

}


@JsonSerializable()
class LogisticStatus extends Object {

  String context;

  String ftime;

  LogisticStatus(this.context,this.ftime,);

  factory LogisticStatus.fromJson(Map<String, dynamic> srcJson) => _$LogisticStatusFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LogisticStatusToJson(this);

}

  
