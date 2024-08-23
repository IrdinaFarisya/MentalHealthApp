import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Data Collection', 'We collect personal information that you voluntarily provide to us when registering for an account, such as your name, email address, and other relevant information. We also collect information about your usage of the app, including your mood entries, appointments, and interactions with therapists.'),
            _buildSection('Use of Data', 'We use your information to provide and improve our services, to communicate with you, and to ensure a safe and personalized experience. Your data may be used to match you with suitable therapists and to monitor your progress within the app.'),
            _buildSection('Data Sharing', 'We do not share your personal information with third parties without your consent, except as required by law or to protect your safety. Therapists who have access to your information are bound by confidentiality agreements.'),
            _buildSection('Data Security', 'We implement security measures to protect your information from unauthorized access, alteration, or disclosure. However, no internet transmission is completely secure, and we cannot guarantee the absolute security of your data.'),
            _buildSection('Your Rights', 'You have the right to access, update, or delete your personal information at any time. You may also withdraw your consent to the processing of your data, subject to legal or contractual restrictions.'),
            _buildSection('Contact Us', 'If you have any questions or concerns about our Privacy Policy, please contact us at privacy@serenesoul.com.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'BodoniModa',
            ),
          ),
          SizedBox(height: 6),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Arial',
            ),
          ),
        ],
      ),
    );
  }
}
