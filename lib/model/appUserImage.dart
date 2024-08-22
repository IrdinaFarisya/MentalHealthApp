import 'dart:convert';
import 'dart:typed_data';

class AppUserImage {

  int? imageId;
  String? image; // Base64-encoded image
  int? appUserId;

  AppUserImage(this.imageId, this.image, this.appUserId);

  // Constructor for creating an instance from an image only
  AppUserImage.forImage(this.imageId, this.image);

  // Factory constructor for creating an instance from JSON
  factory AppUserImage.fromJson(Map<String, dynamic> json) => AppUserImage(
    json['imageId'] as int?,
    json['image'] as String?,
    json['appUserId'] as int?,
  );

  // Convert the instance to JSON
  Map<String, dynamic> toJson() => {
    'imageId': imageId,
    'image': image,
    'appUserId': appUserId,
  };
}
