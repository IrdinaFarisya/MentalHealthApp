import 'package:flutter/material.dart';
import '../../model/appUser.dart';
import 'dart:convert';
import 'package:mentalhealthapp/views/UserLogin.dart';

void main() {
  runApp(
    MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: const SignUp(),
      ),
    ),
  );
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _signUpState();
}

class _signUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _addUser() async {
    if (_formKey.currentState!.validate()) {
      final String username = usernameController.text.trim();
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String dateOfBirth = dateOfBirthController.text.trim();
      final String phoneNumber = phoneNumberController.text.trim();
      final String accessStatus = 'ACTIVE';
      int appUserId = 0;

      AppUser user = AppUser(
        appUserId: appUserId,
        username: username,
        email: email,
        password: password,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        accessStatus: accessStatus,
      );

      bool saveResult = await user.save();
      if (saveResult) {
        _AlertMessage("Sign Up Successful");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserLogin()));
        });
      } else {
        // Parse the error message
        String errorMessage = "Sign up unsuccessful. Please try again.";
        if (user.lastError != null) {
          // Check if the error contains "Email already registered"
          if (user.lastError!.contains("Email already registered")) {
            errorMessage = "Email already registered. Please use a different email.";
          }
          // Check if the error contains "Phone number already registered"
          else if (user.lastError!.contains("Phone number already registered")) {
            errorMessage = "Phone number already registered. Please use a different phone number.";
          }
        }
        _AlertMessage(errorMessage);
        print("Error during sign up: ${user.lastError}");
      }
    } else {
      _AlertMessage("Please fill out all fields correctly.");
    }
  }

  void _AlertMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
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
            'Account Registration',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'BodoniModa',
              color: Colors.black45,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                _buildTextField(
                  controller: usernameController,
                  label: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                _buildDateField(
                  controller: dateOfBirthController,
                  label: 'Date of Birth',
                  context: context,
                  onTap: () => _selectDate(context),
                ),
                _buildTextField(
                  controller: phoneNumberController,
                  label: 'Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              textAlign: TextAlign.center, // Center the input text
              validator: (value) {
                String? result = validator(value);
                if (result != null && result.isNotEmpty) {
                  return result; // Return the centered error message
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    textAlign: TextAlign.center, // Center the input text
                    onTap: onTap,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
