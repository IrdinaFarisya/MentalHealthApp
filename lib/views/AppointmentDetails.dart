import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../model/appointment.dart';
import '../Controller/request_controller.dart';

class AppointmentDetails extends StatefulWidget {
  final Appointment appointment;

  AppointmentDetails({required this.appointment});

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isDone = false;

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

  Future<void> _markAsDone() async {
    setState(() {
      _isDone = true;
    });

    // Update the appointment status and description
    RequestController req = RequestController(path: "/api/appointment.php");
    req.setBody({
      'appointmentId': widget.appointment.appointmentId,
      'status': 'DONE',
      'consultationDescription': _descriptionController.text,
    });
    await req.put();

    if (req.status() == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment marked as done and description saved.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update appointment. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse('${widget.appointment.appointmentDate} ${widget.appointment.appointmentTime}');
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
                  _buildTableRow('Client Name', widget.appointment.username ?? 'N/A'),
                  _buildTableRow('Date', formattedDate),
                  _buildTableRow('Time', formattedTime),
                  _buildTableRow('URL Link', widget.appointment.appointmentLink ?? 'N/A'),
                  _buildTableRow('Status', _isDone ? 'DONE' : (widget.appointment.status ?? 'N/A')),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => _launchURL(context, widget.appointment.appointmentLink ?? ''),
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
              SizedBox(height: 24),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Consultation Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _isDone ? null : _markAsDone,
                  child: Text(
                    'CONSULTED',
                    style: TextStyle(
                      color: _isDone ? Colors.grey : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: _isDone ? Colors.grey : Colors.black, width: 2), backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
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
          child: Text(value, style: TextStyle( fontSize: 18, fontFamily: 'BodoniModa')),
        ),
      ],
    );
  }
}