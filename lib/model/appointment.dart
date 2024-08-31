import '../Controller/request_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/model/therapist.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:http/http.dart' as http;

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
  String? consultationDescription;


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
    this.consultationDescription,

  });

  Appointment.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointmentId'] != null ? int.parse(json['appointmentId'].toString()) : null,
        appUserId = json['appUserId'] != null ? int.parse(json['appUserId'].toString()) : null,
        therapistId = json['therapistId'] != null ? int.parse(json['therapistId'].toString()) : null,
        appointmentDate = json['appointmentDate'],
        appointmentTime = json['appointmentTime'],
        status = json['status'],
        appointmentLink = json['appointmentLink'],
        username = json['username'],
        name = json['name'],
        consultationDescription = json['consultationDescription'];



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
    'consultationDescription': consultationDescription,

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
        // Filter appointments to include only 'ACCEPTED' and 'DONE' statuses
        result = result.where((appointment) =>
        appointment.status == 'ACCEPTED' || appointment.status == 'DONE').toList();
      } else {
        print('Response data is not in the expected format.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }

  static Future<List<Appointment>> fetchDoneAppointment() async {
    List<Appointment> result = [];

    AppUser appUser = AppUser();
    int? appUserId = await appUser.getUserId();

    if (appUserId == null) {
      print('Error: AppUser ID not found');
      return result;
    }

    RequestController req = RequestController(
        path: "/api/fetchDoneAppointment.php?appUserId=$appUserId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      Map<String, dynamic> responseData = req.result();
      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> appointmentsData = responseData['data'];
        result =
            appointmentsData.map((json) => Appointment.fromJson(json)).toList();
        // Filter appointments to include only 'ACCEPTED' and 'DONE' statuses
        result = result.where((appointment) =>
        appointment.status == 'DONE').toList();
      } else {
        print('Response data is not in the expected format.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }

  static Future<List<Appointment>> fetchPendingAppointment() async {
    List<Appointment> result = [];

    AppUser appUser = AppUser();
    int? appUserId = await appUser.getUserId();

    if (appUserId == null) {
      print('Error: AppUser ID not found');
      return result;
    }

    print('Fetching pending appointments for appUserId: $appUserId'); // Debug log

    RequestController req = RequestController(
        path: "/api/fetchPendingAppointment.php?appUserId=$appUserId");
    await req.get();

    print('Request status: ${req.status()}'); // Debug log
    print('Request result: ${req.result()}'); // Debug log

    if (req.status() == 200 && req.result() != null) {
      Map<String, dynamic> responseData = req.result();
      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> appointmentsData = responseData['data'];
        result =
            appointmentsData.map((json) => Appointment.fromJson(json)).toList();
        // Filter appointments to include only 'PENDING' statuses
        result = result.where((appointment) =>
        appointment.status == 'PENDING').toList();

        print('Fetched ${result.length} pending appointments'); // Debug log
      } else {
        print('Response data is not in the expected format.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }

  static Future<List<Appointment>> therapistDoneAppointment() async {
    List<Appointment> result = [];

    Therapist therapist = Therapist();
    int? therapistId = await therapist.getTherapistId();

    if (therapistId == null) {
      print('Error: Therapist ID not found');
      return result;
    }

    RequestController req = RequestController(
        path: "/api/therapistDoneAppointment.php?therapistId=$therapistId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      Map<String, dynamic> responseData = req.result();
      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> appointmentsData = responseData['data'];
        result =
            appointmentsData.map((json) => Appointment.fromJson(json)).toList();
        // Filter appointments to include only 'ACCEPTED' and 'DONE' statuses
        result = result.where((appointment) =>
        appointment.status == 'DONE').toList();
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