import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentalhealthapp/model/NotificationService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    _loadSettings();
    _checkNotificationPermissions();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? true;
      final hour = prefs.getInt('notificationHour') ?? 8;
      final minute = prefs.getInt('notificationMinute') ?? 0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    });
    print("Settings loaded: Enabled=$_isNotificationEnabled, Time=$_selectedTime");
  }

  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationEnabled', _isNotificationEnabled);
    await prefs.setInt('notificationHour', _selectedTime.hour);
    await prefs.setInt('notificationMinute', _selectedTime.minute);
    print("Settings saved: Enabled=$_isNotificationEnabled, Time=$_selectedTime");
  }

  Future<void> _checkNotificationPermissions() async {
    final iosPlatformChannelSpecifics = NotificationService().flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    if (iosPlatformChannelSpecifics != null) {
      final bool? result = await iosPlatformChannelSpecifics.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      print("Notification permissions granted: $result");
    }
  }

  Future<void> _scheduleDailyNotification(TimeOfDay time) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    await NotificationService().scheduleNotification(
      0,
      'Daily Reminder',
      'Time for your daily check-in!',
      scheduledDate,
    );
    print("Notification scheduled for $scheduledDate");
  }



  void _onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _selectedTime = newTime;
    });
    _saveSettings();
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

  Future<void> _testImmediateNotification() async {
    try {
      await NotificationService().showNotification(
        1,
        'Test Notification',
        'This is a test notification',
      );
      print("Test notification sent");
    } catch (e) {
      print("Error sending test notification: $e");
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
              ElevatedButton(
                onPressed: () async {
                  await NotificationService().showNotification(
                    1,
                    'Test Notification',
                    'This is a test notification',
                  );
                },
                child: Text('Trigger Notification'),
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
