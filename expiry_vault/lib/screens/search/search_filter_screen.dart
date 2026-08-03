import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item_category.dart';
import '../../models/item_status.dart';
import '../../providers/filter_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/constants.dart';
import '../../utils/item_query.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_list_tile.dart';
import '../item_detail/item_detail_screen.dart';

/// Search across every item with category/status filters and sorting,
/// backed by [FilterProvider] so the chosen filters persist while the tab
/// stays alive in the shell's `IndexedStack`.
class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = context.watch<FilterProvider>();
    final leadDays = context.watch<SettingsProvider>().reminderLeadDays;
    final allItems = context.watch<ItemProvider>().items;
    final items = ItemQuery.applyFilters(
      allItems,
      query: filters.searchQuery,
      category: filters.categoryFilter,
      status: filters.statusFilter,
      sort: filters.sortOption,
      thresholdDays: leadDays,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            initialValue: filters.sortOption,
            onSelected: (value) => context.read<FilterProvider>().setSortOption(value),
            itemBuilder: (context) => SortOption.values
                .map((option) => PopupMenuItem(value: option, child: Text('Sort by ${option.label}')))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: (value) => context.read<FilterProvider>().setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search your vault…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filters.searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => context.read<FilterProvider>().setSearchQuery(''),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryChip(
                  selected: filters.categoryFilter == null,
                  label: 'All',
                  onTap: () => context.read<FilterProvider>().setCategoryFilter(null),
                ),
                const SizedBox(width: 8),
                ...ItemCategory.values.map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CategoryChip(
                        selected: filters.categoryFilter == category,
                        label: '${category.emoji} ${category.label}',
                        onTap: () => context.read<FilterProvider>().setCategoryFilter(
                              filters.categoryFilter == category ? null : category,
                            ),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ItemStatus.values
                  .map((status) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(status.label),
                          selected: filters.statusFilter == status,
                          onSelected: (_) => context.read<FilterProvider>().setStatusFilter(
                                filters.statusFilter == status ? null : status,
                              ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? const EmptyState(
                    emoji: '🔍',
                    title: 'No matches',
                    subtitle: 'Try a different search term or filter.',
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
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.selected, required this.label, required this.onTap});

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
