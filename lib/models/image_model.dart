

//part 'image_model.g.dart';

//@JsonSerializable()
class ImageModel {
  String url;
  int type;

  ImageModel(this.url, this.type); //
//  factory ImageModel.fromJson(Map<String, dynamic> json) =>
//      _$ImageModelFromJson(json);
//
//  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  static mockList() {
    return [
      ImageModel("https://img11.360buyimg.com/n1/s450x450_jfs/t1/18626/4/7286/236104/5c6a2667E904ea157/5428b1a085f0a6b6.jpg", 0),
      ImageModel("https://img14.360buyimg.com/n0/jfs/t23050/95/1753292354/178795/9c3c8abf/5b6948d1Nb3a5b6af.jpg", 1),
      ImageModel("https://img14.360buyimg.com/n0/jfs/t22726/144/1754992511/227394/930faa54/5b6948cdN29f4c651.jpg", 1),
      ImageModel("https://img14.360buyimg.com/n0/jfs/t25828/234/238640331/209205/596744f2/5b6948d5N5e238a43.jpg", 1),
    ];
  }
}
