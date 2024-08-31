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
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  final List<String> timeSlots = [
    '09:00',
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
          child: Form(
            key: _formKey,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _bookAppointment();
                      }
                    },
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
    DateTime now = DateTime.now();

    // Debug: Print the selected time slot
    print('Selected time slot: $selectedTimeSlot');

    // Ensure time slot format is correct
    if (selectedTimeSlot == null || !RegExp(r'^\d{1,2}:\d{2}$').hasMatch(selectedTimeSlot!)) {
      print('Invalid time slot format: $selectedTimeSlot');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid time slot format.')),
      );
      return;
    }

    // Construct the DateTime object for the selected appointment time
    try {
      String timeSlot = selectedTimeSlot!;
      List<String> timeParts = timeSlot.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      DateTime selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        hour,
        minute,
      );

      // Debug: Print the current time and selected appointment time
      print('Current time: $now');
      print('Selected appointment time: $selectedDateTime');

      // Check if the selected time is in the past
      if (selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected time is in the past. Please choose a future time.')),
        );
        return;
      }

      // Proceed with booking the appointment
      int? appUserId = await _appUser.getUserId();
      if (appUserId != null) {
        Appointment appointment = Appointment(
          appUserId: appUserId,
          therapistId: widget.therapist.therapistId,
          appointmentDate: selectedDate?.toIso8601String().split('T')[0],
          appointmentTime: selectedTimeSlot!,
          status: 'PENDING',
        );
        _saveAppointment(appointment);
      } else {
        print('Failed to fetch appUserId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user information. Please try again.')),
        );
      }
    } catch (e) {
      print('Error parsing DateTime: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while booking the appointment.')),
      );
    }
  }

  void _saveAppointment(Appointment appointment) async {
    // Construct the DateTime string in the required format
    String appointmentDateTimeString = '${appointment.appointmentDate} ${appointment.appointmentTime}:00';
    DateTime appointmentDateTime;

    try {
      appointmentDateTime = DateTime.parse(appointmentDateTimeString);
    } catch (e) {
      print('Error parsing DateTime: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid appointment date and time.')),
      );
      return;
    }

    bool success = await appointment.saveAppointment();

    if (success) {
      print('Appointment saved successfully');

      // Schedule a notification for the appointment
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
