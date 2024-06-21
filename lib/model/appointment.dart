import '../Controller/request_controller.dart';

class Appointment {
  int? appointmentId;
  int? appUserId;
  int? therapistId;
  String? appointmentDate;
  String? appointmentTime;
  int? status;
  String? appointmentLink;

  Appointment({
    this.appointmentId,
    this.appUserId,
    this.therapistId,
    this.appointmentDate,
    this.appointmentTime,
    this.status,
    this.appointmentLink,
  });

  Appointment.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointmentId'],
        appUserId = json['appUserId'],
        therapistId = json['therapistId'],
        appointmentDate = json['appointmentDate'],
        appointmentTime = json['appointmentTime'],
        status = json['status'],
        appointmentLink = json['appointmentLink'];

  Map<String, dynamic> toJson() => {
    'appointmentId': appointmentId,
    'appUserId': appUserId,
    'therapistId': therapistId,
    'appointmentDate': appointmentDate,
    'appointmentTime': appointmentTime,
    'status': status,
    'appointmentLink': appointmentLink,
  };

  Future<bool> saveAppointment() async {
    RequestController req =
    RequestController(path: "/api/appointment.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      // Handle successful appointment creation
      return true;
    } else {
      // Handle other cases
      return false;
    }
  }

  static Future<List<Appointment>> loadAppointment() async {
    List<Appointment> result = [];
    RequestController req = RequestController(path: "/api/bookingAppointment.php");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      List<dynamic> responseData = req.result();
      if (responseData.isNotEmpty) {
      print(loadAppointment());
      } else {
        print('Response data is empty.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }
}
