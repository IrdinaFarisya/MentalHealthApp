import 'dart:convert';
import 'dart:typed_data';

import '../Controller/request_controller.dart';

class appUserImage {

  int? imageId;
  String? image;
  int? appUserId;

  appUserImage(
      this.imageId,
      this.image,
      this.appUserId
      );

  appUserImage.forImage(
      this.imageId,
      this.image
      );


  appUserImage.fromJson(Map<String, dynamic> json)
      : imageId = json['imageId'] as dynamic,
        image = json['image'] as String,
        appUserId = json['appUserId'] as dynamic;

  // toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'imageId': imageId,
    'image': image,
    'appUserId': appUserId,
  };


}