import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
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
      List<Therapist> loadedTherapists = await Therapist.fetchTherapist();
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
        title: Text(
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
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown, width: 2.0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
