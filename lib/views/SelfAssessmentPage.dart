import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/assessment.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/views/MoodTrackerOverview.dart';
import 'package:mentalhealthapp/views/UserHome.dart';
import 'package:mentalhealthapp/views/UserProfile.dart';
import 'package:mentalhealthapp/views/PastAssessmentsPage.dart'; // New import
import 'package:mentalhealthapp/model/NavigationBar.dart';

class SelfAssessmentPage extends StatefulWidget {
  @override
  _SelfAssessmentPageState createState() => _SelfAssessmentPageState();
}

class _SelfAssessmentPageState extends State<SelfAssessmentPage> {
  List<Assessment> assessments = [];
  bool isLoading = true;
  AppUser? user;
  String errorMessage = '';
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadAssessments();
    _loadUserData();
  }

  Future<void> _loadAssessments() async {
    try {
      assessments = await Assessment.fetchAssessments();
    } catch (e) {
      setState(() {
        errorMessage = "Error loading assessments: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    user = AppUser();
    await user!.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Self Assessments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : _buildContent(),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            child: Text(
              'View Past Assessments',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50), // full width button
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PastAssessmentsPage(user: user),
                ),
              );
            },
          ),
        ),
        Expanded(child: _buildAssessmentList()),
      ],
    );
  }

  Widget _buildAssessmentList() {
    return ListView.builder(
      itemCount: assessments.length,
      itemBuilder: (context, index) {
        return _buildAssessmentTile(assessments[index]);
      },
    );
  }

  Widget _buildAssessmentTile(Assessment assessment) {
    return ListTile(
      leading: Icon(Icons.assignment_outlined, color: Colors.black),
      title: Text(
        assessment.assessmentName ?? '',
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssessmentQuestionsPage(
              assessment: assessment,
              user: user,
            ),
          ),
        );
      },
    );
  }
}

class AssessmentQuestionsPage extends StatefulWidget {
  final Assessment assessment;
  final AppUser? user;

  AssessmentQuestionsPage({required this.assessment, required this.user});

  @override
  _AssessmentQuestionsPageState createState() => _AssessmentQuestionsPageState();
}

class _AssessmentQuestionsPageState extends State<AssessmentQuestionsPage> {
  Map<int, String> answers = {};

  void storeAnswer(int questionId, String answer) {
    answers[questionId] = answer;
    print('Stored answer for question $questionId: ${answers[questionId]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.assessment.assessmentName ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          if (widget.assessment.introText != null &&
              widget.assessment.introText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.assessment.introText ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (widget.assessment.questions?.length ?? 0) + 1,
            // Add 1 for the button
            itemBuilder: (context, index) {
              if (index == widget.assessment.questions?.length) {
                // Return the button as the last item
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white), // White text color
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black background color
                      ),
                      onPressed: _submitAssessment,
                    )

                );
              } else {
                Question question = widget.assessment.questions![index];
                return _buildQuestionCard(question);
              }
            },
          ),
        ],
      ),
    );
  }


  Widget _buildQuestionCard(Question question) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.white,
      // Set card background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
        side: BorderSide(
            color: Colors.grey, width: 1.0), // Add border color and width
      ),
      elevation: 2,
      // Optional: add slight elevation
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText ?? '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            _buildAnswerOptions(question),
          ],
        ),
      ),
    );
  }


  Widget _buildAnswerOptions(Question question) {
    if (question.questionType == 'mcq') {
      return Column(
        children: question.answers?.map((answer) {
          return RadioListTile<String>(
            title: Text(answer.answerText ?? ''),
            value: answer.mark.toString(),
            groupValue: answers[question.questionId],
            onChanged: (value) {
              setState(() {
                answers[question.questionId!] = value!;
              });
            },
          );
        }).toList() ?? [],
      );
    } else if (question.questionType == 'y_n') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Yes', 'No'].map((option) {
          bool isSelected = answers[question.questionId] == option;
          return ElevatedButton(
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            onPressed: () {
              setState(() {
                answers[question.questionId!] = option;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.black : Colors.white,
              side: BorderSide(color: Colors.black),
            ),
          );
        }).toList(),
      );
    }
    return SizedBox.shrink();
  }

  void _submitAssessment() async {
    if (answers.length == widget.assessment.questions?.length) {
      String clientResult = widget.assessment.calculateScore(
          answers.map((key, value) => MapEntry(key.toString(), value))
      );
      Map<String, dynamic> serverResult = await widget.assessment
          .submitAssessment(
          widget.user?.appUserId ?? 0,
          answers
      );

      if (serverResult['status'] == 'success') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Assessment Result'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text('${serverResult['result']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit assessment')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please answer all questions')),
      );
    }
  }
}