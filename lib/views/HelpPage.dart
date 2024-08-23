import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final Map<String, bool> _expandedCategories = {
    'App Usage': false,
    'Account Management': false,
    'Privacy & Security': false,
    'Appointment Booking': false,
    'Mood Tracking': false,
    'Assessments & Results': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for topics...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: _expandedCategories.keys.map((category) {
                return _buildCategoryTile(category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(String category) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white, // Set the background color to white
      child: ExpansionTile(
        title: Text(category),
        leading: Icon(
          _getCategoryIcon(category),
          color: Colors.black,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(_getCategoryDetails(category)),
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            _expandedCategories[category] = expanded;
          });
        },
        initiallyExpanded: _expandedCategories[category] ?? false,
      ),
    );
  }


  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'App Usage':
        return Icons.phone_android;
      case 'Account Management':
        return Icons.person;
      case 'Privacy & Security':
        return Icons.lock;
      case 'Appointment Booking':
        return Icons.calendar_today;
      case 'Mood Tracking':
        return Icons.mood;
      case 'Assessments & Results':
        return Icons.assessment;
      default:
        return Icons.help_outline;
    }
  }

  String _getCategoryDetails(String category) {
    switch (category) {
      case 'App Usage':
        return 'Learn how to navigate and use the features of the app.';
      case 'Account Management':
        return 'Manage your account settings, including password changes and profile updates.';
      case 'Privacy & Security':
        return 'Understand how we protect your data and ensure your privacy.';
      case 'Appointment Booking':
        return 'Step-by-step guide on how to book, reschedule, or cancel appointments.';
      case 'Mood Tracking':
        return 'Instructions on how to use the mood tracking feature and view your progress.';
      case 'Assessments & Results':
        return 'Information on how assessments work and how to interpret your results.';
      default:
        return '';
    }
  }
}
