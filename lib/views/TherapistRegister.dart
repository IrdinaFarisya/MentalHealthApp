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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otherSpecializationController = TextEditingController();

  String? selectedSpecialization;
  String? selectedLocation;
  File? supportingDocument;

  final List<String> specializations = [
    'Clinical Psychologist',
    'Counseling Psychologist',
    'Child and Adolescent Therapist',
    'Marriage and Family Therapist',
    'Cognitive Behavioral Therapist (CBT)',
    'Dialectical Behavior Therapist (DBT)',
    'Trauma Therapist',
    'Addiction Therapist',
    'Grief Counselor',
    'Anger Management Counselor',
    'Anxiety Specialist',
    'Depression Specialist',
    'Eating Disorder Specialist',
    'Stress Management Counselor',
    'Workplace Mental Health Counselor',
    'Psychoanalyst',
    'Neuropsychologist',
    'Behavioral Therapist',
    'Psychiatrist',
    'Mindfulness-Based Therapist',
    'Other',
  ];

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
    if (_formKey.currentState!.validate() && supportingDocument != null && selectedLocation != null) {
      final String name = nameController.text.trim();
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String specialization = selectedSpecialization == 'Other'
          ? otherSpecializationController.text.trim()
          : selectedSpecialization ?? '';

      Uint8List supportingDocumentBytes = await supportingDocument!.readAsBytes();

      Therapist therapist = Therapist(
        therapistId: 0,
        name: name,
        email: email,
        password: password,
        specialization: specialization,
        location: selectedLocation,
        supportingDocument: supportingDocumentBytes,
        availability: "",
        accessStatus: 'ACTIVE',
        approvalStatus: 'PENDING',
      );

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
      _showMessage("Please complete all required fields");
    }
  }

  void _clearFields() {
    setState(() {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      otherSpecializationController.clear();
      selectedSpecialization = null;
      supportingDocument = null;
      selectedLocation = null;
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validateName,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                DropdownButtonFormField<String>(
                  value: selectedSpecialization,
                  onChanged: (newValue) {
                    setState(() {
                      selectedSpecialization = newValue;
                    });
                  },
                  items: specializations.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    prefixIcon: Icon(Icons.work),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Specialization is required';
                    }
                    return null;
                  },
                ),
                if (selectedSpecialization == 'Other')
                  TextFormField(
                    controller: otherSpecializationController,
                    decoration: const InputDecoration(
                      labelText: 'Please specify your specialization',
                      prefixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (selectedSpecialization == 'Other' &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please specify your specialization';
                      }
                      return null;
                    },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location is required';
                    }
                    return null;
                  },
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
                    child: Text('Selected file: ${supportingDocument!.path.split('/').last}'),
                  ),
                const SizedBox(height: 16),
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
      ),
    );
  }
}
