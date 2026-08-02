import 'package:flutter/material.dart';

import '../models/pantry_item.dart';
import '../utils/date_utils.dart';
import 'category_tile.dart';
import 'status_badge.dart';

/// Item row used by the Category Shelf, Search, and Expiring Soon screens.
class ItemListTile extends StatelessWidget {
  const ItemListTile({
    super.key,
    required this.item,
    required this.thresholdDays,
    required this.onTap,
    this.showCategoryEmoji = true,
  });

  final PantryItem item;
  final int thresholdDays;
  final VoidCallback onTap;
  final bool showCategoryEmoji;

  @override
  Widget build(BuildContext context) {
    final status = item.statusFor(thresholdDays);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (showCategoryEmoji) ...[
                CategoryTile(category: item.category, size: 44),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 1)} ${item.unit} · ${AppDateUtils.formatDate(item.expiryDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(status: status, compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
