import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_settings.dart';
import '../../models/item_category.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/category_tile.dart';

/// Reminder timing, category legend, and app info. Maps to the brief's
/// "Profile/Settings" screen (reminder timing + category reference).
class SettingsScreen extends StatelessWidget {
const SettingsScreen({super.key});

@override
Widget build(BuildContext context) {
final settings = context.watch<SettingsProvider>();
final items = context.watch<ItemProvider>().items;

return Scaffold(
appBar: AppBar(title: const Text('Settings')),
body: ListView(
padding: const EdgeInsets.all(20),
children: [
Text('Reminders', style: Theme.of(context).textTheme.titleLarge),
const SizedBox(height: 8),
Text(
'Get a friendly nudge before something in your vault expires.',
style: Theme.of(context).textTheme.bodyMedium,
),
const SizedBox(height: 16),
Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('Notify me before expiry', style: Theme.of(context).textTheme.titleMedium),
Switch(
value: settings.notificationsEnabled,
onChanged: (value) => settings.setNotificationsEnabled(value),
activeThumbColor: AppColors.vaultBlue,
),
],
),
const SizedBox(height: 12),
Wrap(
spacing: 10,
children: AppSettings.availableLeadDays.map((days) {
final selected = settings.reminderLeadDays == days;
return ChoiceChip(
label: Text(days == 1 ? '1 day before' : '$days days before'),
selected: selected,
onSelected: (_) =>
settings.setReminderLeadDays(days, itemsToReschedule: items),
labelStyle: TextStyle(color: selected ? Colors.white : null),
);
}).toList(),
),
],
),
),
),
  const SizedBox(height: 28),
  Text('Categories', style: Theme.of(context).textTheme.titleLarge),
  const SizedBox(height: 12),
  Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: ItemCategory.values
            .map(
              (category) => ListTile(
            leading: CategoryTile(category: category, size: 36),
            title: Text(category.label),
            trailing: Text(
              '${items.where((i) => i.category == category).length} items',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        )
            .toList(),
      ),
    ),
  ),
  const SizedBox(height: 28),
  Text('About', style: Theme.of(context).textTheme.titleLarge),
  const SizedBox(height: 12),
  Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ExpiryVault', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Never let your fridge surprise you again. Built with Flutter for '
                'CSC2074 Mobile Application Development.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text('Version 1.0.0', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  ),
],
),
);
}
}