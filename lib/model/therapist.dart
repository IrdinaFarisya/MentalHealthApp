import 'dart:convert';
import 'dart:typed_data';
import '../Controller/request_controller.dart';
import 'package:mentalhealthapp/model/therapistImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/model/therapistImage.dart';

class Therapist {
  int? therapistId;
  String? name;
  String? email;
  String? password;
  String? specialization;
  String? availability;
  String? location;
  String? accessStatus;
  Uint8List? supportingDocument;  // New field for supporting document
  String? approvalStatus;


  Therapist({
    this.therapistId,
    this.name,
    this.email,
    this.password,
    this.specialization,
    this.availability,
    this.location,
    this.accessStatus,
    this.supportingDocument,  // Added to constructor
    this.approvalStatus,

  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    Uint8List? decodedDocument;
    if (json['supportingDocument'] != null) {
      try {
        decodedDocument = base64Decode(json['supportingDocument']);
        print('Successfully decoded supportingDocument. Length: ${decodedDocument.length}');
      } catch (e) {
        print('Error decoding supportingDocument: $e');
        print('Raw supportingDocument data: ${json['supportingDocument']}');
      }
    }

    return Therapist(
      therapistId: json['therapistId'] != null ? int.parse(json['therapistId'].toString()) : null,
      name: json['name'],
      email: json['email'],
      password: json['password'],
      specialization: json['specialization'],
      availability: json['availability'],
      location: json['location'],
      accessStatus: json['accessStatus'],
      supportingDocument: decodedDocument,
      approvalStatus: json['approvalStatus'],

    );
  }

  Map<String, dynamic> toJson() => {
    'therapistId': therapistId,
    'name': name,
    'email': email,
    'password': password,
    'specialization': specialization,
    'availability': availability,
    'location': location,
    'accessStatus': accessStatus,
    'supportingDocument': supportingDocument != null
        ? base64Encode(supportingDocument!)
        : null,
    'approvalStatus': approvalStatus,

  };

  Future<bool> saveTherapist() async {
    RequestController req = RequestController(path: "/api/therapist.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      print("Error: ${req.result()}");
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      print("Unexpected status code: ${req.status()}");
      return false;
    }
  }

  Future<bool> checkTherapistExistence() async {
    RequestController req = RequestController(path: "/api/TherapistCheckExistence.php");
    req.setBody(toJson());
    await req.post();
    print('Json Data: ${req.result()}');

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();

      therapistId = int.parse(result['therapistId'].toString());
      name = result['name'].toString();
      email = result['email'].toString();
      password = result['password'].toString();
      specialization = result['specialization'].toString();
      availability = result['availability'].toString();
      location = result['location'].toString();
      accessStatus = result['accessStatus'].toString();
      approvalStatus = result['approvalStatus'].toString();

      return true;
    } else if (req.status() == 403) {
      // Handle pending or rejected status
      approvalStatus = 'PENDING'; // or 'REJECTED', depending on the response
      return true; // Return true because the account exists, even if not approved
    } else {
      return false;
    }
  }

  Future<bool> resetPassword(int therapistId, String newPassword) async {
    RequestController req = RequestController(path: "/api/resetPasswordTherapist.php");
    req.setBody({"therapistId": therapistId, "password": newPassword});
    await req.put();
    print("Reset password response: ${req.result()}"); // Add this line for debugging
    return req.status() == 200;
  }

  Future<bool> sendResetConfirmation() async {
    if (email == null || email!.isEmpty) {
      print("Error: Email is not set");
      return false;
    }

    print("Sending reset confirmation to email: $email");

    try {
      RequestController req = RequestController(path: "/api/sendResetConfirmationTherapist.php");
      req.setBody({"email": email});
      await req.post();

      if (req.status() == 200) {
        print("Confirmation sent successfully");
        return true;
      } else {
        print("Failed to send confirmation: ${req.result()}");
        return false;
      }
    } catch (e) {
      print("Error sending confirmation: $e");
      return false;
    }
  }

