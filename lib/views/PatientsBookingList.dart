import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/appointment.dart';

class PatientsBookingList extends StatefulWidget {
  @override
  _PatientsBookingListState createState() => _PatientsBookingListState();
}

class _PatientsBookingListState extends State<PatientsBookingList> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      List<Appointment> loadedAppointments = await Appointment.loadAppointment();
      setState(() {
        appointments = loadedAppointments;
      });
    } catch (e) {
      print('Error loading appointments: $e');
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'BodoniModa',
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  final dateTime = DateTime.parse('${appointment.appointmentDate} ${appointment.appointmentTime}');
                  final formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
                  final formattedTime = DateFormat('h:mm a').format(dateTime);

                  return Container(
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
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient: ${appointment.username}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text('Date: $formattedDate'),
                            Text('Time: $formattedTime'),
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