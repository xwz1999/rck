class NbaModel {
  String? title;
  String? duration;
  List<Matchs>? matchs;

  NbaModel({this.title, this.duration, this.matchs});

  NbaModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    duration = json['duration'];
    if (json['matchs'] != null) {
      matchs = [];
      json['matchs'].forEach((v) {
        matchs!.add(new Matchs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['duration'] = this.duration;
    if (this.matchs != null) {
      data['matchs'] = this.matchs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Matchs {
  String? date;
  String? week;
  List<Match>? list;

  Matchs({this.date, this.week, this.list});

  Matchs.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    week = json['week'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new Match.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['week'] = this.week;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Match {
  String? timeStart;
  String? status;
  String? statusText;
  String? team1;
  String? team2;
  String? team1Score;
  String? team2Score;

  Match(
      {this.timeStart,
        this.status,
        this.statusText,
        this.team1,
        this.team2,
        this.team1Score,
        this.team2Score});

  Match.fromJson(Map<String, dynamic> json) {
    timeStart = json['time_start'];
    status = json['status'];
    statusText = json['status_text'];
    team1 = json['team1'];
    team2 = json['team2'];
    team1Score = json['team1_score'];
    team2Score = json['team2_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_start'] = this.timeStart;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    data['team1'] = this.team1;
    data['team2'] = this.team2;
    data['team1_score'] = this.team1Score;
    data['team2_score'] = this.team2Score;
    return data;
  }
}