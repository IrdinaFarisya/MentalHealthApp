import '../Controller/request_controller.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    // Check login credentials against the AppUser table
    bool userAuthenticated = await loginUser(email, password, "/api/appUserLogin.php");
    if (userAuthenticated) {
      // User logged in successfully as AppUser
      return true;
    }

    // Check login credentials against the Admin table
    bool adminAuthenticated = await loginUser(email, password, "/api/adminLogin.php");
    if (adminAuthenticated) {
      // User logged in successfully as Admin
      return true;
    }

    // Check login credentials against the Therapist table
    bool therapistAuthenticated = await loginUser(email, password, "/api/therapistLogin.php");
    if (therapistAuthenticated) {
      // User logged in successfully as Therapist
      return true;
    }

    // If none of the login attempts were successful, return false
    return false;
  }

  Future<bool> loginUser(String email, String password, String endpoint) async {
    RequestController req = RequestController(path: endpoint);
    req.setBody({"email": email, "password": password});
    await req.post();
    if (req.status() == 200) {
      // Authentication successful
      return true;
    } else {
      // Authentication failed
      return false;
    }
  }
}
