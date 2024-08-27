import 'dart:convert';
import '../Controller/request_controller.dart';

class Assessment {
  int? assessmentId;
  String? assessmentName;
  String? introText;  // New field for introductory text
  List<Question>? questions;

  Assessment({
    this.assessmentId,
    this.assessmentName,
    this.introText,  // Include in constructor
    this.questions
  });

  Assessment.fromJson(Map<String, dynamic> json) {
    assessmentId = json['assessmentId'] is String
        ? int.tryParse(json['assessmentId'])
        : json['assessmentId'];
    assessmentName = json['assessmentName'];
    introText = json['introText'];  // Parse from JSON
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assessmentId'] = assessmentId;
    data['assessmentName'] = assessmentName;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<List<Assessment>> fetchAssessments() async {
    RequestController req = RequestController(path: "/api/fetchAssessments.php");
    await req.get();
    if (req.status() == 200) {
      List<dynamic> data = req.result()['data'];
      return data.map((json) => Assessment.fromJson(json)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> submitAssessment(int appUserId, Map<int, String> answers) async {
    RequestController req = RequestController(path: "/api/submitAssessment.php");
    req.setBody({
      'appUserId': appUserId,
      'assessmentId': assessmentId,
      'answers': jsonEncode(answers)
    });
    await req.post();
    if (req.status() == 200) {
      Map<String, dynamic> result = req.result();
      return result;
    }
    return {'status': 'error', 'message': 'Failed to submit assessment'};
  }

  String calculateScore(Map<int, String> answers) {
    switch (assessmentId) {
      case 1: // PHQ-9
        return calculatePHQ9Score(answers);
      case 2: // GAD-7
        return calculateGAD7Score(answers);
      case 3: // K10
        return calculateK10Score(answers);
      case 3: // MDQ
        return calculateMDQScore(answers);
      default:
        return "Unknown assessment type";
    }
  }

  static String calculatePHQ9Score(Map<int, String> answers) {
    int score = answers.values.map((v) => int.parse(v)).reduce((a, b) => a + b);
    if (score >= 0 && score <= 4) return "Minimal or None";
    else if (score >= 5 && score <= 9) return "Mild";
    else if (score >= 10 && score <= 14) return "Moderate";
    else if (score >= 15 && score <= 19) return "Moderately Severe";
    else return "Severe";
  }

  static String calculateGAD7Score(Map<int, String> answers) {
    int score = answers.values.map((v) => int.parse(v)).reduce((a, b) => a + b);
    if (score >= 0 && score <= 4) return "Minimal Anxiety";
    else if (score >= 5 && score <= 9) return "Mild Anxiety";
    else if (score >= 10 && score <= 14) return "Moderate Anxiety";
    else return "Severe Anxiety";
  }

  static String calculateK10Score(Map<int, String> answers) {
    int score = answers.values.map((v) => int.parse(v)).reduce((a, b) => a + b);
    if (score >= 10 && score <= 19) return "Low Distress";
    else if (score >= 20 && score <= 24) return "Moderate Distress";
    else if (score >= 25 && score <= 29) return "High Distress";
    else return "Very High Distress";
  }

  static String calculateMDQScore(Map<int, String> answers) {
    // Check if we have all required answers
    if (!answers.containsKey(1) || !answers.containsKey(2) || !answers.containsKey(3)) {
      return "Incomplete";
    }

    // Parse answers for question 1
    List<String> question1Answers = answers[1]!.split(',');

    // Count 'Yes' answers in question 1
    int yesCount = question1Answers.where((answer) => answer.toLowerCase() == 'yes').length;

    // Check all three criteria
    bool criterion1 = yesCount >= 7;
    bool criterion2 = answers[2]!.toLowerCase() == 'yes';
    bool criterion3 = ['moderate', 'serious'].contains(answers[3]!.toLowerCase());

    if (criterion1 && criterion2 && criterion3) {
      return "Positive";
    } else {
      return "Negative";
    }
  }
}

class Question {
  int? questionId;
  int? assessmentId;
  String? questionText;
  String? questionType;
  List<Answer>? answers;

  Question({this.questionId, this.assessmentId, this.questionText, this.questionType, this.answers});

  Question.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'] is String
        ? int.tryParse(json['questionId'])
        : json['questionId'];
    assessmentId = json['assessmentId'] is String
        ? int.tryParse(json['assessmentId'])
        : json['assessmentId'];
    questionText = json['questions_text'];
    questionType = json['question_type'];
    if (json['answers'] != null) {
      answers = <Answer>[];
      json['answers'].forEach((v) {
        answers!.add(Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['questions_text'] = questionText;
    data['question_type'] = questionType;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answer {
  int? answerId;
  int? questionId;
  String? answerText;

  Answer({this.answerId, this.questionId, this.answerText});

  Answer.fromJson(Map<String, dynamic> json) {
    answerId = json['answerId'] is String
        ? int.tryParse(json['answerId'])
        : json['answerId'];
    questionId = json['questionId'] is String
        ? int.tryParse(json['questionId'])
        : json['questionId'];
    answerText = json['answers_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answerId'] = answerId;
    data['answers_text'] = answerText;
    return data;
  }
}