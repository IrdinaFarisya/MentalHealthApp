import '../Controller/request_controller.dart';

class Admin {
  int? adminId;
  String? email;
  String? password;
  int? roleId; // Added roleId field

  Admin(
      this.adminId,
      this.email,
      this.password,
      this.roleId, // Included roleId in the constructor
      );

  Admin.getId(
      this.email,
      );

  Admin.fromJson(Map<String, dynamic> json)
      : adminId = json['adminId'] as int,
        email = json['email'] as String,
        password = json['password'] as String,
        roleId = json['roleId'] as int; // Included roleId in fromJson

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'adminId': adminId,
    'email': email,
    'password': password,
    'roleId': roleId, // Included roleId in toJson
  };

  Future<bool> save() async {
    RequestController req = RequestController(path: "/api/admin.php");
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

  Future<bool> checkAdminExistence() async {
    RequestController req =
    RequestController(path: "/api/adminCheckExistence.php");
    req.setBody(toJson());
    await req.post();
    print('Json Data: ${req.result()}');
    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();

      // Ensure that the fields are converted to the expected types
      adminId = int.parse(result['adminId'].toString());

      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetPassword() async {
    RequestController req = RequestController(path: "/api/getAdminId.php");
    req.setBody({"adminId": adminId, "password": password});
    await req.put();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getAdminId() async {
    RequestController req = RequestController(path: "/api/getAdminId.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      adminId = req.result()['adminId'];
      print(adminId);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfile() async {
    RequestController req =
    RequestController(path: "/api/updateAdminProfile.php");
    req.setBody({
      "adminId": adminId,
      "email": email,
      "password": password,
      "roleId": roleId, // Include roleId in the request body
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