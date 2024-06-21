/*import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mentalhealthapp/controller/request_controller.dart';
import 'package:mentalhealthapp/model/therapist.dart';
import 'package:mentalhealthapp/views/BookAppointment.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Therapist> therapists = [];

  @override
  void initState() {
    super.initState();
    fetchTherapists();
  }

  Future<void> fetchTherapists() async {
    try {
      RequestController req = RequestController(path: "/api/therapist.php");
      await req.get();

      if (req.status() == 200) {
        List<dynamic> therapistData = jsonDecode(req.result().toString());
        therapists = therapistData.map((data) => Therapist.fromJson(data)).toList();
        setState(() {}); // Trigger a rebuild to update UI
      } else {
        // Handle error
        print('Error fetching therapists: ${req.result()}');
        // Optionally, show an error message to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch therapists. Please try again later.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
      // Optionally, show a network error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Network Error'),
          content: Text('Check your internet connection and try again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Uint8List? _loadImage(String? imageBase64) {
    if (imageBase64 == null || imageBase64.isEmpty) {
      print('Image data is empty');
      return null;
    }

    try {
      // Remove backslashes from the string
      imageBase64 = imageBase64.replaceAll(r'\\', '');

      // Trim the string to remove any leading or trailing whitespaces
      imageBase64 = imageBase64.trim();

      if (imageBase64.startsWith("data:image\/jpeg;base64,")) {
        // Remove the prefix "data:image/jpeg;base64,"
        imageBase64 = imageBase64.substring(imageBase64.indexOf(',') + 1);
      }

      Uint8List decodedImage = base64.decode(imageBase64);

      // Verify that the decoded data is not null
      if (decodedImage.isNotEmpty) {
        return decodedImage;
      } else {
        print('Decoded image is empty');
        return null;
      }
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Therapists',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
      ),
      body: therapists.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildGridView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      itemCount: therapists.length,
      itemBuilder: (context, index) {
        Therapist therapist = therapists[index];
        Uint8List? imageBytes = _loadImage(therapist.TherapistImage?.image);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookAppointment(therapist: therapist),
              ),
            );
          },
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageBytes != null)
                  Expanded(
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    therapist.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    therapist.specialization ?? '',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/Model/appUser.dart';
import 'package:mentalhealthapp/model/therapist.dart';
import 'package:mentalhealthapp/views/BookAppointment.dart';

class AppointmentScreen extends StatefulWidget {

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Therapist> therapists = [];


  @override
  void initState() {
    super.initState();
    _loadTherapists();
  }

  Future<void> _loadTherapists() async {
    try {
      List<Therapist> loadedTherapists = await Therapist.loadImagesStatic();
      setState(() {
        therapists = loadedTherapists;
      });
    } catch (e) {
      print('Error loading therapists: $e');
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find Your Therapists',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'BodoniModa',
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: therapists.length,
                itemBuilder: (context, index) {
                  final therapist = therapists[index];
                  final therapistImage = therapist.TherapistImage;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppointment(
                            therapist: therapist,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      // Add some margin for spacing
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown, width: 2.0),
                        // Customize the border color and width
                        borderRadius: BorderRadius.circular(16),
                        // Match the border radius with the Card
                      ),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (therapistImage != null && therapistImage.image != null)
                              Container(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  child: Image.memory(
                                    base64.decode(therapistImage.image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      therapist.name ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      therapist.specialization ?? '',
                                      style: TextStyle(
                                        color: Colors.brown,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Add more details here if needed
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*Widget _buildListView() {
    return ListView.builder(
      itemCount: therapists.length,
      itemBuilder: (context, index) {
        Therapist therapist = therapists[index];
        Uint8List? imageBytes = _loadImage(therapist.TherapistImage?.image);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookAppointment(therapist: therapist),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            // Add some margin for spacing
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 2.0),
              // Customize the border color and width
              borderRadius: BorderRadius.circular(
                  16), // Match the border radius with the Card
            ),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageBytes != null)
                    Container(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            therapist.name ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            therapist.specialization ?? '',
                            style: TextStyle(
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Add more details here if needed
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


: ListView.builder(
        itemCount: therapists.length,
        itemBuilder: (context, index) {
          var therapist = therapists[index];
          return ListTile(
            title: Text(therapist['name']),
            subtitle: Text(therapist['specialization']),
            // Add more details if needed
            onTap: () {
              // Navigate to therapist details screen or perform action
            },
          );
        },
      ),
    );
  }
}*/

