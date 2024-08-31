import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/views/TherapistHome.dart';
import 'package:mentalhealthapp/views/TherapistRegister.dart';
import '../../model/therapist.dart';
import 'package:mentalhealthapp/model/admin.dart';
import 'package:mentalhealthapp/views/AdminHome.dart';
//import 'forgotpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/views/TherapistForgotPassword.dart';

class TherapistLogin extends StatefulWidget {
  const TherapistLogin({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<TherapistLogin> {
  late final Therapist therapist;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  void _checkUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _AlertMessage("PLEASE INSERT ALL THE INFORMATION NEEDED");
    } else if (!isValidEmail(email)) {
      _AlertMessage("INVALID EMAIL ADDRESS");
    } else {
      print('Checking user existence...');

      // Check if it's an admin
      Admin admin = Admin.empty();
      if (await admin.checkAdminExistence(email, password)) {
        // It's an admin
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome(admin: admin)));
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('therapistEmail', email);

        // Check if it's a therapist
        Therapist therapist = Therapist(
          email: email,
          password: password,
        );

        if (await therapist.checkTherapistExistence()) {
          if (therapist.approvalStatus == 'APPROVED') {
            setState(() {
              emailController.clear();
              passwordController.clear();
            });
            _showMessage("Login Successful");
            Navigator.push(context, MaterialPageRoute(builder: (context) => TherapistHomePage()));
          } else if (therapist.approvalStatus == 'PENDING') {
            _AlertMessage("YOUR ACCOUNT IS PENDING APPROVAL");
          } else {
            _AlertMessage("YOUR APPLICATION HAS BEEN REJECTED");
          }
        } else {
          _AlertMessage("EMAIL OR PASSWORD IS WRONG");
        }
      }
    }
  }


  void _AlertMessage(String msg) {
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

  void _showMessage(String msg){
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  void _forgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetPage()), // tba
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'SereneSoul',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                fontFamily: 'BodoniModa',
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: <Color>[Colors.black, Colors.brown],
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Set the background color to transparent
        //automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ClipRect(
                child: Image.asset(
                  'assets/therapistlogin.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1),
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
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
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: Icon(
                                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: _forgetPassword,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: _checkUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  '  Login  ',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TherapistRegister()),//change when signup already implemented
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
