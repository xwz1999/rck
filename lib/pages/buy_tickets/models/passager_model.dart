class PassagerModel {
  int id;
  int userId;
  String name;
  String residentIdCard;
  String phone;
  int isDefault;

  PassagerModel(
      {this.id,
      this.userId,
      this.name,
      this.residentIdCard,
      this.phone,
      this.isDefault});

  PassagerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    residentIdCard = json['resident_id_card'];
    phone = json['phone'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['resident_id_card'] = this.residentIdCard;
    data['phone'] = this.phone;
    data['is_default'] = this.isDefault;
    return data;
  }
}
