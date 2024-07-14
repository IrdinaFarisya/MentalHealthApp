import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/appointment.dart';

class PastAppointmentDetails extends StatelessWidget {
  final Appointment appointment;

  PastAppointmentDetails({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse('${appointment.appointmentDate} ${appointment.appointmentTime}');
    final formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    final formattedTime = DateFormat('h:mm a').format(dateTime);

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past Appointment Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'BodoniModa',
                ),
              ),
              SizedBox(height: 16),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                border: TableBorder.all(color: Colors.grey),
                children: [
                  _buildTableRow('Client Name', appointment.username ?? 'N/A'),
                  _buildTableRow('Date', formattedDate),
                  _buildTableRow('Time', formattedTime),
                  _buildTableRow('Status', 'DONE'),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Consultation Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'BodoniModa',
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.consultationDescription ?? 'No description available',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: TextStyle(fontSize: 16, fontFamily: 'BodoniModa')),
        ),
      ],
    );
  }
}