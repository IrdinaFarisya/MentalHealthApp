import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mentalhealthapp/views/MoodTracker.dart';
import 'package:mentalhealthapp/views/SelfAssessmentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/model/appointment.dart';
import 'package:mentalhealthapp/views/UserAppointmentDetails.dart';
import 'package:mentalhealthapp/views/UserProfile.dart';

import 'MoodTrackerOverview.dart';
import 'PastAppointmentDetails.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);


  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> with WidgetsBindingObserver{
  int _selectedIndex = 0;
  Timer? _timer;

  List<Appointment> UserAcceptedAppointments = [];
  List<Appointment> UserPastAppointments = []; // New list for past appointments


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchUserAcceptedAppointments();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchUserAcceptedAppointments());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchUserAcceptedAppointments();
    }
  }

  void fetchUserAcceptedAppointments() async {
    List<Appointment> appointments = await Appointment.fetchUserAcceptedAppointments();
    setState(() {
      UserAcceptedAppointments = appointments.where((appointment) =>
      appointment.status == 'ACCEPTED').toList();
      UserPastAppointments = appointments.where((appointment) =>
      appointment.status == 'DONE').toList();

      // Sort past appointments by date, most recent first
      UserPastAppointments.sort((a, b) => DateTime.parse('${b.appointmentDate} ${b.appointmentTime}')
          .compareTo(DateTime.parse('${a.appointmentDate} ${a.appointmentTime}')));
    });
  }



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
                      'Upcoming Appointments',
                      style: TextStyle(
                        fontFamily: 'LibreBaskerville',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildAcceptedAppointmentsList(),
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
        ),
      ],
    );
  }

  Widget _buildAcceptedAppointmentsList() {
    if (UserAcceptedAppointments.isEmpty) {
      return Text('No upcoming appointments');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: UserAcceptedAppointments.length,
      itemBuilder: (context, index) {
        Appointment appointment = UserAcceptedAppointments[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text('${appointment.name}'),
            subtitle: Text('${appointment.appointmentDate} at ${appointment.appointmentTime}'),
            trailing: Text(
              appointment.status ?? 'PENDING',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserAppointmentDetails(appointment: appointment),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPastAppointmentsList() {
    if (UserPastAppointments.isEmpty) {
      return Text('No past appointments');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: UserPastAppointments.length,
      itemBuilder: (context, index) {
        Appointment appointment = UserPastAppointments[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text('${appointment.name}'),
            subtitle: Text('${appointment.appointmentDate} at ${appointment.appointmentTime}'),
            trailing: Text(
              'DONE',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PastAppointmentDetails(appointment: appointment),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
