import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/appointment.dart';
import 'AcceptAppointment.dart';

class PatientsBookingList extends StatefulWidget {
  @override
  _PatientsBookingListState createState() => _PatientsBookingListState();
}

class _PatientsBookingListState extends State<PatientsBookingList> {
  List<Appointment> pendingAppointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Appointment> loadedAppointments = await Appointment.loadAppointment();
      setState(() {
        pendingAppointments = loadedAppointments.where((appointment) => appointment.status == 'PENDING').toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading appointments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToAcceptAppointment(Appointment appointment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptAppointment(appointment: appointment),
      ),
    );

    if (result == true) {
      // Appointment was accepted, reload the appointments list
      _loadAppointments();
      // Return true to TherapistHomePage
      Navigator.pop(context, true);
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
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : pendingAppointments.isEmpty
                  ? _buildNoAppointmentsWidget()
                  : ListView.builder(
                itemCount: pendingAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = pendingAppointments[index];
                  final dateTime = DateTime.parse('${appointment.appointmentDate} ${appointment.appointmentTime}');
                  final formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
                  final formattedTime = DateFormat('h:mm a').format(dateTime);

                  return GestureDetector(
                    onTap: () => _navigateToAcceptAppointment(appointment),
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
                              SizedBox(height: 8),
                              Text(
                                'Status: ${_getStatusText(appointment.status)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(appointment.status),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildNoAppointmentsWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16.0),
            Text(
              'No pending appointments',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'BodoniModa',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'PENDING':
        return 'Pending';
      case 'ACCEPTED':
        return 'Accepted';
      case 'REJECTED':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
