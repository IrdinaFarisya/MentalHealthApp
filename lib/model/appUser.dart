import 'dart:convert';
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
  Uint8List? profilePicture;

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

  AppUser.fromJson(Map<String, dynamic> json)
      : appUserId = json['appUserId'] as int,
        username = json['username'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        dateOfBirth = json['dateOfBirth'] as String,
        phoneNumber = json['phoneNumber'] as String,
        accessStatus = json['accessStatus'] as String,
        roleId = json['roleId'] as int,
        profilePicture = base64.decode(json['profilePicture'] as String); // Included roleId in fromJson

  Map<String, dynamic> toJson() => {
    'appUserId': appUserId,
    'username': username,
    'email': email,
    'password': password,
    'dateOfBirth': dateOfBirth,
    'phoneNumber': phoneNumber,
    'accessStatus': accessStatus,
    'roleId': roleId,
    'profilePicture': base64.encode(profilePicture!),
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

      username = result['username'].toString();
      email = result['email'].toString();
      password = result['password'].toString();
      dateOfBirth = result['dateOfBirth'].toString();
      phoneNumber = result['phoneNumber'].toString();
      accessStatus = result['accessStatus'].toString();
      roleId = int.parse(result['roleId'].toString());
      //profilePicture = base64.decode(result['profilePicture'].toString());
      if (result['profilePicture'] != null && result['profilePicture'].isNotEmpty) {
        profilePicture = base64.decode(result['profilePicture'].toString());
      }

      // Print debug statements to verify the values
      print('AppUserId: $appUserId');
      print('Username: $username');
      print('Email: $email');
      print('Password: $password');
      print('DateOfBirth: $dateOfBirth');
      print('PhoneNumber: $phoneNumber');
      print('AccessStatus: $accessStatus');
      print('RoleId: $roleId');
      print('ProfilePicture Length: ${profilePicture?.length}');

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

  Future<bool> updateProfile(Uint8List newProfilePicture) async {
    RequestController req = RequestController(path: "/api/updateprofile.php");

    // Encode the profile picture as base64
    String base64ProfilePicture = base64Encode(newProfilePicture);

    req.setBody({
      "appUserId": appUserId,
      "username": username,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
      "profilePicture": base64ProfilePicture, // Add the profile picture
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

