class BirthFlowerModel {
  String? title;
  String? birthday;
  String? name;
  String? nameDes;
  String? lang;
  String? langDes;
  String? stone;
  String? stoneDes;
  String? legend;

  BirthFlowerModel(
      {this.title,
        this.birthday,
        this.name,
        this.nameDes,
        this.lang,
        this.langDes,
        this.stone,
        this.stoneDes,
        this.legend});

  BirthFlowerModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    birthday = json['birthday'];
    name = json['name'];
    nameDes = json['name_des'];
    lang = json['lang'];
    langDes = json['lang_des'];
    stone = json['stone'];
    stoneDes = json['stone_des'];
    legend = json['legend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['birthday'] = this.birthday;
    data['name'] = this.name;
    data['name_des'] = this.nameDes;
    data['lang'] = this.lang;
    data['lang_des'] = this.langDes;
    data['stone'] = this.stone;
    data['stone_des'] = this.stoneDes;
    data['legend'] = this.legend;
    return data;
  }
}