import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item_category.dart';
import '../../models/item_status.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/item_status_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';
import '../add_edit_item/add_edit_item_screen.dart';
import '../category/category_shelf_screen.dart';
import '../expiring_feed/expiring_soon_screen.dart';

/// "The Vault" — the illustrated fridge/pantry home screen. Shelves are
/// colored tiles per category (brand board pattern) with live item counts,
/// plus a status summary strip for an at-a-glance read of the whole household.
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ItemProvider>().items;
    final leadDays = context.watch<SettingsProvider>().reminderLeadDays;

    final counts = {ItemStatus.fresh: 0, ItemStatus.expiringSoon: 0, ItemStatus.expired: 0};
    for (final item in items) {
      final status = ItemStatusService.computeStatus(item.expiryDate, leadDays);
      counts[status] = (counts[status] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.vaultBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.lock_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('ExpiryVault'),
          ],
        ),
      ),
      body: items.isEmpty
          ? EmptyState(
              emoji: '🥬',
              title: "Your vault is empty — let's stock it up!",
              subtitle: 'Tap the + button below to add your first item.',
              action: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddEditItemScreen()),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add item'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatusSummaryCard(
                        count: counts[ItemStatus.fresh]!,
                        status: ItemStatus.fresh,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ExpiringSoonScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatusSummaryCard(
                        count: counts[ItemStatus.expiringSoon]!,
                        status: ItemStatus.expiringSoon,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ExpiringSoonScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatusSummaryCard(
                        count: counts[ItemStatus.expired]!,
                        status: ItemStatus.expired,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ExpiringSoonScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Your shelves'),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: ItemCategory.values.map((category) {
                    final count = items.where((i) => i.category == category).length;
                    return _ShelfCard(
                      category: category,
                      count: count,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CategoryShelfScreen(category: category),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditItemScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatusSummaryCard extends StatelessWidget {
  const _StatusSummaryCard({required this.count, required this.status, required this.onTap});

  final int count;
  final ItemStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: status.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(status.icon, size: 16, color: status.color),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: status.textColor),
            ),
            const SizedBox(height: 2),
            Text(
              status.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: status.textColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShelfCard extends StatelessWidget {
  const _ShelfCard({required this.category, required this.count, required this.onTap});

  final ItemCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 26)),
            Text(
              category.label,
              style: TextStyle(
                color: category.onColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              '$count item${count == 1 ? '' : 's'}',
              style: TextStyle(color: category.onColor.withValues(alpha: 0.85), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
