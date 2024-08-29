import 'package:flutter/material.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/views/MoodTrackerOverview.dart';
import 'package:mentalhealthapp/views/ResourcePage.dart';
import 'package:mentalhealthapp/views/UserHome.dart';
import 'package:mentalhealthapp/views/UserProfile.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildNavItem(context, Icons.home_outlined, Icons.home, 'Home', 0),
          _buildNavItem(context, Icons.mood_outlined, Icons.mood, 'Mood', 1),
          _buildNavItem(context, Icons.group_outlined, Icons.group, 'Therapists', 2),
          _buildNavItem(context, Icons.file_copy_outlined, Icons.file_copy, 'Resources', 3),
          _buildNavItem(context, Icons.person_outline, Icons.person, 'Profile', 4),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showUnselectedLabels: true,
        onTap: (index) {
          onTap(index);
          _navigateToPage(context, index);
        },
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(BuildContext context, IconData outlinedIcon, IconData filledIcon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          currentIndex == index ? filledIcon : outlinedIcon,
          color: currentIndex == index ? Colors.black : Colors.grey,
        ),
      ),
      label: label,
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    final routes = [
      UserHomePage(),
      MoodTrackerOverview(),
      AppointmentScreen(),
      ResourcePage(),
      UserProfilePage(),
    ];

    if (index >= 0 && index < routes.length) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => routes[index],
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }
}