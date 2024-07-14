import 'package:flutter/material.dart';
import '../Model/therapist.dart';
import 'package:mentalhealthapp/views/TherapistLogin.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Future<void> _checkUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmationPassword = confirmationPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmationPassword.isEmpty) {
      _showAlertMessage("Please fill in all the required fields.");
      return;
    }

    if (password != confirmationPassword) {
      _showAlertMessage("Passwords do not match.");
      return;
    }

    try {
      Therapist therapist = Therapist();
      therapist.email = email;
      therapist.password = password;

      int? therapistId = await therapist.getTherapistId();
      if (therapistId != null) {
        therapist.therapistId = therapistId;
        bool result = await therapist.resetPassword();
        if (result) {
          _showAlertMessage("Password successfully reset.");
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TherapistLogin()),
            );
          });
        } else {
          _showAlertMessage("Failed to reset password. Please try again.");
        }
      } else {
        _showAlertMessage("Invalid email address.");
      }
    } catch (e) {
      _showAlertMessage("An error occurred. Please try again.");
    }
  }

  void _showAlertMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Reset Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              ClipOval(
                child: Image.asset(
                  'assets/Main.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 50),
              _buildTextField("Email Address", emailController),
              _buildPasswordField("Password", passwordController),
              _buildPasswordField("Confirm Password", confirmationPasswordController),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _checkUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      width: 500,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Container(
      width: 500,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
