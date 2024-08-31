import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/appointment.dart';
import 'package:mentalhealthapp/views/PendingAppointmentDetails.dart';

class PendingAppointmentList extends StatefulWidget {
  @override
  _PendingAppointmentListState createState() => _PendingAppointmentListState();
}

class _PendingAppointmentListState extends State<PendingAppointmentList> {
  List<Appointment> pendingAppointments = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final appointments = await Appointment.fetchPendingAppointment();
      setState(() {
        pendingAppointments = appointments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching appointments: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : _buildAppointmentList(),
    );
  }

  Widget _buildAppointmentList() {
    return pendingAppointments.isEmpty
        ? Center(child: Text('No pending appointments'))
        : ListView.builder(
      itemCount: pendingAppointments.length,
      itemBuilder: (context, index) {
        Appointment appointment = pendingAppointments[index];
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
                  builder: (context) => PendingAppointmentDetails(appointment: appointment),
                ),
              );
            },
          ),
        );
      },
    );
  }
}