  Future<bool> verifyResetCode(String code) async {
    if (email == null || email!.isEmpty) {
      print("Error: Email is not set");
      return false;
    }

    RequestController req = RequestController(path: "/api/verifyResetCodeTherapist.php");
    req.setBody({"email": email, "code": code});
    await req.post();

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      print("Verification response: $result"); // Add this line for debugging
      return result['status'] == 'success';
    }
    return false;
  }

  Future<bool> getTherapistName(int therapistId) async {
    RequestController req = RequestController(path: "/api/getTherapistName.php");
    req.setBody({"therapistId": therapistId});
    await req.post();
    if (req.status() == 200) {
      name = req.result()['TherapistName'];
      print(name);
      return true;
    } else {
      return false;
    }
  }


  Future<bool> updateProfile() async {
    if (therapistId == null) {
      print("Error: therapistId is not set");
      return false;
    }

    Map<String, dynamic> body = {
      'therapistId': therapistId,
      'name': name,
      'email': email,
      'specialization': specialization,
      'location': location,
    };

    // Only include password if it's not null or empty
    if (password != null && password!.isNotEmpty) {
      body['password'] = password;
    }

    // Convert supportingDocument to base64 string if it's not null
    if (supportingDocument != null) {
      body['supportingDocument'] = base64Encode(supportingDocument!);
    }

    print("Update profile request body: $body");  // Add this line for debugging

    RequestController req = RequestController(path: "/api/UpdateTherapistProfile.php");
    req.setBody(body);
    await req.put();

    if (req.status() == 200) {
      return true;
    } else {
      print("Update failed: ${req.result()}");
      return false;
    }
  }

  // Updated static method to load images
  static Future<List<Therapist>> loadImagesStatic() async {
    List<Therapist> result = [];

    RequestController req = RequestController(path: "/api/getTherapistImages.php");
    req.setBody({});
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(Therapist.fromJson(item));
        print("Result Have Been Added");
      }
    } else {
      print('Failed to fetch data');
    }
    return result;
  }

  static Future<List<Therapist>> fetchTherapist() async {
    List<Therapist> result = [];
    RequestController req = RequestController(path: "/api/therapist.php");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      List<dynamic> responseData = req.result();
      if (responseData.isNotEmpty) {
        result = responseData.map((json) => Therapist.fromJson(json)).toList();
      } else {
        print('Response data is empty.');
      }
    } else {
      print('Failed to fetch data.');
      print('Server response: ${req.result()}');
    }

    return result;
  }

  Future<int?> getTherapistId() async {
    final prefs = await SharedPreferences.getInstance();
    String? therapistEmail = prefs.getString('therapistEmail');
    if (therapistEmail == null || therapistEmail.isEmpty) {
      print("Error: Email is not set");
      return null;
    }

    RequestController req = RequestController(path: "/api/getTherapistId.php");
    req.setBody({"email": therapistEmail});
    await req.post();

    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      if (result.containsKey('therapistId')) {
        // Parse the therapistId as an int
        int? parsedTherapistId = int.tryParse(result['therapistId'].toString());
        if (parsedTherapistId != null) {
          therapistId = parsedTherapistId;
          print("Fetched therapistId: $therapistId");
          return therapistId;
        } else {
          print("Failed to parse therapistId");
          return null;
        }
      } else {
        print("therapistId not found in response");
        return null;
      }
    } else {
      print("Failed to fetch therapistId, status code: ${req.status()}");
      return null;
    }
  }

  static Future<List<Therapist>> fetchPendingTherapists() async {
    List<Therapist> result = [];
    RequestController req = RequestController(path: "/api/pendingTherapists.php");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      List<dynamic> responseData = req.result();
      result = responseData.map((json) => Therapist.fromJson(json)).toList();
    }

    return result;
  }

  Future<bool> approveTherapist() async {
    RequestController req = RequestController(path: "/api/approveTherapist.php");
    req.setBody({"therapistId": therapistId});
    await req.put();
    return req.status() == 200;
  }

  Future<List<Therapist>> fetchFullTherapistDetails() async {
    List<Therapist> result = [];

    int? appUserId = await getTherapistId();

    if (appUserId == null) {
      print('Error: Therapist ID not found');
      return result;
    }

    RequestController req = RequestController(path: "/api/fetchFullTherapistDetails.php?therapistId=$therapistId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      var responseData = req.result();

      if (responseData is Map<String, dynamic>) {
        var data = responseData['data'];
        if (data is List) {
          result = data.map((json) => Therapist.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic>) {
          // Handle the case where 'data' is a single object
          result = [Therapist.fromJson(data)];
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

  Future<bool> saveProfilePicture(TherapistImage therapistImage) async {
    RequestController req = RequestController(path: "/api/saveTherapistImage.php");

    // Make sure both therapistId and image are not null
    if (therapistImage.therapistId == null || therapistImage.image == null) {
      print("Error: therapistId or image is null");
      return false;
    }

    req.setBody({
      'therapistId': therapistImage.therapistId,
      'image': therapistImage.image,
    });

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
    if (therapistId == null) {
      print("Error: AppUserId is not set");
      return null;
    }

    RequestController req = RequestController(path: "/api/getTherapistImage.php?therapistId=$therapistId");
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

  String? get specializationDescription {
    if (specialization == null) return null;

    switch (specialization) {
      case 'Clinical Psychologist':
        return 'Focuses on diagnosing and treating mental health disorders through psychological methods.';
      case 'Counseling Psychologist':
        return 'Provides therapy and counseling for individuals, couples, and families to address emotional and psychological challenges.';
      case 'Child and Adolescent Therapist':
        return 'Specializes in working with children and adolescents to address mental health and developmental issues.';
      case 'Marriage and Family Therapist':
        return 'Works with individuals, couples, and families to improve relationships and resolve issues within the family unit.';
      case 'Cognitive Behavioral Therapist (CBT)':
        return 'Specializes in cognitive behavioral therapy, focusing on changing negative thought patterns and behaviors.';
      case 'Dialectical Behavior Therapist (DBT)':
        return 'Uses dialectical behavior therapy to help individuals manage emotions, improve relationships, and reduce self-destructive behaviors.';
      case 'Trauma Therapist':
        return 'Specializes in helping individuals recover from trauma and manage PTSD symptoms.';
      case 'Addiction Therapist':
        return 'Provides support and treatment for individuals struggling with substance abuse and addiction.';
      case 'Grief Counselor':
        return 'Offers support to individuals dealing with loss and bereavement, helping them navigate the grieving process.';
      case 'Anger Management Counselor':
        return 'Helps individuals manage and control anger through therapy and coping strategies.';
      case 'Anxiety Specialist':
        return 'Focuses on treating anxiety disorders and helping individuals manage anxiety symptoms.';
      case 'Depression Specialist':
        return 'Specializes in treating depression and helping individuals cope with depressive symptoms.';
      case 'Eating Disorder Specialist':
        return 'Provides treatment for eating disorders such as anorexia, bulimia, and binge eating disorder.';
      case 'Stress Management Counselor':
        return 'Offers techniques and strategies to manage and reduce stress in individuals’ lives.';
      case 'Workplace Mental Health Counselor':
        return 'Focuses on mental health issues related to the workplace, including stress, burnout, and work-life balance.';
      case 'Psychoanalyst':
        return 'Uses psychoanalysis to explore unconscious processes and resolve deep-seated emotional issues.';
      case 'Neuropsychologist':
        return 'Specializes in understanding the relationship between brain function and behavior, often working with cognitive disorders.';
      case 'Behavioral Therapist':
        return 'Focuses on changing specific behaviors through techniques such as conditioning and reinforcement.';
      case 'Psychiatrist':
        return 'Medical doctor specializing in mental health, including the diagnosis and treatment of mental illnesses with medication and therapy.';
      case 'Mindfulness-Based Therapist':
        return 'Uses mindfulness techniques to help individuals increase awareness and manage stress and emotional difficulties.';
      case 'Other':
        return 'Specialization not listed. Please contact for more details.';
      default:
        return 'No description available for this specialization.';
    }
  }
}

