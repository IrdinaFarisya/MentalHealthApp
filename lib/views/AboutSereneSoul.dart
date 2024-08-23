import 'package:flutter/material.dart';

class AboutSereneSoul extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About SereneSoul',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/SereneSoul.jpg', // Replace with the path to your logo asset
              height: 150, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            // Introduction Text
            Text(
              'SereneSoul is a comprehensive mental health app designed to help you manage your well-being with ease and confidence. Our app offers a variety of features including mood tracking, appointment scheduling with licensed therapists, and privacy-focused data management.\n\n'
                  'With SereneSoul, you can track your moods over time, book and manage appointments with mental health professionals, and access resources tailored to your needs. We are committed to providing a secure and supportive environment to help you on your journey to better mental health.\n\n'
                  'Thank you for choosing SereneSoul. We are here to support you every step of the way!',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Arial',
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
