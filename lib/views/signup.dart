import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/appUser.dart';
//import 'login.dart';
import 'dart:io';

File? _imageFile;


void main() {
  runApp(
    MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr, // or TextDirection.rtl
        child: const signUp(),
      ),
    ),
  );
}

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
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

  void _addUser(File? profilePicture) async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String dateOfBirth = dateOfBirthController.text.trim();
    final String phoneNumber = phoneNumberController.text.trim();
    final String accessStatus = 'ACTIVE';
    int appUserId = 0;
    int roleId=2;
    Uint8List profilePicture=Uint8List(0);


    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && dateOfBirth.isNotEmpty && phoneNumber.isNotEmpty) {
      AppUser user = AppUser(appUserId, username, email, password, dateOfBirth, phoneNumber, accessStatus, roleId, profilePicture);

      if (await user.save()) {
        setState(() {
          usernameController.clear();
          emailController.clear();
          passwordController.clear();
          dateOfBirthController.clear();
          phoneNumberController.clear();
        });
        _AlertMessage("Sign Up Successful");
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => signIn()));
        });
      } else {
        _AlertMessage("SIGNUP UNSUCCESSFUL: Email has been registered");
      }
    } else {
      _AlertMessage("Please Insert All The Information Needed");
      setState(() {
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        dateOfBirthController.clear();
        phoneNumberController.clear();
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

  void _selectImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);


    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text("Let's Begin Your Beautiful Journey!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 15),
              ClipOval(
                child: Image.asset(
                  'assets/Main.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15),
              _buildTextField("Username", usernameController),
              _buildTextField("Email", emailController),
              _buildTextField("Password", passwordController),
              _buildDateField("Date of Birth", dateOfBirthController, context),
              _buildTextField("Phone Number", phoneNumberController),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => _addUser(_imageFile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: _selectImage,
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildDateField(String labelText, TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}