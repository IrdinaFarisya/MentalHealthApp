import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/therapist.dart';
import 'package:mentalhealthapp/model/appointment.dart';
import 'package:mentalhealthapp/views/TherapistEditProfile.dart';
import 'package:mentalhealthapp/views/TherapistHome.dart';
import 'package:mentalhealthapp/views/PastAppointmentList.dart';
import 'package:mentalhealthapp/views/PatientsBookingList.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/views/HelpPage.dart';
import 'package:mentalhealthapp/views/TermsOfServicesPage.dart';
import 'package:mentalhealthapp/views/PrivacyPolicyPage.dart';
import 'package:mentalhealthapp/views/AboutSereneSoul.dart';
import 'package:mentalhealthapp/main.dart';

class TherapistProfilePage extends StatefulWidget {
  @override
  _TherapistProfilePageState createState() => _TherapistProfilePageState();
}

class _TherapistProfilePageState extends State<TherapistProfilePage> {
  Therapist? therapist;
  List<Appointment> pastAppointments = [];
  bool isLoading = true;
  String errorMessage = '';
  String? profilePictureBase64;
  int _selectedIndex = 3; // Set the initial index to match the Profile tab

  @override
  void initState() {
    super.initState();
    _loadTherapistData();
  }

  Future<void> _loadTherapistData() async {
    try {
      therapist = Therapist();
      List<Therapist> therapistDetails = await therapist!.fetchFullTherapistDetails();
      if (therapistDetails.isNotEmpty) {
        setState(() {
          therapist = therapistDetails.first;
        });
        profilePictureBase64 = await therapist!.getProfilePicture();
      }
      pastAppointments = await Appointment.therapistDoneAppointment();
      pastAppointments.sort((a, b) => DateTime.parse('${b.appointmentDate} ${b.appointmentTime}')
          .compareTo(DateTime.parse('${a.appointmentDate} ${a.appointmentTime}')));
    } catch (e) {
      setState(() {
        errorMessage = "Error loading data: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (therapist != null) _buildTherapistInfoSection(),
              SizedBox(height: 32.0),
              _buildMenuOptions(),
              SizedBox(height: 20.0),
              _buildLogoutOption(),
            ],
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
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TherapistHomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientsBookingList()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentScreen()),
        );
        break;
      case 3:
      // Already on profile page
        break;
    }
  }

  Widget _buildTherapistInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey[200],
          backgroundImage: profilePictureBase64 != null
              ? MemoryImage(base64Decode(profilePictureBase64!))
              : null,
          child: profilePictureBase64 == null
              ? Icon(
            Icons.person,
            size: 40,
            color: Colors.grey[600],
          )
              : null,
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    therapist?.name ?? 'N/A',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.black,
                    onPressed: () {
                      if (therapist != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(therapist: therapist!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Therapist data is not available.')),
                        );
                      }
                    },
                  ),
                ],
              ),
              Text(
                therapist?.email ?? 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                therapist?.specialization ?? 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        _buildPastAppointmentsOption(),
        _buildMenuOption(Icons.help_outline, 'Help', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpPage()),
          );
        }),
        _buildMenuOption(Icons.notifications_none_outlined, 'Notification Setting', () {}),
        _buildMenuOption(Icons.description_outlined, 'Terms of Services', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TermsOfServicesPage()),
          );
        }),
        _buildMenuOption(Icons.privacy_tip_outlined, 'Privacy Policy', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
          );
        }),
        _buildMenuOption(Icons.favorite_border, 'About SereneSoul', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutSereneSoul()),
          );
        }),
      ],
    );
  }

  Widget _buildPastAppointmentsOption() {
    return ListTile(
      leading: Icon(Icons.playlist_add_check_outlined, color: Colors.black),
      title: Text('Past Appointments'),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Navigate to past appointments list for therapists
      },
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutOption() {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.black),
      title: Text('Logout'),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      },
    );
  }
}