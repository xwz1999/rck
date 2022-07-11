class FootRankModel {
  String? title;
  String? duration;
  List<FRanking>? ranking;

  FootRankModel({this.title, this.duration, this.ranking});

  FootRankModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    duration = json['duration'];
    if (json['ranking'] != null) {
      ranking = [];
      json['ranking'].forEach((v) {
        ranking!.add(new FRanking.fromJson(v));
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

class FRanking {
  String? rankId;
  String? team;
  String? wins;
  String? losses;
  String? draw;
  String? goals;
  String? losingGoals;
  String? goalDifference;
  String? scores;

  FRanking(
      {this.rankId,
        this.team,
        this.wins,
        this.losses,
        this.draw,
        this.goals,
        this.losingGoals,
        this.goalDifference,
        this.scores});

  FRanking.fromJson(Map<String, dynamic> json) {
    rankId = json['rank_id'];
    team = json['team'];
    wins = json['wins'];
    losses = json['losses'];
    draw = json['draw'];
    goals = json['goals'];
    losingGoals = json['losing_goals'];
    goalDifference = json['goal_difference'];
    scores = json['scores'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank_id'] = this.rankId;
    data['team'] = this.team;
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['draw'] = this.draw;
    data['goals'] = this.goals;
    data['losing_goals'] = this.losingGoals;
    data['goal_difference'] = this.goalDifference;
    data['scores'] = this.scores;
    return data;
  }
}