/*import 'dart:convert';
import '../Controller/request_controller.dart';
import 'dart:typed_data';

class AppUser {
  int? appUserId;
  String? username;
  String? email;
  String? password;
  String? dateOfBirth;
  String? phoneNumber;
  String? accessStatus;
  int? roleId;
  String? profilePicture;

  AppUser(
      this.appUserId,
      this.username,
      this.email,
      this.password,
      this.dateOfBirth,
      this.phoneNumber,
      this.accessStatus,
      this.roleId,
      this.profilePicture,
      );

  AppUser.getId(this.email);

  AppUser.resetPassword(this.appUserId, this.password);

  AppUser.empty()
      : appUserId = 0,
        username = '',
        email = '',
        password = '',
        dateOfBirth = '',
        phoneNumber = '',
        accessStatus = '',
        roleId = 0,
        profilePicture = null;

  AppUser.fromJson(Map<String, dynamic> json)
      : appUserId = json['appUserId'] as int?,
        username = json['username'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        dateOfBirth = json['dateOfBirth'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        accessStatus = json['accessStatus'] as String?,
        roleId = json['roleId'] as int?,
        profilePicture = json['profilePicture'] as String?; // Included roleId in fromJson

  Map<String, dynamic> toJson() => {
    'appUserId': appUserId,
    'username': username,
    'email': email,
    'password': password,
    'dateOfBirth': dateOfBirth,
    'phoneNumber': phoneNumber,
    'accessStatus': accessStatus,
    'roleId': roleId,
    'profilePicture': profilePicture,
  };

  Future<bool> save() async {
    RequestController req = RequestController(path: "/api/appuser.php");
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

  Future<bool> checkUserExistence() async {
    RequestController req = RequestController(path: "/api/appUserCheckExistence.php");
    req.setBody(toJson());
    await req.post();
    print('Json Data: ${req.result()}');
    if (req.status() == 200)  {
      Map<String, dynamic> result = req.result();

      // Ensure that the fields are converted to the expected types
      appUserId = int.parse(result['appUserId'].toString());
      roleId = int.parse(result['roleId'].toString());
      username = result['accessStatus'].toString();
      email = result['email'].toString();
      password = result['password'].toString();
      dateOfBirth = result['dateOfBirth'].toString();
      phoneNumber = result['phoneNumber'].toString();
      accessStatus = result['accessStatus'].toString();
      profilePicture = result['profilePicture']?.toString();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetPassword() async {
    RequestController req = RequestController(path: "/api/getAppUserId.php");
    req.setBody({"appUserId": appUserId, "password": password });
    await req.put();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getUserId() async {
    RequestController req = RequestController(path: "/api/getAppUserId.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      appUserId=req.result()['appUserId'];
      print(appUserId);
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> updateProfile(Uint8List? newProfilePicture) async {
    RequestController req = RequestController(path: "/api/updateprofile.php");

    // Encode the profile picture as base64 if it's not null
    String? base64ProfilePicture;
    if (newProfilePicture != null) {
      base64ProfilePicture = base64Encode(newProfilePicture);
    }

    req.setBody({
      "appUserId": appUserId,
      "username": username,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
      "profilePicture": base64ProfilePicture, // Add the profile picture if not null
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
}*/

import 'dart:convert';
import 'dart:typed_data';
import '../Controller/request_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppUser {
  int? appUserId;
  String? username;
  String? email;
  String? password;
  String? dateOfBirth;
  String? phoneNumber;
  String? accessStatus;
  int? roleId;

  AppUser({
    this.appUserId,
    this.username,
    this.email,
    this.password,
    this.dateOfBirth,
    this.phoneNumber,
    this.accessStatus,
    this.roleId,
  });


  AppUser.getId(this.email);

  AppUser.resetPassword(this.appUserId, this.password);

  AppUser.fromJson(Map<String, dynamic> json)
      : appUserId = json['appUserId'] as int?,
        username = json['username'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        dateOfBirth = json['dateOfBirth'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        accessStatus = json['accessStatus'] as String?,
        roleId = json['roleId'] as int?;

  Map<String, dynamic> toJson() => {
    'appUserId': appUserId,
    'username': username,
    'email': email,
    'password': password,
    'dateOfBirth': dateOfBirth,
    'phoneNumber': phoneNumber,
    'accessStatus': accessStatus,
    'roleId': roleId,
  };

  Future<bool> checkUserExistence() async {
    if (email == null || email!.isEmpty) {
      print("Error: Email is not set");
      return false;
    }

    RequestController req = RequestController(path: "/api/appUserCheckExistence.php");
    req.setBody({"email": email, "password": password});
    await req.post();
    print('Json Data: ${req.result()}');
    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();

      appUserId = int.parse(result['appUserId'].toString());
      roleId = int.parse(result['roleId'].toString());
      username = result['username'].toString();
      email = result['email'].toString();
      password = result['password'].toString();
      dateOfBirth = result['dateOfBirth'].toString();
      phoneNumber = result['phoneNumber'].toString();
      accessStatus = result['accessStatus'].toString();

      return true;
    } else {
      return false;
    }
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('userEmail') ?? '';
    if (userEmail == null || userEmail!.isEmpty) {
      print("Error: Email is not set");
      return null;
    }

    RequestController req = RequestController(path: "/api/getAppUserId.php");
    req.setBody({"email": userEmail});
    await req.post();

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      if (result.containsKey('appUserId')) {
        appUserId = result['appUserId'];
        print("Fetched appUserId: $appUserId");
        return appUserId;
      } else {
        print("appUserId not found in response");
        return null;
      }
    } else {
      print("Failed to fetch userId, status code: ${req.status()}");
      return null;
    }
  }


  Future<bool> resetPassword() async {
    RequestController req = RequestController(path: "/api/getAppUserId.php");
    req.setBody({"appUserId": appUserId, "password": password });
    await req.put();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> save() async {
    RequestController req = RequestController(path: "/api/appuser.php");
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

  Future<bool> updateProfile() async {
    RequestController req = RequestController(path: "/api/updateprofile.php");
    req.setBody({"appUserId": appUserId, "username": username,
      "phoneNumber": phoneNumber, "email": email, "password": password });
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


