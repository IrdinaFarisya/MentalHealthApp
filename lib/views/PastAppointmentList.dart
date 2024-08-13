import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/appointment.dart';
import 'PastAppointmentDetails.dart';

class PastAppointmentList extends StatelessWidget {
  final List<Appointment> pastAppointments;

  PastAppointmentList({required this.pastAppointments});

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
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Past Appointments',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'BodoniModa',
              ),
            ),
          ),
          Expanded(
            child: pastAppointments.isEmpty
                ? Center(child: Text('No past appointments'))
                : ListView.builder(
              itemCount: pastAppointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = pastAppointments[index];
                final dateTime = DateTime.parse('${appointment.appointmentDate} ${appointment.appointmentTime}');
                final formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
                final formattedTime = DateFormat('h:mm a').format(dateTime);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(appointment.name ?? 'N/A'),
                    subtitle: Text('$formattedDate at $formattedTime'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PastAppointmentDetails(appointment: appointment),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
