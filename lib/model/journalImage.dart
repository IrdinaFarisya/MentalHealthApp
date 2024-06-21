import 'dart:convert';
import 'dart:typed_data';

import '../Controller/request_controller.dart';

class journalImage {

  int? imageId;
  String? image;
  int? entryId;

  journalImage(
      this.imageId,
      this.image,
      this.entryId
      );

  journalImage.forImage(
      this.imageId,
      this.image
      );


  journalImage.fromJson(Map<String, dynamic> json)
      : imageId = json['imageId'] as dynamic,
        image = json['image'] as String,
        entryId = json['entryId'] as dynamic;

  // toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'imageId': imageId,
    'image': image,
    'appUserId': entryId,
  };
}