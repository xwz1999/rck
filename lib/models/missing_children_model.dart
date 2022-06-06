class MissingChildrenModel {
  int? iD;
  String? text;
  String? pic;
  bool? verify;
  String? createdAt;
  String? bID;

  MissingChildrenModel(
      {this.iD, this.text, this.pic, this.verify, this.createdAt, this.bID});

  MissingChildrenModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    text = json['Text'];
    pic = json['Pic'];
    verify = json['Verify'];
    createdAt = json['CreatedAt'];
    bID = json['BID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Text'] = this.text;
    data['Pic'] = this.pic;
    data['Verify'] = this.verify;
    data['CreatedAt'] = this.createdAt;
    data['BID'] = this.bID;
    return data;
  }
}