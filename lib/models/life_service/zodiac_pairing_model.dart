class ZodiacPairingModel {
  String? men;
  String? women;
  String? data;
  ZodiacPairingModel({this.men, this.women, this.data});
  ZodiacPairingModel.fromJson(Map<String, dynamic> json) {
    men = json['men'];
    women = json['women'];
    data = json['data'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['men'] = this.men;
    data['women'] = this.women;
    data['data'] = this.data;
    return data;
  }
}