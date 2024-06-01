import '../Controller/request_controller.dart';

class TherapistRegistration {
  int? registrationId;
  int? therapistId;
  int? adminId;
  int? status;

  TherapistRegistration({
    this.registrationId,
    this.therapistId,
    this.adminId,
    this.status,
  });

  TherapistRegistration.fromJson(Map<String, dynamic> json)
      : registrationId = json['registrationId'],
        therapistId = json['therapistId'],
        adminId = json['adminId'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
    'registrationId': registrationId,
    'therapistId': therapistId,
    'adminId': adminId,
    'status': status,
  };

  Future<bool> saveRegistration() async {
    RequestController req =
    RequestController(path: "/api/therapist_registration.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      // Handle successful registration
      return true;
    } else {
      // Handle other cases
      return false;
    }
  }
}
