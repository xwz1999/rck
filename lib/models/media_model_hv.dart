
import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class MediaModelHv extends HiveObject {
  @HiveField(0)
  int? width;
  @HiveField(1)
  int? height;
  @HiveField(2)
  int? type;
  @HiveField(3)
  String? file;
  @HiveField(4)
  List<int> ? thumbData;

  MediaModelHv(
      {this.width,
      this.height,
      this.type,
      this.file,
      this.thumbData});
}

class MediaModelHvAdapter extends TypeAdapter<MediaModelHv> {
  @override
  final int typeId = 0;

  @override
  MediaModelHv read(BinaryReader reader) {
    return MediaModelHv(
      width: reader.read(),
      height: reader.read(),
      type: reader.read(),
      file: reader.read(),
      thumbData: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, MediaModelHv obj) {
    writer.write(obj.width);
    writer.write(obj.height);
    writer.write(obj.type);
    writer.write(obj.file);

    writer.write(obj.thumbData);
  }
}


