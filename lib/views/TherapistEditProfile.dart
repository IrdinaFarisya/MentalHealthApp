import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthapp/model/therapist.dart';
import 'package:mentalhealthapp/model/therapistImage.dart';

class EditProfilePage extends StatefulWidget {
  final Therapist therapist;

  const EditProfilePage({Key? key, required this.therapist}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _otherSpecializationController;
  Uint8List? _profilePicture;
  Uint8List? _supportingDocument;
  String? _selectedSpecialization;
  String? _selectedLocation;

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

  final List<String> locations = [
    'PAHANG', 'PERAK', 'TERENGGANU', 'PERLIS', 'SELANGOR',
    'NEGERI SEMBILAN', 'JOHOR', 'KELANTAN', 'KEDAH',
    'PULAU PINANG', 'MELAKA', 'SABAH', 'SARAWAK',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.therapist.name);
    _emailController = TextEditingController(text: widget.therapist.email);
    _passwordController = TextEditingController();
    _otherSpecializationController = TextEditingController();
    _selectedSpecialization = widget.therapist.specialization;
    _selectedLocation = widget.therapist.location;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Make sure therapistId is not null
      if (widget.therapist.therapistId == null) {
        print("Error: therapistId is null");
        return;
      }

      TherapistImage therapistImage = TherapistImage(
        null, // imageId is null for a new image
        base64Image,
        widget.therapist.therapistId,
      );
      print("Therapist ID: ${widget.therapist.therapistId}");

      bool success = await widget.therapist.saveProfilePicture(therapistImage);
      if (success) {
        print("Profile picture updated successfully");
      } else {
        print("Failed to update profile picture");
      }
    }
  }

  Future<void> _pickSupportingDocument() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? document = await _picker.pickImage(source: ImageSource.gallery);

    if (document != null) {
      final bytes = await document.readAsBytes();
      setState(() {
        _supportingDocument = bytes;
      });
      widget.therapist.supportingDocument = bytes;
    }
  }

  Future<void> _updateProfile() async {
    widget.therapist.name = _nameController.text;
    widget.therapist.email = _emailController.text;
    widget.therapist.specialization = _selectedSpecialization == 'Other'
        ? _otherSpecializationController.text
        : _selectedSpecialization ?? '';
    widget.therapist.location = _selectedLocation;

    if (_passwordController.text.isNotEmpty) {
      widget.therapist.password = _passwordController.text;
    }

    if (_supportingDocument != null) {
      widget.therapist.supportingDocument = _supportingDocument;
    }

    bool success = await widget.therapist.updateProfile();

    if (success && _profilePicture != null) {
      TherapistImage therapistImage = TherapistImage(
        null,
        base64Encode(_profilePicture!),
        widget.therapist.therapistId,
      );
      success = await widget.therapist.saveProfilePicture(therapistImage);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture')),
        );
      }
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicture != null
                      ? MemoryImage(_profilePicture!)
                      : null,
                  child: _profilePicture == null
                      ? Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedSpecialization,
              onChanged: (newValue) {
                setState(() {
                  _selectedSpecialization = newValue;
                });
              },
              items: specializations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Specialization'),
            ),
            if (_selectedSpecialization == 'Other')
              TextField(
                controller: _otherSpecializationController,
                decoration: InputDecoration(labelText: 'Other Specialization'),
              ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              items: locations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password (optional)'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickSupportingDocument,
              child: Text('Upload Supporting Document'),
            ),
            if (_supportingDocument != null)
              Text('Supporting document uploaded'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}