import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../model/appointment.dart';

class UserAppointmentDetails extends StatelessWidget {
  final Appointment appointment;

  UserAppointmentDetails({required this.appointment});

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the URL. Please try again.')),
      );
    }
  }

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
                'Appointment Details',
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
                  _buildTableRow('Therapist Name', appointment.name ?? 'N/A'),
                  _buildTableRow('Date', formattedDate),
                  _buildTableRow('Time', formattedTime),
                  _buildTableRow('URL Link', appointment.appointmentLink ?? 'N/A'),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => _launchURL(context, appointment.appointmentLink ?? ''),
                  child: Text(
                    'Join Google Meet',
                    style: TextStyle(color: Colors.white, fontSize: 15,),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  ),
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
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: TextStyle( fontSize: 18,
              fontFamily: 'BodoniModa')),
        ),
      ],
    );
  }
}
