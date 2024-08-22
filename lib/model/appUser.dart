import 'dart:convert';
import 'dart:typed_data';
import '../Controller/request_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/model/appUserImage.dart';

class AppUser {
  int? appUserId;
  String? username;
  String? email;
  String? password;
  String? dateOfBirth;
  String? phoneNumber;
  String? accessStatus;
  String? lastError;

  AppUser({
    this.appUserId,
    this.username,
    this.email,
    this.password,
    this.dateOfBirth,
    this.phoneNumber,
    this.accessStatus,
  });

  AppUser.fromJson(Map<String, dynamic> json)
      : appUserId = int.tryParse(json['appUserId'].toString()),
        username = json['username'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        dateOfBirth = json['dateOfBirth'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        accessStatus = json['accessStatus'] as String?;

  Map<String, dynamic> toJson() => {
    'appUserId': appUserId,
    'username': username,
    'email': email,
    'password': password,
    'dateOfBirth': dateOfBirth,
    'phoneNumber': phoneNumber,
    'accessStatus': accessStatus,
  };

  Future<bool> checkUserExistence() async {
    if (email == null || email!.isEmpty) {
      print("Error: Email is not set");
      return false;
    }

    RequestController req = RequestController(path: "/api/appUserCheckExistence.php");
    req.setBody({"email": email, "password": password});
    await req.post();
    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();

      appUserId = int.tryParse(result['appUserId'].toString());
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
    String? userEmail = prefs.getString('userEmail');
    if (userEmail == null || userEmail.isEmpty) {
      print("Error: Email is not set");
      return null;
    }

    RequestController req = RequestController(path: "/api/getAppUserId.php");
    req.setBody({"email": userEmail});
    await req.post();

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      if (result.containsKey('appUserId')) {
        appUserId = int.tryParse(result['appUserId'].toString());
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
    if (appUserId == null || password == null) {
      print("Error: AppUserId or password is not set");
      return false;
    }

    RequestController req = RequestController(path: "/api/resetPassword.php");
    req.setBody({"appUserId": appUserId, "password": password});
    await req.put();
    return req.status() == 200;
  }

  Future<bool> save() async {
    RequestController req = RequestController(path: "/api/appuser.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      return true;
    } else {
      lastError = req.result().toString();
      return false;
    }
  }

  Future<bool> updateProfile() async {
    if (appUserId == null) {
      print("Error: AppUserId is not set");
      return false;
    }

    Map<String, dynamic> body = {
      'appUserId': appUserId,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    };

    // Only include password if it's not null or empty
    if (password != null && password!.isNotEmpty) {
      body['password'] = password;
    }

    RequestController req = RequestController(path: "/api/updateProfile.php");
    req.setBody(body);
    await req.put();

    if (req.status() == 200) {
      return true;
    } else {
      print("Update failed: ${req.result()}");
      return false;
    }
  }

  Future<List<AppUser>> fetchFullUserDetails() async {
    List<AppUser> result = [];

    int? appUserId = await getUserId();

    if (appUserId == null) {
      print('Error: AppUser ID not found');
      return result;
    }

    RequestController req = RequestController(path: "/api/fetchFullUserDetails.php?appUserId=$appUserId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      var responseData = req.result();

      if (responseData is Map<String, dynamic>) {
        var data = responseData['data'];
        if (data is List) {
          result = data.map((json) => AppUser.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic>) {
          // Handle the case where 'data' is a single object
          result = [AppUser.fromJson(data)];
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Response is not a Map<String, dynamic>: $responseData');
      }
    } else {
      print('Failed to fetch data.');
    }

    return result;
  }

  Future<bool> saveProfilePicture(AppUserImage userImage) async {
    RequestController req = RequestController(path: "/api/saveUserImage.php");
    req.setBody(userImage.toJson());

    await req.post();

    if (req.status() == 200) {
      print("Profile picture saved successfully");
      return true;
    } else {
      print("Failed to save profile picture: ${req.result()}");
      return false;
    }
  }

  Future<String?> getProfilePicture() async {
    if (appUserId == null) {
      print("Error: AppUserId is not set");
      return null;
    }

    RequestController req = RequestController(path: "/api/getUserImage.php?appUserId=$appUserId");
    await req.get(); // Changed from post() to get()

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      if (result.containsKey('image')) {
        return result['image'] as String?;
      } else {
        print("No profile picture found.");
        return null;
      }
    } else {
      print("Failed to fetch profile picture: ${req.result()}");
      return null;
    }
  }

}
