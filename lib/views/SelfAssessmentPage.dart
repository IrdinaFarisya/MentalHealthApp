import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/assessment.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/views/MoodTrackerOverview.dart';
import 'package:mentalhealthapp/views/UserHome.dart';
import 'package:mentalhealthapp/views/UserProfile.dart';

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
          : _buildAssessmentList(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Add this line
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Therapists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true, // Add this line to ensure unselected labels are shown
        onTap: (index) {
          // Handle item tap
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserHomePage(),
                ),
              );
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoodTrackerOverview(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentScreen(),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelfAssessmentPage(),
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              );
              break;
          }
        },
      ),
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
      leading: Icon(Icons.assignment_outlined, color: Colors.black), // Adjust icon as needed
      title: Text(
        assessment.assessmentName ?? '',
        //style: TextStyle(fontWeight: FontWeight.bold),
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
          if (widget.assessment.introText != null && widget.assessment.introText!.isNotEmpty)
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
            itemCount: (widget.assessment.questions?.length ?? 0) + 1, // Add 1 for the button
            itemBuilder: (context, index) {
              if (index == widget.assessment.questions?.length) {
                // Return the button as the last item
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white), // White text color
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
      color: Colors.white, // Set card background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
        side: BorderSide(color: Colors.grey, width: 1.0), // Add border color and width
      ),
      elevation: 2, // Optional: add slight elevation
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
            value: answer.answerId.toString(),
            groupValue: answers[question.questionId],
            onChanged: (value) {
              setState(() {
                answers[question.questionId!] = value!;
              });
            },
            activeColor: Colors.black, // Set the color of the radio button when selected
          );
        }).toList() ?? [],
      );
    } else if (question.questionType == 'y_n') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            child: Text(
              'Yes',
              style: TextStyle(
                color: answers[question.questionId] == 'Yes' ? Colors.white : Colors.black,
              ),
            ),
            onPressed: () {
              setState(() {
                answers[question.questionId!] = 'Yes';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: answers[question.questionId] == 'Yes' ? Colors.black : Colors.white,
              side: BorderSide(color: Colors.black), // Add a border
            ),
          ),
          ElevatedButton(
            child: Text(
              'No',
              style: TextStyle(
                color: answers[question.questionId] == 'No' ? Colors.white : Colors.black,
              ),
            ),
            onPressed: () {
              setState(() {
                answers[question.questionId!] = 'No';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: answers[question.questionId] == 'No' ? Colors.black : Colors.white,
              side: BorderSide(color: Colors.black), // Add a border
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink(); // Return an empty SizedBox if the question type does not match
  }


  void _submitAssessment() async {
    if (answers.length == widget.assessment.questions?.length) {
      String clientResult = widget.assessment.calculateScore(answers);
      Map<String, dynamic> serverResult = await widget.assessment.submitAssessment(
          widget.user?.appUserId ?? 0, answers);

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
                  Text('Client-side result: $clientResult'),
                  SizedBox(height: 10),
                  Text('Server-side result: ${serverResult['result']}'),
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