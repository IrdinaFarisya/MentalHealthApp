import 'package:flutter/material.dart';

class TermsOfServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms of Services',
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
            _buildSection('Acceptance of Terms', 'You must be at least 18 years old to use our app. By accessing the app, you agree to use it only for lawful purposes and in a manner that does not infringe the rights of, or restrict or inhibit the use and enjoyment of the app by any third party.'),
            _buildSection('User Responsibilities', 'You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device. You agree to accept responsibility for all activities that occur under your account.'),
            _buildSection('Therapist Services', 'The app provides access to mental health services offered by licensed therapists. However, SereneSoul is not responsible for the conduct, performance, or competence of any therapist. The interaction between you and your therapist is strictly between you and the therapist.'),
            _buildSection('Limitation of Liability', 'SereneSoul will not be liable for any damages arising from the use of this app or the services provided through it. This includes, without limitation, direct, indirect, incidental, or consequential damages.'),
            _buildSection('Termination', 'We reserve the right to terminate or suspend your account at any time, without notice, for conduct that we believe violates these Terms, is harmful to other users, or is harmful to our business interests.'),
            _buildSection('Changes to Terms', 'We may modify these Terms at any time. Any changes will be effective immediately upon posting on the app. Your continued use of the app after the posting of revised Terms signifies your acceptance of the changes.'),
            _buildSection('Governing Law', 'These Terms are governed by and construed in accordance with the laws of the country in which SereneSoul is headquartered. You agree to submit to the exclusive jurisdiction of the courts in that location.'),
            _buildSection('Contact Us', 'If you have any questions about these Terms, please contact us at support@serenesoul.com.'),
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
