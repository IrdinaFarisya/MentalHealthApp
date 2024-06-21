import 'package:flutter/material.dart';
import 'package:mentalhealthapp/views/MoodTracker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/model/appUser.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);


  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


    @override
    Widget build(BuildContext context) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE8D6), Color(0xFFFFF5F3)],
                // Gradient colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
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
              backgroundColor: Colors.transparent,
              // Make the background transparent
              elevation: 0,
              // Remove the shadow
              automaticallyImplyLeading: false,
              // Remove the back button
              centerTitle: true, // Center the title text
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          // Softer border radius
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              'Feeling low?',
                              style: TextStyle(
                                fontFamily: 'BodoniModa',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Talk to a therapist.',
                              style: TextStyle(
                                fontFamily: 'LibreBaskerville',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AppointmentScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                ),
                                child: Text(
                                  'Book An Appointment',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      Text(
                        'Suggested for you',
                        style: TextStyle(
                          fontFamily: 'LibreBaskerville',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ListTile(
                        leading: Icon(Icons.mood),
                        title: Text('Mood check'),
                        subtitle: Text('Track your daily mood.'),
                        onTap: () {
                          // Navigate to the mood tracker page
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.self_improvement),
                        title: Text('Quick meditation'),
                        onTap: () {
                          // Navigate to the quick meditation page
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                        builder: (context) => MoodTrackerPage(),
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
                  /*case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => updateProfilePage(user: widget.user),
                      ),
                    );
                    break;*/
                }
              },
            ),
          ),
        ],
      );
    }
  }

  void main() {
    runApp(MaterialApp(
      home: UserHomePage(),
    ));
  }
