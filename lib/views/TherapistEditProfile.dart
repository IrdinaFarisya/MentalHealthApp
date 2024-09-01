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
    'Addiction Therapist',
    'Anger Management Counselor',
    'Anxiety Specialist',
    'Behavioral Therapist',
    'Child and Adolescent Therapist',
    'Clinical Psychologist',
    'Cognitive Behavioral Therapist (CBT)',
    'Counseling Psychologist',
    'Depression Specialist',
    'Dialectical Behavior Therapist (DBT)',
    'Eating Disorder Specialist',
    'Grief Counselor',
    'Marriage and Family Therapist',
    'Mindfulness-Based Therapist',
    'Neuropsychologist',
    'Other',
    'Psychoanalyst',
    'Psychiatrist',
    'Stress Management Counselor',
    'Trauma Therapist',
    'Workplace Mental Health Counselor',
  ];

  final List<String> locations = [
    'JOHOR',
    'KEDAH',
    'KELANTAN',
    'MELAKA',
    'NEGERI SEMBILAN',
    'PAHANG',
    'PERAK',
    'PERLIS',
    'PULAU PINANG',
    'SABAH',
    'SARAWAK',
    'SELANGOR',
    'TERENGGANU',
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
                  backgroundColor: Colors.grey, // This sets a background color for the avatar
                  child: _profilePicture != null
                      ? ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey, // Grayscale effect
                      BlendMode.saturation,
                    ),
                    child: Image.memory(
                      _profilePicture!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(Icons.camera_alt, size: 50, color: Colors.white),
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
            OutlinedButton.icon(
              onPressed: _pickSupportingDocument,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Supporting Document'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black, side: const BorderSide(color: Colors.black), // Outline color
              ),
            ),
            if (_supportingDocument != null)
              Text('Supporting document uploaded'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Accepted formats: .JPG, .JPEG, or .PNG. Maximum file size: 2MB.',
                style: TextStyle(
                  color: Colors.grey, // Adjust the color if necessary
                  fontSize: 14, // Adjust the font size if necessary
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.black, // Text color
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Button padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}