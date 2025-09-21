import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _cloudSync = false;
  bool _analytics = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoaAppBar(
        title: 'Settings',
      ),
      body: ListView(
        children: [
          _buildGroupTitle('Data & Privacy'),
          SwitchListTile(
            title: const Text('Enable Cloud Backup'),
            subtitle: const Text('Your data is local-first by default.'),
            value: _cloudSync,
            onChanged: (value) {
              _showCloudSyncDialog(value);
            },
            activeColor: NoaTheme.primary,
          ),
          SwitchListTile(
            title: const Text('Share Analytics'),
            subtitle: const Text('Help improve Noa by sharing anonymous usage data.'),
            value: _analytics,
            onChanged: (value) {
              setState(() {
                _analytics = value;
              });
            },
            activeColor: NoaTheme.primary,
          ),
          const Divider(),
          ListTile(
            title: const Text('Export Your Data'),
            subtitle: const Text('Save your mood history and journal as a CSV file.'),
            onTap: () {
              // TODO: Implement CSV export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting data... (mocked)')),
              );
            },
          ),
          ListTile(
            title: const Text('Delete Account', style: TextStyle(color: NoaTheme.error)),
            subtitle: const Text('Permanently delete your account and all data.'),
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: NoaTheme.small.copyWith(
          color: NoaTheme.mutedText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCloudSyncDialog(bool value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(value ? 'Enable Cloud Sync?' : 'Disable Cloud Sync?'),
        content: Text(
          value
              ? 'This will back up your encrypted data to a secure cloud server.'
              : 'Your data will no longer be backed up and will only be stored on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cloudSync = value;
              });
              Navigator.of(context).pop();
            },
            child: Text(value ? 'Enable' : 'Disable'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This is a permanent action and cannot be undone. Are you sure you want to delete your account and all associated data?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteAccountConfirmationDialog();
            },
            child: const Text('Delete', style: TextStyle(color: NoaTheme.error)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you absolutely sure?'),
        content: const Text(
          'This is your final confirmation. There is no going back.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete account logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deleted. (mocked)')),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Yes, delete my account', style: TextStyle(color: NoaTheme.error)),
          ),
        ],
      ),
    );
  }
}
