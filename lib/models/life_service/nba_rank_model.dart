class NBARankModel {
  String? title;
  String? duration;
  List<Ranking>? ranking;

  NBARankModel({this.title, this.duration, this.ranking});

  NBARankModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    duration = json['duration'];
    if (json['ranking'] != null) {
      ranking = [];
      json['ranking'].forEach((v) {
        ranking!.add(new Ranking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['duration'] = this.duration;
    if (this.ranking != null) {
      data['ranking'] = this.ranking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ranking {
  String? name;
  String? type;
  List<Rank>? list;

  Ranking({this.name, this.type, this.list});

  Ranking.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new Rank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rank {
  String? rankId;
  String? team;
  String? wins;
  String? losses;
  String? winsRate;
  String? avgScore;
  String? avgLoseScore;

  Rank(
      {this.rankId,
        this.team,
        this.wins,
        this.losses,
        this.winsRate,
        this.avgScore,
        this.avgLoseScore});

  Rank.fromJson(Map<String, dynamic> json) {
    rankId = json['rank_id'];
    team = json['team'];
    wins = json['wins'];
    losses = json['losses'];
    winsRate = json['wins_rate'];
    avgScore = json['avg_score'];
    avgLoseScore = json['avg_lose_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank_id'] = this.rankId;
    data['team'] = this.team;
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['wins_rate'] = this.winsRate;
    data['avg_score'] = this.avgScore;
    data['avg_lose_score'] = this.avgLoseScore;
    return data;
  }
}