class HwCalculatorModel {
  double? idealWeight;
  String? normalWeight;
  int? level;
  String? levelMsg;
  String? danger;
  double? bmi;
  String? normalBMI;

  HwCalculatorModel(
      {this.idealWeight,
        this.normalWeight,
        this.level,
        this.levelMsg,
        this.danger,
        this.bmi,
        this.normalBMI});

  HwCalculatorModel.fromJson(Map<String, dynamic> json) {
    idealWeight = json['idealWeight'];
    normalWeight = json['normalWeight'];
    level = json['level'];
    levelMsg = json['levelMsg'];
    danger = json['danger'];
    bmi = json['bmi'];
    normalBMI = json['normalBMI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idealWeight'] = this.idealWeight;
    data['normalWeight'] = this.normalWeight;
    data['level'] = this.level;
    data['levelMsg'] = this.levelMsg;
    data['danger'] = this.danger;
    data['bmi'] = this.bmi;
    data['normalBMI'] = this.normalBMI;
    return data;
  }
}