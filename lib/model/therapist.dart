import 'dart:convert';
import 'dart:typed_data';
import '../Controller/request_controller.dart';
import 'package:mentalhealthapp/model/therapistImage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Therapist {
  int? therapistId;
  String? name;
  String? email;
  String? password;
  String? specialization;
  String? availability;
  String? location;
  String? accessStatus;
  therapistImage? TherapistImage;
  Uint8List? supportingDocument;  // New field for supporting document
  String? approvalStatus;


  Therapist({
    this.therapistId,
    this.name,
    this.email,
    this.password,
    this.specialization,
    this.availability,
    this.location,
    this.accessStatus,
    this.TherapistImage,
    this.supportingDocument,  // Added to constructor
    this.approvalStatus,

  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      therapistId: json['therapistId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      specialization: json['specialization'],
      availability: json['availability'],
      location: json['location'],
      accessStatus: json['accessStatus'],
      TherapistImage: json['therapistImage'] != null
          ? therapistImage.fromJson(json['therapistImage'])
          : null,
      supportingDocument: json['supportingDocument'] != null
          ? base64Decode(json['supportingDocument'])
          : null,  // Decode the base64 string to Uint8List
      approvalStatus: json['approvalStatus'],

    );
  }

  Map<String, dynamic> toJson() => {
    'therapistId': therapistId,
    'name': name,
    'email': email,
    'password': password,
    'specialization': specialization,
    'availability': availability,
    'location': location,
    'accessStatus': accessStatus,
    'supportingDocument': supportingDocument != null
        ? base64Encode(supportingDocument!)
        : null,
    'approvalStatus': approvalStatus,

  };

  Future<bool> saveTherapist() async {
    RequestController req = RequestController(path: "/api/therapist.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      String data = req.result().toString();
      if (data.contains('Email is already registered')) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> checkTherapistExistence() async {
    RequestController req = RequestController(path: "/api/TherapistCheckExistence.php");
    req.setBody(toJson());
    await req.post();
    print('Json Data: ${req.result()}');

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();

      therapistId = int.parse(result['therapistId'].toString());
      name = result['name'].toString();
      email = result['email'].toString();
      password = result['password'].toString();
      specialization = result['specialization'].toString();
      availability = result['availability'].toString();
      location = result['location'].toString();
      accessStatus = result['accessStatus'].toString();
      approvalStatus = result['approvalStatus'].toString();

      return true;
    } else if (req.status() == 403) {
      // Handle pending or rejected status
      approvalStatus = 'PENDING'; // or 'REJECTED', depending on the response
      return true; // Return true because the account exists, even if not approved
    } else {
      return false;
    }
  }

  Future<bool> resetPassword() async {
    RequestController req = RequestController(path: "/api/resetPassword.php");
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

  Future<bool> getTherapistName(int therapistId) async {
    RequestController req = RequestController(path: "/api/getTherapistName.php");
    req.setBody({"therapistId": therapistId});
    await req.post();
    if (req.status() == 200) {
      name = req.result()['TherapistName'];
      print(name);
      return true;
    } else {
      return false;
    }
  }


  Future<bool> updateProfile(Uint8List? newProfilePicture, Uint8List? newSupportingDocument) async {
    RequestController req = RequestController(path: "/api/updateTherapistProfile.php");

    String? base64ProfilePicture;
    if (newProfilePicture != null) {
      base64ProfilePicture = base64Encode(newProfilePicture);
    }

    String? base64SupportingDocument;
    if (newSupportingDocument != null) {
      base64SupportingDocument = base64Encode(newSupportingDocument);
    }

    req.setBody({
      "therapistId": therapistId,
      "name": name,
      "email": email,
      "password": password,
      "specialization": specialization,
      "availability": availability,
      "location": location,
      "profilePicture": base64ProfilePicture,
      "supportingDocument": base64SupportingDocument,
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

  // Updated static method to load images
  static Future<List<Therapist>> loadImagesStatic() async {
    List<Therapist> result = [];

    RequestController req = RequestController(path: "/api/getTherapistImages.php");
    req.setBody({});
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(Therapist.fromJson(item));
        print("Result Have Been Added");
      }
    } else {
      print('Failed to fetch data');
    }
    return result;
  }

  static Future<List<Therapist>> fetchTherapist() async {
    List<Therapist> result = [];
    RequestController req = RequestController(path: "/api/therapist.php");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      List<dynamic> responseData = req.result();
      if (responseData.isNotEmpty) {
        result = responseData.map((json) => Therapist.fromJson(json)).toList();
      } else {
        print('Response data is empty.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }

  Future<int?> getTherapistId() async {
    final prefs = await SharedPreferences.getInstance();
    String therapistEmail = prefs.getString('therapistEmail') ?? '';
    if (therapistEmail == null || therapistEmail!.isEmpty) {
      print("Error: Email is not set");
      return null;
    }

    RequestController req = RequestController(path: "/api/getTherapistId.php");
    req.setBody({"email": therapistEmail});
    await req.post();

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      if (result.containsKey('therapistId')) {
        therapistId = result['therapistId'];
        print("Fetched therapistId: $therapistId");
        return therapistId;
      } else {
        print("therapistId not found in response");
        return null;
      }
    } else {
      print("Failed to fetch therapistId, status code: ${req.status()}");
      return null;
    }
  }

  static Future<List<Therapist>> fetchPendingTherapists() async {
    List<Therapist> result = [];
    RequestController req = RequestController(path: "/api/pendingTherapists.php");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      List<dynamic> responseData = req.result();
      result = responseData.map((json) => Therapist.fromJson(json)).toList();
    }

    return result;
  }

  Future<bool> approveTherapist() async {
    RequestController req = RequestController(path: "/api/approveTherapist.php");
    req.setBody({"therapistId": therapistId});
    await req.put();
    return req.status() == 200;
  }

}

