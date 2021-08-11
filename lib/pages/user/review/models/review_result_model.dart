class ReviewResultModel {
  GoodsEva goodsEva;
  List<GoodsEvaGoods> goodsEvaGoods;

  ReviewResultModel({this.goodsEva, this.goodsEvaGoods});

  ReviewResultModel.fromJson(Map<String, dynamic> json) {
    goodsEva = json['goodsEva'] != null
        ? new GoodsEva.fromJson(json['goodsEva'])
        : null;
    if (json['goodsEvaGoods'] != null) {
      goodsEvaGoods = [];
      json['goodsEvaGoods'].forEach((v) {
        goodsEvaGoods.add(new GoodsEvaGoods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goodsEva != null) {
      data['goodsEva'] = this.goodsEva.toJson();
    }
    if (this.goodsEvaGoods != null) {
      data['goodsEvaGoods'] =
          this.goodsEvaGoods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoodsEva {
  int id;
  int goodsId;
  int userId;
  String nickname;
  String headImgUrl;
  String content;
  String createdAt;
  int pass;
  int compliance;

  GoodsEva({
    this.id,
    this.goodsId,
    this.userId,
    this.nickname,
    this.headImgUrl,
    this.content,
    this.createdAt,
    this.pass,
    this.compliance,
  });

  GoodsEva.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsId = json['goodsId'];
    userId = json['userId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    content = json['content'];
    createdAt = json['createdAt'];
    pass = json['pass'];
    compliance = json['compliance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsId'] = this.goodsId;
    data['userId'] = this.userId;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['pass'] = this.pass;
    data['compliance'] = this.compliance;
    return data;
  }
}

class GoodsEvaGoods {
  int id;
  String url;
  int width;
  int height;

  GoodsEvaGoods({this.id, this.url, this.width, this.height});

  GoodsEvaGoods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
