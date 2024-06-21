import 'dart:convert';
import 'package:flutter/material.dart';
import '../Model/appUser.dart';
import 'package:mentalhealthapp/views/UserLogin.dart';


class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  late final AppUser user;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationpasswordController = TextEditingController();
  bool isPasswordVisible = false;

  void _togglePasswordVisibility() {
    // Toggle the visibility of the password
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }
  void _checkUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmationpassword = confirmationpasswordController.text.trim();

    if (password == confirmationpassword) {
      if (email.isNotEmpty && password.isNotEmpty && confirmationpassword.isNotEmpty) {
        AppUser user = AppUser.getId(email);

        int? userIdResult = await user.getUserId();

        if (userIdResult == 1) {
          int? appUserId = user.appUserId;

          AppUser reset = AppUser.resetPassword(appUserId!, password);

          int resetPasswordResult = await reset.resetPassword() ? 1 : 0;

          if (resetPasswordResult == 1) {
            _AlertMessage1("Password successfully being reset");

            Future.delayed(Duration(seconds: 2), () {
              // Navigate to the login screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin()));
            });
          }
        } else {
          _AlertMessage("Invalid email or password");
        }
      } else {
        _AlertMessage("Please Insert All The Information Needed");
        setState(() {
          emailController.clear();
          passwordController.clear();
          confirmationpasswordController.clear();
        });
      }
    } else {
      _AlertMessage("Confirmation Password not same with the password");
      setState(() {
        emailController.clear();
        passwordController.clear();
        confirmationpasswordController.clear();
      });
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

  void _AlertMessage1(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(msg),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Reset Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white,),
          ),
        ),
        backgroundColor: Colors.lightGreen[800],
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
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0, horizontal:16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
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
              SizedBox(height: 5), // Add some spacing
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0, horizontal:16.0),
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
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 5), // Add some spacing
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0, horizontal:16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirmation Password',
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
                                controller: confirmationpasswordController,
                                obscureText: !isPasswordVisible,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 15), // Add some spacing
              ElevatedButton(
                onPressed: _checkUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set your desired background color here
                ),
                child: const Text('Reset Password',
                    style: TextStyle(fontSize: 18.0,
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}