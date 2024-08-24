import 'package:flutter/material.dart';
import '../model/appointment.dart';
import '../Controller/request_controller.dart';

class AcceptAppointment extends StatefulWidget {
  final Appointment appointment;

  AcceptAppointment({required this.appointment});

  @override
  _AcceptAppointmentState createState() => _AcceptAppointmentState();
}

class _AcceptAppointmentState extends State<AcceptAppointment> {
  final TextEditingController _urlController = TextEditingController();

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
              border: TableBorder.all(color: Colors.brown),
              children: [
                _buildTableRow('Patient', widget.appointment.username ?? 'N/A'),
                _buildTableRow('Date', widget.appointment.appointmentDate ?? 'N/A'),
                _buildTableRow('Time', widget.appointment.appointmentTime ?? 'N/A'),
                _buildTableRow('Status', widget.appointment.status ?? 'Unknown'),              ],
            ),
            SizedBox(height: 24),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Meeting URL',
                hintText: 'Enter the online meeting URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _acceptAppointment,
                child: Text(
                  'Accept Appointment',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  void _acceptAppointment() async {
    print('Appointment ID: ${widget.appointment.appointmentId}');
    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a meeting URL')),
      );
      return;
    }

    try {
      RequestController req = RequestController(path: "/api/appointment.php");
      req.setBody({
        'appointmentId': widget.appointment.appointmentId,
        'status': 'ACCEPTED',
        'appointmentLink': _urlController.text,
      });
      await req.put();

      print('Response status: ${req.status()}');
      print('Response body: ${req.result()}');

      if (req.status() == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment accepted successfully')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to accept appointment: ${req.result()}');
      }
    } catch (e) {
      print('Error accepting appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}