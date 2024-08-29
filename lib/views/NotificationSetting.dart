import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/NotificationService.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _isNotificationEnabled = true;
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    // Load initial settings here if needed
  }

  Future<void> _scheduleDailyNotification(TimeOfDay time) async {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    await NotificationService().scheduleNotification(
        0,
        'Daily Reminder',
        'Time for your daily check-in!',
        scheduledDate
    );
  }

  void _onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _selectedTime = newTime;
    });
    _scheduleDailyNotification(newTime);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      _onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Setting',
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
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwitchOption(
                icon: Icons.notifications_active_outlined,
                title: 'Enable Notifications',
                value: _isNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isNotificationEnabled = value;
                  });
                  if (!_isNotificationEnabled) {
                    NotificationService().flutterLocalNotificationsPlugin.cancelAll();
                  } else {
                    _scheduleDailyNotification(_selectedTime);
                  }
                },
              ),
              SizedBox(height: 20.0),
              _buildTimePickerOption(
                icon: Icons.access_time,
                title: 'Daily Reminder Time',
                subtitle: '${_selectedTime.format(context)}',
                onTap: () => _selectTime(context),
              ),
              SizedBox(height: 40.0),
              Text(
                'You will receive a daily reminder at the selected time.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildSwitchOption({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildTimePickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
