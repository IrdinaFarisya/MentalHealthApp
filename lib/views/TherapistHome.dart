// TherapistHome.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/appointment.dart';
import 'AcceptAppointment.dart';
import 'AppointmentDetails.dart';
import 'AppointmentScreen.dart';
import 'MoodTracker.dart';
import 'PatientsBookingList.dart';
import 'TherapistLogin.dart';

class TherapistHomePage extends StatefulWidget {
  const TherapistHomePage({Key? key}) : super(key: key);

  @override
  _TherapistHomePageState createState() => _TherapistHomePageState();
}

class _TherapistHomePageState extends State<TherapistHomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  List<Appointment> acceptedAppointments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchAcceptedAppointments();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchAcceptedAppointments();
    }
  }

  void fetchAcceptedAppointments() async {
    List<Appointment> appointments = await Appointment.fetchAcceptedAppointments();
    setState(() {
      acceptedAppointments = appointments;
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
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
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
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            'We Rise',
                            style: TextStyle(
                              fontFamily: 'BodoniModa',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'By Lifting Others',
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
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientsBookingList(),
                                  ),
                                );
                                if (result == true) {
                                  fetchAcceptedAppointments();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                              child: Text(
                                'Accept Appointment',
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
                        fontSize: 25,
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
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Patients',
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
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              switch (index) {
                case 0:
                  fetchAcceptedAppointments();
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientsBookingList(),
                    ),
                  ).then((_) => fetchAcceptedAppointments());
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(),
                    ),
                  ).then((_) => fetchAcceptedAppointments());
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TherapistHomePage(),
                    ),
                  ).then((_) => fetchAcceptedAppointments());
                  break;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptedAppointmentsList() {
    if (acceptedAppointments.isEmpty) {
      return Text('No upcoming appointments');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: acceptedAppointments.length,
      itemBuilder: (context, index) {
        Appointment appointment = acceptedAppointments[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text('${appointment.username}'),
            subtitle: Text('${appointment.appointmentDate} at ${appointment.appointmentTime}'),
            trailing: Text(appointment.status ?? 'PENDING', style: TextStyle(color: Colors.green)),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentDetails(appointment: appointment),
                ),
              );
            },
          ),
        );
      },
    );
  }
}