import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthapp/model/mood.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/model/NotificationService.dart';

class MoodTrackerPage extends StatefulWidget {
  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedMood;
  TextEditingController _journalController = TextEditingController();

  final List<Map<String, String>> moodOptions = [
    {'name': 'Joy', 'asset': 'assets/emotions/joy.jpg'},
    {'name': 'Sadness', 'asset': 'assets/emotions/sadness.jpg'},
    {'name': 'Disgust', 'asset': 'assets/emotions/disgust.jpg'},
    {'name': 'Anger', 'asset': 'assets/emotions/anger.jpg'},
    {'name': 'Envy', 'asset': 'assets/emotions/envy.jpg'},
    {'name': 'Anxiety', 'asset': 'assets/emotions/anxiety.jpg'},
    {'name': 'Ennui', 'asset': 'assets/emotions/ennui.jpg'},
    {'name': 'Fear', 'asset': 'assets/emotions/fear.jpg'},
    {'name': 'Embarrassment', 'asset': 'assets/emotions/embarrassment.jpg'},
  ];

  late AppUser _appUser; // Instance of AppUser

  @override
  void initState() {
    super.initState();
    _appUser = AppUser();  // Set the email here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SereneSoul',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.transparent, // Make the background transparent
        elevation: 0, // Remove the shadow
        centerTitle: true, // Center the title text
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Tracker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                fontFamily: 'BodoniModa',
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: <Color>[Colors.black, Colors.brown],
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'LibreBaskerville',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectDate(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 18),
                  SizedBox(width: 8),
                  Text(
                    _selectedDate == DateTime.now()
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'How do you feel today?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'LibreBaskerville',
              ),
            ),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: moodOptions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = moodOptions[index]['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedMood == moodOptions[index]['name']
                          ? Colors.brown.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedMood == moodOptions[index]['name']
                            ? Colors.brown
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              moodOptions[index]['asset']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            moodOptions[index]['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedMood == moodOptions[index]['name']
                                  ? Colors.brown
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _journalController,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: 'Journal Entry',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _MoodEntry,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black), // Add a border
                  ),
                ),
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _MoodEntry() async{
    int? appUserId = await _appUser.getUserId();
    if (_selectedMood != null) {
      Mood newMood = Mood(
        appUserId: appUserId,
        mood: _selectedMood,
        date: _selectedDate.toIso8601String().split('T')[0],
        details: _journalController.text,
      );
      _saveMoodEntry(newMood);
    } else {
      print('Failed to fetch appUserId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user information. Please try again.')),
      );
    }
  }

  void _saveMoodEntry(Mood newMood) async {
    try {
      bool success = await newMood.saveMood();
      if (success) {
        print('Mood entry saved successfully');
        setState(() {
          _selectedMood = null;
          _journalController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mood entry saved successfully')),
        );

        // Schedule next day's reminder
        DateTime nextReminder = DateTime.now().add(Duration(days: 1));
        nextReminder = DateTime(nextReminder.year, nextReminder.month, nextReminder.day, 20, 0); // Set to 8 PM

        await NotificationService().scheduleNotification(
          10000, // Use a different ID range for journal reminders
          'Journal Reminder',
          'Time to write in your journal!',
          nextReminder,
        );
      } else {
        print('Failed to save mood entry');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save mood entry. Please try again.')),
        );
      }
    } catch (e) {
      print('Error saving mood entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while saving: $e')),
      );
    }
  }
}
