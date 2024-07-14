import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../model/therapist.dart';
import 'ThankYouPage.dart';

class TherapistRegister extends StatefulWidget {
  const TherapistRegister({Key? key}) : super(key: key);

  @override
  State<TherapistRegister> createState() => _TherapistRegisterState();
}

class _TherapistRegisterState extends State<TherapistRegister> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();

  String? selectedLocation;
  File? supportingDocument;

  final List<String> location = [
    'PAHANG', 'PERAK', 'TERENGGANU', 'PERLIS', 'SELANGOR',
    'NEGERI SEMBILAN', 'JOHOR', 'KELANTAN', 'KEDAH',
    'PULAU PINANG', 'MELAKA', 'SABAH', 'SARAWAK',
  ];

  Future<void> _pickSupportingDocument() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        supportingDocument = File(pickedFile.path);
      });
    }
  }

  void _addUser() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String specialization = specializationController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty &&
        specialization.isNotEmpty && supportingDocument != null && selectedLocation != null) {

      Uint8List supportingDocumentBytes = await supportingDocument!.readAsBytes();

      Therapist therapist = Therapist(
          therapistId: 0,
          name: name,
          email: email,
          password: password,
          specialization: specialization,
          location: selectedLocation,
          supportingDocument: supportingDocumentBytes,
          availability: "", // Add this line
          accessStatus: 'ACTIVE',
          approvalStatus: 'PENDING',

      );

      // Print the data being sent
      print('Sending data to server:');
      print(therapist.toJson());

      if (await therapist.saveTherapist()) {
        _clearFields();
        _showMessage("Application successful");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ThankYouPage()));
        });
      } else {
        _showMessage("SIGNUP UNSUCCESSFUL: Email has been registered");
      }
    } else {
      _showMessage("Please Insert All The Information Needed");
    }
  }

  void _clearFields() {
    setState(() {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      specializationController.clear();
      supportingDocument = null;
      selectedLocation = null;
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.transparent, // Make the background transparent
        elevation: 0, // Remove the shadow
        centerTitle: true, // Center the title text
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Therapist Application',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'BodoniModa',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              TextField(
                controller: specializationController,
                decoration: const InputDecoration(
                  labelText: 'Specialization',
                  prefixIcon: Icon(Icons.work),
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
                items: location.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickSupportingDocument,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Supporting Document'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black, side: const BorderSide(color: Colors.black), // Outline color
                ),
              ),
              if (supportingDocument != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Document uploaded: ${supportingDocument!.path.split('/').last}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _addUser,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Apply', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Button padding
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
