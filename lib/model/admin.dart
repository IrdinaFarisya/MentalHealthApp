import '../Controller/request_controller.dart';

class Admin {
  int? adminId;
  String? email;
  String? password;
  int? roleId;

  Admin(
      this.adminId,
      this.email,
      this.password,
      this.roleId,
      );

  Admin.empty()
      : adminId = 0,
        email = '',
        password = '',
        roleId = 0;

  Admin.getId(
      this.email,
      );

  Admin.fromJson(Map<String, dynamic> json)
      : adminId = json['adminId'] as int,
        email = json['email'] as String,
        password = json['password'] as String,
        roleId = json['roleId'] as int;

  Map<String, dynamic> toJson() => {
    'adminId': adminId,
    'email': email,
    'password': password,
    'roleId': roleId,
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

  Future<bool> checkAdminExistence(String email, String password) async {
    RequestController req = RequestController(path: "/api/appUserCheckExistence.php");
    Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };
    req.setBody(requestBody);
    await req.post();

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      adminId = int.parse(result['adminId'].toString());
      this.email = result['email'].toString();
      this.password = result['password'].toString();
      roleId = int.parse(result['roleId'].toString());

      print('Admin data: $result'); // Add this line for debugging

      return true;
    } else {
      print('Error: ${req.result()}'); // Add this line for debugging
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
    RequestController req = RequestController(path: "/api/updateAdminProfile.php");
    req.setBody({
      "adminId": adminId,
      "email": email,
      "password": password,
      "roleId": roleId,
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
