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

/// Live search bar + category/status filter chips + sort control, reusing
/// the shared `ItemQuery` pipeline and `ItemListTile`.
class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterProvider>();
    final leadDays = context.watch<SettingsProvider>().reminderLeadDays;
    final allItems = context.watch<ItemProvider>().items;

    final items = ItemQuery.applyFilters(
      allItems,
      query: filter.searchQuery,
      category: filter.categoryFilter,
      status: filter.statusFilter,
      sort: filter.sortOption,
      thresholdDays: leadDays,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Search & filter')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (value) => context.read<FilterProvider>().setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search items…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filter.searchQuery.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.read<FilterProvider>().setSearchQuery(''),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'All categories',
                  selected: filter.categoryFilter == null,
                  onTap: () => context.read<FilterProvider>().setCategoryFilter(null),
                ),
                const SizedBox(width: 8),
                ...ItemCategory.values.map(
                      (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: '${category.emoji} ${category.label}',
                      selected: filter.categoryFilter == category,
                      onTap: () => context.read<FilterProvider>().setCategoryFilter(
                        filter.categoryFilter == category ? null : category,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'All statuses',
                  selected: filter.statusFilter == null,
                  onTap: () => context.read<FilterProvider>().setStatusFilter(null),
                ),
                const SizedBox(width: 8),
                ...ItemStatus.values.map(
                      (status) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: status.label,
                      selected: filter.statusFilter == status,
                      onTap: () => context.read<FilterProvider>().setStatusFilter(
                        filter.statusFilter == status ? null : status,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<SortOption>(
                  initialValue: filter.sortOption,
                  onSelected: (value) => context.read<FilterProvider>().setSortOption(value),
                  itemBuilder: (context) => SortOption.values
                      .map((option) => PopupMenuItem(value: option, child: Text(option.label)))
                      .toList(),
                  child: Chip(
                    avatar: const Icon(Icons.sort, size: 16),
                    label: Text('Sort: ${filter.sortOption.label}'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? const EmptyState(
              emoji: '🔍',
              title: 'No items match',
              subtitle: 'Try a different search term or clear your filters.',
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}