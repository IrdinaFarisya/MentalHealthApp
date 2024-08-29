import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/therapist.dart'; // Import your Therapist model
import 'package:mentalhealthapp/model/appointment.dart'; // Import your Appointment model
import 'package:mentalhealthapp/model/appUser.dart'; // Import your AppUser model
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/model/NotificationService.dart';

class BookAppointment extends StatefulWidget {
  final Therapist therapist;

  BookAppointment({Key? key, required this.therapist}) : super(key: key);

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  DateTime? selectedDate = DateTime.now();
  String? selectedTimeSlot;

  final List<String> timeSlots = [
    '9:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  late AppUser _appUser; // Instance of AppUser

  @override
  void initState() {
    super.initState();
    _appUser = AppUser();  // Set the email here
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
        backgroundColor: Colors.transparent, // Make the background transparent
        elevation: 0, // Remove the shadow
        centerTitle: true, // Center the title text
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Your Therapist',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildDetailCard(
                icon: Icons.person,
                title: 'Name',
                value: widget.therapist.name ?? '',
              ),
              _buildDetailCard(
                icon: Icons.work,
                title: 'Specialization',
                value: widget.therapist.specialization ?? '',
              ),
              _buildDetailCard(
                icon: Icons.access_time,
                title: 'Availability',
                value: widget.therapist.availability ?? '',
              ),
              _buildDetailCard(
                icon: Icons.location_on,
                title: 'Location',
                value: widget.therapist.location ?? '',
              ),
              SizedBox(height: 16),
              _buildCalendar(),
              SizedBox(height: 16),
              _buildTimeSelector(),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _bookAppointment(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(
                      color: Colors.black, // Set text color to black
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      {required IconData icon, required String title, required String value}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.calendar_today, size: 32),
              title: Text(
                'Select Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CalendarDatePicker(
              initialDate: selectedDate!,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.access_time, size: 32),
              title: Text(
                'Select Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0, // spacing between adjacent boxes
              runSpacing: 8.0, // spacing between lines of boxes
              children: _buildTimeSlots(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeSlots() {
    List<Widget> widgets = [];
    int slotsPerRow = 3; // Number of time slots per row
    double boxWidth = (MediaQuery.of(context).size.width -
        64 -
        (slotsPerRow - 1) *
            8) /
        slotsPerRow; // Calculate box width

    for (String timeSlot in timeSlots) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedTimeSlot = timeSlot;
            });
          },
          child: Container(
            width: boxWidth,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selectedTimeSlot == timeSlot ? Colors.grey : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                timeSlot,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  void _bookAppointment() async {
    int? appUserId = await _appUser.getUserId();
    if (appUserId != null) {
      Appointment appointment = Appointment(
        appUserId: appUserId,
        therapistId: widget.therapist.therapistId,
        appointmentDate: selectedDate?.toIso8601String().split('T')[0],
        appointmentTime: selectedTimeSlot!,
        status: 'PENDING', // Change this to 'PENDING'
      );
      _saveAppointment(appointment);
    } else {
      print('Failed to fetch appUserId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user information. Please try again.')),
      );
    }
  }


  void _saveAppointment(Appointment appointment) async {
    bool success = await appointment.saveAppointment();

    if (success) {
      print('Appointment saved successfully');

      // Schedule a notification for the appointment
      DateTime appointmentDateTime = DateTime.parse('${appointment.appointmentDate} ${appointment.appointmentTime}');
      await NotificationService().scheduleNotification(
        appointment.appointmentId ?? 0, // Use 0 if appointmentId is null
        'Upcoming Appointment',
        'You have an appointment in 1 hour',
        appointmentDateTime.subtract(Duration(hours: 1)),
      );

      // Show success message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')),
      );
    } else {
      print('Failed to save appointment');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment. Please try again.')),
      );
    }
  }
}
