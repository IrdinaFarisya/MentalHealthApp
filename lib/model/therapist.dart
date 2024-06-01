import 'dart:convert';

import '../Controller/request_controller.dart';
import 'dart:typed_data';

class Therapist {
  int? therapistId;
  String? name;
  String? email;
  String? password;
  String? specialization;
  String? availability;
  String? location;
  int? roleId;
  Uint8List? profilePicture;

  Therapist({
    this.therapistId,
    this.name,
    this.email,
    this.password,
    this.specialization,
    this.availability,
    this.location,
    this.roleId,
    this.profilePicture,
  });

  Therapist.fromJson(Map<String, dynamic> json)
      : therapistId = json['therapistId'] as int,
        name = json['name'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        specialization = json['specialization'] as String,
        availability = json['availability'] as String,
        location = json['location'] as String,
        roleId = json['roleId'] as int,
        profilePicture = base64.decode(json['profilePicture'] as String);

  Map<String, dynamic> toJson() => {
    'therapistId': therapistId,
    'name': name,
    'email': email,
    'password': password,
    'specialization': specialization,
    'availability': availability,
    'location': location,
    'roleId': roleId,
    'profilePicture': base64.encode(profilePicture!),
  };

  Future<bool> save() async {
    RequestController req = RequestController(path: "/api/therapist.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return true;
    } else if (req.status() == 200) {
      String data = req.result().toString();
      if (data == '{error: Email is already registered}') {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<bool> checkTherapistExistence() async {
    RequestController req =
    RequestController(path: "/api/therapistCheckExistence.php");
    req.setBody(toJson());
    await req.post();
    print('Json Data: ${req.result()}');
    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();

      // Ensure that the fields are converted to the expected types
      therapistId = int.parse(result['therapistId'].toString());

      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetPassword() async {
    RequestController req =
    RequestController(path: "/api/getTherapistId.php");
    req.setBody({"therapistId": therapistId, "password": password});
    await req.put();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getTherapistId() async {
    RequestController req =
    RequestController(path: "/api/getTherapistId.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      therapistId = req.result()['therapistId'];
      print(therapistId);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfile(Uint8List newProfilePicture) async {
    RequestController req =
    RequestController(path: "/api/updateTherapistProfile.php");

    // Encode the profile picture as base64
    String base64ProfilePicture = base64Encode(newProfilePicture);

    req.setBody({
      "therapistId": therapistId,
      "name": name,
      "email": email,
      "password": password,
      "specialization": specialization,
      "availability": availability,
      "location": location,
      "profilePicture": base64ProfilePicture
    });
    await req.put();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }
}
