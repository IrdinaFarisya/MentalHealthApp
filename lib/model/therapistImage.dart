import 'dart:convert';
import 'dart:typed_data';

class TherapistImage {

  int? imageId;
  String? image; // Base64-encoded image
  int? therapistId;

  TherapistImage(this.imageId, this.image, this.therapistId);

  // Constructor for creating an instance from an image only
  TherapistImage.forImage(this.imageId, this.image);

  // Factory constructor for creating an instance from JSON
  factory TherapistImage.fromJson(Map<String, dynamic> json) => TherapistImage(
    json['imageId'] as int?,
    json['image'] as String?,
    json['therapistId'] as int?,
  );

  // Convert the instance to JSON
  Map<String, dynamic> toJson() => {
    'imageId': imageId,
    'image': image,
    'therapistId': therapistId,
  };
}
