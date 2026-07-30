import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/item_query.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_list_tile.dart';
import '../item_detail/item_detail_screen.dart';

/// In-app fallback/summary feed: every item that's expiring soon or already
/// expired, soonest first — works even if the user never sees a push
/// notification.
class ExpiringSoonScreen extends StatelessWidget {
  const ExpiringSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leadDays = context.watch<SettingsProvider>().reminderLeadDays;
    final allItems = context.watch<ItemProvider>().items;
    final items = ItemQuery.needingAttention(allItems, thresholdDays: leadDays);

    return Scaffold(
      appBar: AppBar(title: const Text('Expiring soon')),
      body: items.isEmpty
          ? const EmptyState(
              emoji: '✅',
              color: Color(0xFF5FAE58),
              title: "Nice, everything's fresh",
              subtitle: 'Nothing needs your attention right now.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemListTile(
                  item: item,
                  thresholdDays: leadDays,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
                  ),
                );
              },
            ),
    );
  }
}