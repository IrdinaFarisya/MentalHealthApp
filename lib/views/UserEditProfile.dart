import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/model/appUserImage.dart';

class EditProfilePage extends StatefulWidget {
  final AppUser user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  Uint8List? _profilePicture;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
    _passwordController = TextEditingController();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _profilePicture = bytes;
      });
    }
  }

  Future<void> _updateProfile() async {
    widget.user.username = _usernameController.text;
    widget.user.email = _emailController.text;
    widget.user.phoneNumber = _phoneNumberController.text;

    if (_passwordController.text.isNotEmpty) {
      widget.user.password = _passwordController.text;
    }

    bool success = await widget.user.updateProfile();

    if (success && _profilePicture != null) {
      // Create the AppUserImage object with base64-encoded image data
      AppUserImage userImage = AppUserImage(
        null,
        base64Encode(_profilePicture!),
        widget.user.appUserId,
      );
      success = await widget.user.saveProfilePicture(userImage);
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
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password (optional)'),
              obscureText: true,
            ),
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
