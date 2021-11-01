class UserBriefInfoModel {
  String code;
  String msg;
  UserBrief data;

  UserBriefInfoModel({this.code, this.msg, this.data});

  UserBriefInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new UserBrief.fromJson(json['data']) : null;
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

class UserBrief {
  num balance;
  num roleLevel;
  MyAssets myAssets;
  MyShopping myShopping;
  MyShopping shareIncome;
  MyShopping teamIncome;
  OrderCenter orderCenter;
  VersionInfo versionInfo;
  String identifier;
  int secret;

  bool get secretValue => secret == 1;

  UserBrief({
    this.balance,
    this.roleLevel,
    this.myAssets,
    this.myShopping,
    this.shareIncome,
    this.teamIncome,
    this.orderCenter,
    this.versionInfo,
    this.identifier,
    this.secret,
  });

  UserBrief.empty() {
    this.roleLevel = 0;
    this.balance = 0.0;
    this.myAssets = MyAssets(cards: 0);
    this.myShopping = MyShopping(orderNum: 0, amount: 0, historyIncome: 0);
    this.shareIncome = MyShopping();
    this.teamIncome = MyShopping();
    this.orderCenter =
        OrderCenter(waitPay: 0, waitSend: 0, waitRecv: 0, afterSales: 0);
    this.versionInfo = VersionInfo();
    this.identifier = "";
    this.secret = 0;
  }

  UserBrief.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    roleLevel = json['roleLevel'];
    myAssets = json['myAssets'] != null
        ? new MyAssets.fromJson(json['myAssets'])
        : null;
    myShopping = json['myShopping'] != null
        ? new MyShopping.fromJson(json['myShopping'])
        : null;
    shareIncome = json['shareIncome'] != null
        ? new MyShopping.fromJson(json['shareIncome'])
        : null;
    teamIncome = json['teamIncome'] != null
        ? new MyShopping.fromJson(json['teamIncome'])
        : null;
    orderCenter = json['orderCenter'] != null
        ? new OrderCenter.fromJson(json['orderCenter'])
        : null;
    versionInfo = json['VersionInfo'] != null
        ? new VersionInfo.fromJson(json['VersionInfo'])
        : null;
    identifier = json['identifier'];
    secret = json['secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['roleLevel'] = this.roleLevel;
    data['identifier'] = this.identifier;
    if (this.myAssets != null) {
      data['myAssets'] = this.myAssets.toJson();
    }
    if (this.myShopping != null) {
      data['myShopping'] = this.myShopping.toJson();
    }
    if (this.shareIncome != null) {
      data['shareIncome'] = this.shareIncome.toJson();
    }
    if (this.teamIncome != null) {
      data['teamIncome'] = this.teamIncome.toJson();
    }
    if (this.orderCenter != null) {
      data['orderCenter'] = this.orderCenter.toJson();
    }
    if (this.versionInfo != null) {
      data['VersionInfo'] = this.versionInfo.toJson();
    }
    return data;
  }
}

class MyAssets {
  num cards;
  num coinNum;
  num couponNum;
  MyAssets({this.cards});

  MyAssets.fromJson(Map<String, dynamic> json) {
    cards = json['cards'];
    coinNum = json['coinNum'];
    couponNum = json['couponNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cards'] = this.cards;
    data['coinNum'] = this.coinNum;
    data['couponNum'] = this.couponNum;
    return data;
  }
}

class MyShopping {
  num orderNum;
  num amount;
  num historyIncome;

  MyShopping({this.orderNum, this.amount, this.historyIncome});

  MyShopping.fromJson(Map<String, dynamic> json) {
    orderNum = json['orderNum'];
    amount = json['amount'];
    historyIncome = json['historyIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNum'] = this.orderNum;
    data['amount'] = this.amount;
    data['historyIncome'] = this.historyIncome;
    return data;
  }
}

class OrderCenter {
  num waitPay;
  num waitSend;
  num waitRecv;
  num afterSales;
  num evaNum;
  num afterNum;
  num collectionNum;

  OrderCenter({this.waitPay, this.waitSend, this.waitRecv, this.afterSales,this.evaNum,this.afterNum,this.collectionNum});

  OrderCenter.fromJson(Map<String, dynamic> json) {
    waitPay = json['waitPay'];
    waitSend = json['waitSend'];
    waitRecv = json['waitRecv'];
    afterSales = json['afterSales'];
    evaNum = json['eva_num'];
    afterNum = json['after_num'];
    collectionNum = json['collection_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waitPay'] = this.waitPay;
    data['waitSend'] = this.waitSend;
    data['waitRecv'] = this.waitRecv;
    data['afterSales'] = this.afterSales;
    data['eva_num'] = this.evaNum;
    data['after_num']= this.afterNum;
    data['collection_num']= this.collectionNum;
    return data;
  }
}

class VersionInfo {
  String version;
  String desc;
  String createdAt;
  num build;

  VersionInfo({this.version, this.desc, this.createdAt, this.build});

  VersionInfo.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    desc = json['desc'];
    createdAt = json['createdAt'];
    build = json['build'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['desc'] = this.desc;
    data['createdAt'] = this.createdAt;
    data['build'] = this.build;
    return data;
  }
}

// /*
//  {
//         "code": "SUCCESS",
//         "data": {
//             "monthSaleAmount": 0,
//             "asset": {
//                 "fund": 0,
//                 "monthUnrecordedFund": 0,
//                 "coin": 0,
//                 "couponCount": 2,
//                 "favoritesCount": 0
//             },
//             "order": {
//                 "unpaidCount": 0,
//                 "noShipCount": 1,
//                 "noReceiveCount": 4
//             }
//             "versionInfo":{
//               "version":"1.0.5",
//               "build": 30,
//               "desc":"修复一些细节问题",
//               "createdAt": "2019--------"
//             }
//         },
//         "msg": "操作成功"
//     }
//   */
// import 'package:json_annotation/json_annotation.dart';
// import 'package:recook/models/base_model.dart';

// part 'user_brief_info_model.g.dart';

// @JsonSerializable()
// class UserBriefInfoModel extends BaseModel {
//   UserBrief data;

//   UserBriefInfoModel(
//     code,
//     this.data,
//     msg,
//   ):super(code,msg);

//   factory UserBriefInfoModel.fromJson(Map<String, dynamic> srcJson) =>
//       _$UserBriefInfoModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$UserBriefInfoModelToJson(this);
// }

// @JsonSerializable()
// class UserBrief extends Object {

//   double amount;

//   Asset asset;
//   Order order;
//   VersionInfo versionInfo;

//   int inviteCount;
//   String advice;
//   Buy buy;
//   int role;

//   UserBrief(
//     this.role,
//     this.amount,
//     this.asset,
//     this.order,
//     this.versionInfo,
//     this.inviteCount,
//     this.advice,
//     this.buy,
//   );

//   factory UserBrief.fromJson(Map<String, dynamic> srcJson) => _$UserBriefFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$UserBriefToJson(this);

//   UserBrief.empty() {
//     this.role = 0;
//     this.amount = 0.0;
//     this.asset = Asset(0, 0, 0);
//     this.order = Order(0, 0, 0);
//     this.versionInfo = VersionInfo("", "", "", 0);
//   }
// }

// @JsonSerializable()
// class Buy {

//   double commission;
//   double frozenCommission;
//   double cumulativeCommission;

//   Buy(this.commission, this.frozenCommission, this.cumulativeCommission);

//   factory Buy.fromJson(Map<String, dynamic> json) => _$BuyFromJson(json);
//   Map<String, dynamic> toJson() => _$BuyToJson(this);
// }

// @JsonSerializable()
// class Asset extends Object {
//   // double fund;

//   // double monthUnrecordedFund;

//   int coin;

//   int couponCount;

//   int favoritesCount;

//   Asset(
//     // this.fund,
//     // this.monthUnrecordedFund,
//     this.coin,
//     this.couponCount,
//     this.favoritesCount,
//   );

//   factory Asset.fromJson(Map<String, dynamic> srcJson) => _$AssetFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$AssetToJson(this);
// }

// @JsonSerializable()
// class Order extends Object {
//   int unpaidCount;

//   int noShipCount;

//   int noReceiveCount;

//   Order(
//     this.unpaidCount,
//     this.noShipCount,
//     this.noReceiveCount,
//   );

//   factory Order.fromJson(Map<String, dynamic> srcJson) => _$OrderFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$OrderToJson(this);
// }

// @JsonSerializable()
// class VersionInfo extends Object {
//   String version;
//   String desc;
//   String createdAt;
//   int build;

//   VersionInfo(
//     this.version,
//     this.desc,
//     this.createdAt,
//     this.build,
//   );

//   factory VersionInfo.fromJson(Map<String, dynamic> srcJson) => _$VersionInfoFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$VersionInfoToJson(this);
// }
