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
      entryId: json['entryId'],
      appUserId: json['appUserId'],
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

  Future<dynamic> saveMood() async {
    RequestController req = RequestController(path: "/api/mood.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      String data = req.result().toString();
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
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200 && req.result() != null) {

      List<dynamic> responseData = req.result();

      if (responseData.isNotEmpty) {
        for (var item in responseData) {
          result.add(Mood.fromJson(item));
          print("Result:  ${result}");
        }
      } else {
        print('Response data is empty.');
        // Handle the case when the response data is empty
      }
    } else {
      print('Failed to fetch data.');
      // Handle the case when the request fails
    }

    return result;
  }
}
