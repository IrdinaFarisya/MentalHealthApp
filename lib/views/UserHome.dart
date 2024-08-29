import 'package:flutter/material.dart';
import 'package:mentalhealthapp/views/HelplineContactPage.dart';
import 'dart:async';
import 'package:mentalhealthapp/views/MoodTracker.dart';
import 'package:mentalhealthapp/views/ResourcePage.dart';
import 'package:mentalhealthapp/views/SelfAssessmentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/model/appointment.dart';
import 'package:mentalhealthapp/views/UserAppointmentDetails.dart';
import 'package:mentalhealthapp/views/UserProfile.dart';
import 'package:mentalhealthapp/model/helpline.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mentalhealthapp/model/NavigationBar.dart';

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
              colors: [Colors.green[50]!, Colors.white],
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
            backgroundColor: Colors.green[50],
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
                              color: Colors.green[800],
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
                    SizedBox(height: 16),
                    Text(
                      'Kindness Calls',
                      style: TextStyle(
                        fontFamily: 'LibreBaskerville',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    _buildHelplineSection(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
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
          color: Colors.white,
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

  Widget _buildHelplineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          // Use a Card widget for the helpline section
          Card(
            color: Colors.white,
            elevation: 2.0,
            margin: EdgeInsets.only(bottom: 16), // Matches appointment card spacing
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            child: ListTile(
              leading: Icon(Icons.call, color: Colors.black, size: 30),
              title: Text(
                'Talk to someone', // Update this text as needed
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
                size: 20,
              ),
              onTap: () {
                // Navigate to the HelplinePage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelplinePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

