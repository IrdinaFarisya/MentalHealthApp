import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthapp/model/NavigationBar.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/model/appointment.dart';
import 'package:mentalhealthapp/views/AboutSereneSoul.dart';
import 'package:mentalhealthapp/views/NotificationSetting.dart';
import 'package:mentalhealthapp/views/PastAppointmentList.dart';
import 'package:mentalhealthapp/views/PendingAppointmentList.dart';
import 'package:mentalhealthapp/views/PrivacyPolicyPage.dart';
import 'package:mentalhealthapp/views/MoodTrackerOverview.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/views/ResourcePage.dart';
import 'package:mentalhealthapp/views/SelfAssessmentPage.dart';
import 'package:mentalhealthapp/views/UserHome.dart';
import 'package:mentalhealthapp/views/UserEditProfile.dart';
import 'package:mentalhealthapp/views/HelpPage.dart';
import 'package:mentalhealthapp/views/TermsOfServicesPage.dart';
import 'package:mentalhealthapp/main.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}
//hello

class _UserProfilePageState extends State<UserProfilePage> {
  AppUser? user;
  List<Appointment> pastAppointments = [];
  List<Appointment> pendingAppointments = [];
  bool isLoading = true;
  String errorMessage = '';
  String? profilePictureBase64;
  int _selectedIndex = 4; // Set the initial index to match the Profile tab

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      user = AppUser();
      List<AppUser> userDetails = await user!.fetchFullUserDetails();
      if (userDetails.isNotEmpty) {
        setState(() {
          user = userDetails.first;
        });
        profilePictureBase64 = await user!.getProfilePicture(); // Ensure this is a String
      }
      pastAppointments = await Appointment.fetchDoneAppointment();
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
        backgroundColor: Colors.green[50],
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green[50]!, // Start color
              Colors.white, // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user != null) _buildUserInfoSection(),
                SizedBox(height: 32.0),
                _buildMenuOptions(),
                SizedBox(height: 20.0),
                _buildLogoutOption(), // Add this to include the logout option at the bottom
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
    );
  }

  Widget _buildUserInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey[200], // Light grey background
          backgroundImage: profilePictureBase64 != null
              ? MemoryImage(base64Decode(profilePictureBase64!))
              : null,
          child: profilePictureBase64 == null
              ? Icon(
            Icons.person,
            size: 40,
            color: Colors.grey[600], // Darker grey for the icon
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
                    user?.username ?? 'N/A',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.black,
                    onPressed: () {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(user: user!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User data is not available.')),
                        );
                      }
                    },
                  ),
                ],
              ),
              Text(
                user?.email ?? 'N/A',
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
        _buildPendingAppointmentsOption(),
        _buildMenuOption(Icons.help_outline, 'Help', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpPage()),
          );
        }),
        _buildMenuOption(Icons.notifications_none_outlined, 'Notification Setting', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
          );
        }),
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
        _buildMenuOption(Icons.delete_forever, 'Delete Account', _showDeleteAccountConfirmation),
      ],
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    if (user != null) {
      try {
        bool success = await user!.updateAccessStatus('INACTIVE');
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your account has been deactivated.')),
          );
          // Navigate to the main page or login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to deactivate account. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  Widget _buildPastAppointmentsOption() {
    return ListTile(
      leading: Icon(Icons.playlist_add_check_outlined, color: Colors.black),
      title: Text('Past Appointments'),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PastAppointmentList(pastAppointments: pastAppointments),
          ),
        );
      },
    );
  }

  Widget _buildPendingAppointmentsOption() {
    return ListTile(
      leading: Icon(Icons.playlist_add_check_outlined, color: Colors.black),
      title: Text('Pending Appointments'),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PendingAppointmentList(),
          ),
        );
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
