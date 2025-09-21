import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _notificationsEnabled = true;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoaAppBar(
        title: 'Notifications & Nudges',
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: NoaTheme.primary,
          ),
          ListTile(
            title: const Text('Scheduled Time'),
            subtitle: Text(_selectedTime.format(context)),
            onTap: _selectTime,
            enabled: _notificationsEnabled,
          ),
          // TODO: Add quiet hours and weekday selection
        ],
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      _showNotificationPreview();
    }
  }

  void _showNotificationPreview() {
    // TODO: Implement a proper in-app toast notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('This is what a nudge from Noa looks like. We\'ll check in around ${_selectedTime.format(context)}.'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
