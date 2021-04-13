import 'package:recook/pages/user/benefit_view_gen.dart';

class UserBenefitExpectExtraModel {
  Team team;
  Team recommend;
  Team reward;
  List<TeamList> teamList;
  List<TeamList> recommendList;
  List<TeamList> rewardList;

  UserBenefitExpectExtraModel(
      {this.team,
      this.recommend,
      this.reward,
      this.teamList,
      this.recommendList,
      this.rewardList});

  UserBenefitExpectExtraModel.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    recommend =
        json['recommend'] != null ? new Team.fromJson(json['recommend']) : null;
    reward = json['reward'] != null ? new Team.fromJson(json['reward']) : null;
    if (json['teamList'] != null) {
      teamList = [];
      json['teamList'].forEach((v) {
        teamList.add(new TeamList.fromJson(v));
      });
    }
    if (json['recommendList'] != null) {
      recommendList = [];
      json['recommendList'].forEach((v) {
        recommendList.add(new TeamList.fromJson(v));
      });
    }
    if (json['rewardList'] != null) {
      rewardList = [];
      json['rewardList'].forEach((v) {
        rewardList.add(new TeamList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.team != null) {
      data['team'] = this.team.toJson();
    }
    if (this.recommend != null) {
      data['recommend'] = this.recommend.toJson();
    }
    if (this.reward != null) {
      data['reward'] = this.reward.toJson();
    }
    if (this.teamList != null) {
      data['teamList'] = this.teamList.map((v) => v.toJson()).toList();
    }
    if (this.recommendList != null) {
      data['recommendList'] =
          this.recommendList.map((v) => v.toJson()).toList();
    }
    if (this.rewardList != null) {
      data['rewardList'] = this.rewardList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Team {
  num salesVolume;
  num amount;
  num ratio;
  DisplayCard get card => DisplayCard(
        count: ratio,
        sales: salesVolume,
        benefit: amount,
        isPercent: true,
      );

  Team({this.salesVolume, this.amount, this.ratio});

  Team.fromJson(Map<String, dynamic> json) {
    salesVolume = json['salesVolume'];
    amount = json['amount'];
    ratio = json['ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesVolume'] = this.salesVolume;
    data['amount'] = this.amount;
    data['ratio'] = this.ratio;
    return data;
  }
}

class TeamList {
  int userId;
  String headImgUrl;
  String nickname;
  String phone;
  String wechatNo;
  String remarkName;
  int count;
  num amount;
  int roleLevel;

  TeamList(
      {this.userId,
      this.headImgUrl,
      this.nickname,
      this.phone,
      this.wechatNo,
      this.remarkName,
      this.count,
      this.amount,
      this.roleLevel});

  TeamList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    headImgUrl = json['headImgUrl'];
    nickname = json['nickname'];
    phone = json['phone'];
    wechatNo = json['wechatNo'];
    remarkName = json['remarkName'];
    count = json['count'];
    amount = json['amount'];
    roleLevel = json['roleLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['headImgUrl'] = this.headImgUrl;
    data['nickname'] = this.nickname;
    data['phone'] = this.phone;
    data['wechatNo'] = this.wechatNo;
    data['remarkName'] = this.remarkName;
    data['count'] = this.count;
    data['amount'] = this.amount;
    data['roleLevel'] = this.roleLevel;
    return data;
  }
}
