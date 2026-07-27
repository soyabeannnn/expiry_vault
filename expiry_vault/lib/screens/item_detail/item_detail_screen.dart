import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/pantry_item.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/date_utils.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/status_badge.dart';

/// Full detail view for a single item, with Edit/Delete actions.
class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final itemProvider = context.watch<ItemProvider>();
    final leadDays = context.watch<SettingsProvider>().reminderLeadDays;

    final item = itemProvider.items.firstWhere((i) => i.id == itemId);
    final status = item.statusFor(leadDays);

    return Scaffold(
      appBar: AppBar(title: const Text('Item detail')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: item.photoPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      File(item.photoPath!),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                : CategoryTile(category: item.category, size: 96),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(item.name, style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 8),
          Center(child: StatusBadge(status: status)),
          const SizedBox(height: 8),
          Center(
            child: Text(
              AppDateUtils.friendlyCountdown(item.expiryDate),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailRow(label: 'Category', value: '${item.category.emoji} ${item.category.label}'),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Quantity',
                    value:
                        '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 1)} ${item.unit}',
                  ),
                  const Divider(height: 24),
                  _DetailRow(label: 'Expiry date', value: AppDateUtils.formatDate(item.expiryDate)),
                  if (item.purchaseDate != null) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Purchase date',
                      value: AppDateUtils.formatDate(item.purchaseDate!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}