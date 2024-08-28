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

  String calculateScore(Map<String, String> answers) {
    switch (assessmentId) {
      case 1: // PHQ-9
        return calculatePHQ9Score(answers);
      case 2: // GAD-7
        return calculateGAD7Score(answers);
      case 3: // K10
        return calculateK10Score(answers);
      case 4: // MDQ
        return calculateMDQScore(answers);
      default:
        return "Unknown assessment type";
    }
  }

  static String calculatePHQ9Score(Map<String, String> answers) {
    int score = answers.values.map((v) => _convertAnswerToInt(v)).reduce((a, b) => a + b);
    if (score >= 0 && score <= 4) return "Minimal or None";
    else if (score >= 5 && score <= 9) return "Mild";
    else if (score >= 10 && score <= 14) return "Moderate";
    else if (score >= 15 && score <= 19) return "Moderately Severe";
    else return "Severe";
  }

  static String calculateGAD7Score(Map<String, String> answers) {
    int score = answers.values.map((v) => _convertAnswerToInt(v)).reduce((a, b) => a + b);
    if (score >= 0 && score <= 4) return "Minimal Anxiety";
    else if (score >= 5 && score <= 9) return "Mild Anxiety";
    else if (score >= 10 && score <= 14) return "Moderate Anxiety";
    else return "Severe Anxiety";
  }

  static String calculateK10Score(Map<String, String> answers) {
    int score = answers.values.map((v) => _convertAnswerToInt(v)).reduce((a, b) => a + b);
    if (score >= 10 && score <= 19) return "Low Distress";
    else if (score >= 20 && score <= 24) return "Moderate Distress";
    else if (score >= 25 && score <= 29) return "High Distress";
    else return "Very High Distress";
  }

  static String calculateMDQScore(Map<String, String> answers) {
    // Convert numerical answers to Yes/No
    Map<String, String> convertedAnswers = {};
    answers.forEach((key, value) {
      int answerValue = int.tryParse(value) ?? 0;
      if (key == '41') {
        // For question 41, keep the original value
        convertedAnswers[key] = value;
      } else {
        convertedAnswers[key] = answerValue > 0 ? 'Yes' : 'No';
      }
    });

    // Count 'Yes' answers for the first 13 questions (assuming these are the symptom questions)
    int yesCount = convertedAnswers.entries
        .where((entry) => int.parse(entry.key) <= 39 && entry.value == 'Yes')
        .length;

    // Check if question 14 (key '40') exists and is 'Yes'
    bool criterion2 = convertedAnswers['40'] == 'Yes';

    // Check if question 15 (key '41') indicates moderate or serious problem
    bool criterion3 = ['2', '3'].contains(convertedAnswers['41']);

    bool criterion1 = yesCount >= 7;

    return (criterion1 && criterion2 && criterion3)
        ? "Positive Bipolar Spectrum Disorder"
        : "Negative Bipolar Spectrum Disorder";
  }


  static int _convertAnswerToInt(String answer) {
    switch (answer.toLowerCase()) {
      case 'yes':
        return 1;
      case 'no':
        return 0;
      default:
        return int.tryParse(answer) ?? 0;
    }
  }

  Future<Map<String, dynamic>> submitAssessment(int appUserId, Map<int, String> answers) async {
    try {
      // Convert the answers to the format expected by the server
      Map<String, dynamic> convertedAnswers = {};
      answers.forEach((key, value) {
        if (assessmentId == 4) { // MDQ
          if (key == 41) {
            // For question 41, keep the original value
            convertedAnswers[key.toString()] = value;
          } else {
            // For other questions, convert to 1 for 'Yes' and 0 for 'No'
            convertedAnswers[key.toString()] = (value.toLowerCase() == 'yes' || int.parse(value) > 0) ? '1' : '0';
          }
        } else {
          // For other assessments, keep the original value
          convertedAnswers[key.toString()] = value;
        }
      });

      RequestController req = RequestController(path: "/api/submitAssessment.php");
      req.setBody({
        'appUserId': appUserId.toString(),
        'assessmentId': assessmentId.toString(),
        'answers': jsonEncode(convertedAnswers)
      });
      await req.post();

      if (req.status() == 200) {
        var result = req.result();
        if (result is Map<String, dynamic>) {
          return result;
        } else if (result is String) {
          // Try to parse the string as JSON
          try {
            return jsonDecode(result);
          } catch (e) {
            return {'status': 'error', 'message': 'Invalid server response: $result'};
          }
        } else {
          return {'status': 'error', 'message': 'Unexpected server response type'};
        }
      } else {
        return {'status': 'error', 'message': 'Server returned status code ${req.status()}'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Exception occurred: $e'};
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
  int? mark;

  Answer({this.answerId, this.questionId, this.answerText, this.mark});

  Answer.fromJson(Map<String, dynamic> json) {
    answerId = json['answerId'] is String
        ? int.tryParse(json['answerId'])
        : json['answerId'];
    questionId = json['questionId'] is String
        ? int.tryParse(json['questionId'])
        : json['questionId'];
    answerText = json['answers_text'];
    mark = json['mark'] is String
        ? int.tryParse(json['mark'])
        : json['mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answerId'] = answerId;
    data['answers_text'] = answerText;
    return data;
  }
}