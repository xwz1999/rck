class RuiCoinListModel {
  String code;
  String msg;
  CoinData data;

  RuiCoinListModel({this.code, this.msg, this.data});

  RuiCoinListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new CoinData.fromJson(json['data']) : null;
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

class CoinData {
  num total;
  num history;
  List<CoinList> list;

  CoinData({this.total, this.history, this.list});

  CoinData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    history = json['history'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(new CoinList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['history'] = this.history;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoinList {
  UserCoin userCoin;
  String typeName;

  CoinList({this.userCoin, this.typeName});

  CoinList.fromJson(Map<String, dynamic> json) {
    userCoin = json['UserCoin'] != null
        ? new UserCoin.fromJson(json['UserCoin'])
        : null;
    typeName = json['typeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userCoin != null) {
      data['UserCoin'] = this.userCoin.toJson();
    }
    data['typeName'] = this.typeName;
    return data;
  }
}

class UserCoin {
  num id;
  num userId;
  num coinType;
  num coinNum;
  String createdAt;

  UserCoin({this.id, this.userId, this.coinType, this.coinNum, this.createdAt});

  UserCoin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    coinType = json['coinType'];
    coinNum = json['coin_num'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['coinType'] = this.coinType;
    data['coin_num'] = this.coinNum;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

// /*
//  * ====================================================
//  * package   :
//  * author    : Created by nansi.
//  * time      : 2019-08-27  11:41
//  * remark    :
//  * ====================================================
//  */

// /*
// {
//     "code": "SUCCESS",
//     "data": {
//         "code": "SUCCESS",
//         "msg": "操作成功",
//         "data": {
//             "amount": 0,
//             "detail": [
//                 {
//                     "id": 3,
//                     "type": 1,
//                     "amount": 1, //余额
//                     number//瑞币
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-15 17:08:00"
//                 },
//                 {
//                     "id": 5,
//                     "type": 1,
//                     "amount": 2,
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-15 17:20:09"
//                 },
//                 {
//                     "id": 6,
//                     "type": 1,
//                     "amount": 2,
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-15 17:23:45"
//                 },
//                 {
//                     "id": 7,
//                     "type": 1,
//                     "amount": 3,
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-15 17:25:49"
//                 },
//                 {
//                     "id": 11,
//                     "type": 1,
//                     "amount": 2,
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-15 18:03:39"
//                 },
//                 {
//                     "id": 13,
//                     "type": 1,
//                     "amount": 2,
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-16 10:13:12"
//                 },
//                 {
//                     "id": 14,
//                     "type": 1,
//                     "amount": 2,
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-16 10:24:35"
//                 },
//                 {
//                     "id": 15,
//                     "type": 1,
//                     "amount": 3,
//                     "title": "订单退款",
//                     "channel": "退款退回",
//                     "orderID": 0,
//                     "createdAt": "2019-08-16 10:42:40"
//                 }
//             ]
//         }
//     }
// }
// */
// import 'package:json_annotation/json_annotation.dart';
// import 'package:recook/models/base_model.dart';

// part 'rui_coin_list_model.g.dart';

// @JsonSerializable()
// class RuiCoinListModel extends BaseModel {

//   RuiCoinModel data;

//   RuiCoinListModel(code,msg,this.data,) : super(code,msg);

//   factory RuiCoinListModel.fromJson(Map<String, dynamic> srcJson) => _$RuiCoinListModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$RuiCoinListModelToJson(this);

// }

// @JsonSerializable()
// class RuiCoinModel extends Object {

//   // double amount;
//   num total;
//   num history;

//   List<Detail> detail;

//   RuiCoinModel(this.amount,this.detail,);

//   factory RuiCoinModel.fromJson(Map<String, dynamic> srcJson) => _$RuiCoinModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$RuiCoinModelToJson(this);

// }

// @JsonSerializable()
// class Detail extends Object {

//   int id;

//   int type;

//   int number;

//   num amount;

//   String title;

//   String channel;

//   int orderID;

//   String createdAt;

//   Detail(this.id,this.type,this.number,this.title,this.channel,this.orderID,this.createdAt,this.amount,);

//   factory Detail.fromJson(Map<String, dynamic> srcJson) => _$DetailFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$DetailToJson(this);

// }
