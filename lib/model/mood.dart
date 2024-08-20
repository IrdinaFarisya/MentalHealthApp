import 'dart:convert';
import 'dart:typed_data';
import '../Controller/request_controller.dart';
import 'package:mentalhealthapp/model/appUser.dart';

class Mood {
  int? entryId;
  int? appUserId;
  String? mood;
  String? date;
  String? details;

  Mood({
    this.entryId,
    this.appUserId,
    this.mood,
    this.date,
    this.details,
  });

  Mood.getMood(
      this.entryId,
      this.appUserId,
      this.mood,
      this.date,
      this.details,
      );

  Mood.getId(
      this.entryId,
      this.appUserId,
      this.mood,
      this.date,
      this.details,

      );

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      entryId: int.tryParse(json['entryId'].toString()), // Ensure entryId is an int
      appUserId: int.tryParse(json['appUserId'].toString()), // Ensure appUserId is an int
      mood: json['mood'],
      date: json['date'],
      details: json['details'],
    );
  }


  Map<String, dynamic> toJson() => {
    'entryId': entryId,
    'appUserId': appUserId,
    'mood': mood,
    'date': date,
    'details': details,
  };

  Future<bool> saveMood() async {
    RequestController req = RequestController(path: "/api/mood.php");
    req.setBody(toJson());
    await req.post();
    print("HTTP Status: ${req.status()}");
    print("Raw response: ${req.result()}");

    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      var result = req.result();
      print("Response data: $result");
      try {
        if (result is Map<String, dynamic>) {
          // If result is already a Map, use it directly
          if (result.containsKey('entryId')) {
            entryId = int.parse(result['entryId'].toString());
            return true;
          }
        } else if (result is String) {
          // If result is a String, parse it as JSON
          Map<String, dynamic> response = json.decode(result);
          if (response.containsKey('entryId')) {
            entryId = int.parse(response['entryId'].toString());
            return true;
          }
        }
      } catch (e) {
        print("Error parsing response: $e");
      }
      return false;
    } else {
      return false;
    }
  }


  Future<bool> getMoodId() async {
    RequestController req = RequestController(path: "/api/getMoodId.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      date = req.result()['date'];
      print(entryId);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateMood() async {
    RequestController req = RequestController(path: "/api/updateMoodEntry.php");

    req.setBody({
      "entryId": entryId,
      "appUserId": appUserId,
      "mood": mood,
      "date": date,
      "details": details,
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

  Future<List<Mood>> fetchMood() async {
    List<Mood> result = [];

    RequestController req = RequestController(path: "/api/mood.php");
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      var responseData = req.result();

      if (responseData is List) {
        for (var item in responseData) {
          result.add(Mood.fromJson(item));
        }
      } else if (responseData is String) {
        var jsonData = json.decode(responseData);
        if (jsonData is List) {
          for (var item in jsonData) {
            result.add(Mood.fromJson(item));
          }
        } else {
          print('Unexpected response format.');
        }
      } else {
        print('Unexpected response type.');
      }
    } else {
      print('Failed to fetch data. Status: ${req.status()}, Result: ${req.result()}');
    }

    return result;
  }

  static Future<List<Mood>> fetchPastMood() async {
    List<Mood> result = [];

    AppUser appUser = AppUser();
    int? appUserId = await appUser.getUserId();

    if (appUserId == null) {
      print('Error: AppUser ID not found');
      return result;
    }

    RequestController req = RequestController(
        path: "/api/fetchPastMood.php?appUserId=$appUserId");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      Map<String, dynamic> responseData = req.result();
      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> moodData = responseData['data'];
        result =
            moodData.map((json) => Mood.fromJson(json)).toList();
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
