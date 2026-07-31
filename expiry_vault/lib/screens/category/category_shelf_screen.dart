import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item_category.dart';
import '../../models/pantry_item.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/constants.dart';
import '../../utils/item_query.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_list_tile.dart';
import '../add_edit_item/add_edit_item_screen.dart';
import '../item_detail/item_detail_screen.dart';

/// Items within a single category ("shelf"), with its own sort control and
/// swipe-to-delete.
class CategoryShelfScreen extends StatefulWidget {
  const CategoryShelfScreen({super.key, required this.category});

  final ItemCategory category;

  @override
  State<CategoryShelfScreen> createState() => _CategoryShelfScreenState();
}

class _CategoryShelfScreenState extends State<CategoryShelfScreen> {
  SortOption _sort = SortOption.expiryDate;

  Future<void> _delete(PantryItem item) async {
    await context.read<ItemProvider>().deleteItem(item);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.name} removed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final leadDays = context.watch<SettingsProvider>().reminderLeadDays;
    final allItems = context.watch<ItemProvider>().items;
    final items = ItemQuery.applyFilters(
      allItems,
      category: widget.category,
      sort: _sort,
      thresholdDays: leadDays,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CategoryTile(category: widget.category, size: 32),
            const SizedBox(width: 10),
            Text(widget.category.label),
          ],
        ),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (value) => setState(() => _sort = value),
            itemBuilder: (context) => SortOption.values
                .map((option) => PopupMenuItem(value: option, child: Text('Sort by ${option.label}')))
                .toList(),
          ),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(
              emoji: widget.category.emoji,
              color: widget.category.color,
              title: 'This shelf is empty',
              subtitle: 'Add your first ${widget.category.label.toLowerCase()} item.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Remove this item?'),
                        content: Text('"${item.name}" will be deleted from your vault.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) => _delete(item),
                  child: ItemListTile(
                    item: item,
                    thresholdDays: leadDays,
                    showCategoryEmoji: false,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddEditItemScreen(initialCategory: widget.category),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
    );
  }
}
