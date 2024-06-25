import '../Controller/request_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/model/therapist.dart';
import 'package:mentalhealthapp/model/appUser.dart';

class Appointment {
  int? appointmentId;
  int? appUserId;
  int? therapistId;
  String? appointmentDate;
  String? appointmentTime;
  String? status;
  String? appointmentLink;
  String? username;  
  String? name;

  Appointment({
    this.appointmentId,
    this.appUserId,
    this.therapistId,
    this.appointmentDate,
    this.appointmentTime,
    this.status,
    this.appointmentLink,
    this.username,
    this.name,
  });

  Appointment.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointmentId'],
        appUserId = json['appUserId'],
        therapistId = json['therapistId'],
        appointmentDate = json['appointmentDate'],
        appointmentTime = json['appointmentTime'],
        status = json['status'],
        appointmentLink = json['appointmentLink'],
        username = json['username'],
        name = json['name'];


  Map<String, dynamic> toJson() => {
    'appointmentId': appointmentId,
    'appUserId': appUserId,
    'therapistId': therapistId,
    'appointmentDate': appointmentDate,
    'appointmentTime': appointmentTime,
    'status': status,
    'appointmentLink': appointmentLink,
    'username': username,
    'name': name,
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

    // Create a Therapist instance to use getTherapistId
    Therapist therapist = Therapist();
    int? therapistId = await therapist.getTherapistId();

    if (therapistId == null) {
      print('Error: Therapist ID not found');
      return result;
    }

    RequestController req = RequestController(path: "/api/bookingAppointment.php?therapistId=$therapistId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      List<dynamic> responseData = req.result();
      if (responseData.isNotEmpty) {
        result = responseData.map((json) => Appointment.fromJson(json)).toList();
      } else {
        print('Response data is empty.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }

  static Future<List<Appointment>> fetchAcceptedAppointments() async {
    List<Appointment> result = [];

    Therapist therapist = Therapist();
    int? therapistId = await therapist.getTherapistId();

    if (therapistId == null) {
      print('Error: Therapist ID not found');
      return result;
    }

    RequestController req = RequestController(path: "/api/fetchAcceptedAppointment.php?therapistId=$therapistId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      Map<String, dynamic> responseData = req.result();
      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> appointmentsData = responseData['data'];
        result = appointmentsData.map((json) => Appointment.fromJson(json)).toList();
      } else {
        print('Response data is not in the expected format.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }

  static Future<List<Appointment>> fetchUserAcceptedAppointments() async {
    List<Appointment> result = [];

    AppUser appUser = AppUser();
    int? appUserId = await appUser.getUserId();

    if (appUserId == null) {
      print('Error: AppUser ID not found');
      return result;
    }

    RequestController req = RequestController(path: "/api/fetchUserAcceptedAppointment.php?appUserId=$appUserId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      Map<String, dynamic> responseData = req.result();
      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> appointmentsData = responseData['data'];
        result = appointmentsData.map((json) => Appointment.fromJson(json)).toList();
      } else {
        print('Response data is not in the expected format.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }
}