import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_settings.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';

/// Reminder lead time and notification preferences.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8, left: 4),
            child: Text('Remind me', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Card(
            child: RadioGroup<int>(
              groupValue: settings.reminderLeadDays,
              onChanged: (value) {
                if (value == null) return;
                context.read<SettingsProvider>().setReminderLeadDays(
                      value,
                      itemsToReschedule: context.read<ItemProvider>().items,
                    );
              },
              child: Column(
                children: AppSettings.availableLeadDays.map((days) {
                  return RadioListTile<int>(
                    title: Text('$days day${days == 1 ? '' : 's'} before expiry'),
                    value: days,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Get reminders when items are expiring soon'),
              value: settings.notificationsEnabled,
              onChanged: (value) =>
                  context.read<SettingsProvider>().setNotificationsEnabled(value),
            ),
          ),
        ],
      ),
    );
  }
}
