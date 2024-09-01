import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/therapist.dart';
import 'package:mentalhealthapp/views/BookAppointment.dart';
import 'package:mentalhealthapp/model/NavigationBar.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Therapist> therapists = [];
  List<Therapist> filteredTherapists = [];
  int _selectedIndex = 2;
  String? selectedSpecialization;

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
        filteredTherapists = loadedTherapists;
      });
    } catch (e) {
      print('Error loading therapists: $e');
    }
  }

  void _showSpecializationInfo(String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Specialization Details'),
          content: Text(description),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Sort the specializations alphabetically
        List<String> sortedSpecializations = [
          ...Set<String>.from(therapists.map((t) => t.specialization ?? 'Unknown'))
        ]..sort();

        return AlertDialog(
          title: Text('Filter by Specialization'),
          content: DropdownButton<String>(
            value: selectedSpecialization,
            hint: Text('Select Specialization'),
            onChanged: (String? newValue) {
              setState(() {
                selectedSpecialization = newValue;
                if (newValue == null) {
                  filteredTherapists = therapists;
                } else {
                  filteredTherapists = therapists
                      .where((therapist) =>
                  therapist.specialization == newValue)
                      .toList();
                }
              });
              Navigator.of(context).pop();
            },
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text('All Specializations'),
              ),
              ...sortedSpecializations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
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
        backgroundColor: Colors.green[50],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose Your Therapists',
                  style: TextStyle(
                    fontFamily: 'LibreBaskerville',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showFilterDialog,
                  child: Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTherapists.length,
                itemBuilder: (context, index) {
                  final therapist = filteredTherapists[index];

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
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Card(
                              color: Colors.white,
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            therapist.specialization ?? '',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.info_outline),
                                          onPressed: () {
                                            _showSpecializationInfo(
                                              therapist.specializationDescription ?? 'No description available',
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}