class GoodsDTO {
  int? skuId;
  int? quantity;

  GoodsDTO({
    this.skuId,
    this.quantity,
  });

  GoodsDTO.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_id'] = this.skuId;
    data['quantity'] = this.quantity;
    return data;
  }
}
