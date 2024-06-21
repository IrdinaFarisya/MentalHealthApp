import 'dart:convert';
import 'dart:typed_data';

import '../Controller/request_controller.dart';

class therapistImage {

  int? imageId;
  String? image;
  int? therapistId;

  therapistImage(
      this.imageId,
      this.image,
      this.therapistId
      );

  therapistImage.forImage(
      this.imageId,
      this.image
      );


  therapistImage.fromJson(Map<String, dynamic> json)
      : imageId = json['imageId'] as dynamic,
        image = json['image'] as String,
        therapistId = json['therapistId'] as dynamic;

  // toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'imageId': imageId,
    'image': image,
    'therapistId': therapistId,
  };


}