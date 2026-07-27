import 'package:flutter_test/flutter_test.dart';
import 'package:pantry_pal/models/item_category.dart';
import 'package:pantry_pal/models/item_status.dart';
import 'package:pantry_pal/models/pantry_item.dart';
import 'package:pantry_pal/utils/constants.dart';
import 'package:pantry_pal/utils/item_query.dart';

PantryItem _item({
  required String name,
  required ItemCategory category,
  required DateTime expiryDate,
  DateTime? createdAt,
}) {
  return PantryItem(
    id: name,
    name: name,
    category: category,
    quantity: 1,
    unit: 'pcs',
    expiryDate: expiryDate,
    createdAt: createdAt ?? DateTime(2026, 1, 1),
  );
}

void main() {
  final today = DateTime(2026, 7, 11);

  final milk = _item(
    name: 'Milk',
    category: ItemCategory.dairy,
    expiryDate: DateTime(2026, 7, 12),
    createdAt: DateTime(2026, 7, 1),
  );
  final apple = _item(
    name: 'Apple',
    category: ItemCategory.produce,
    expiryDate: DateTime(2026, 7, 20),
    createdAt: DateTime(2026, 7, 5),
  );
  final pills = _item(
    name: 'Painkillers',
    category: ItemCategory.medicine,
    expiryDate: DateTime(2026, 1, 1),
    createdAt: DateTime(2026, 7, 10),
  );
  final items = [milk, apple, pills];

  group('applyFilters', () {
    test('filters by category', () {
      final result = ItemQuery.applyFilters(
        items,
        category: ItemCategory.dairy,
        thresholdDays: 3,
      );
      expect(result, [milk]);
    });

    test('filters by search query, case-insensitively', () {
      final result = ItemQuery.applyFilters(items, query: 'app', thresholdDays: 3);
      expect(result, [apple]);
    });

    test('filters by status', () {
      final result = ItemQuery.applyFilters(
        items,
        status: ItemStatus.expired,
        thresholdDays: 3,
        now: today,
      );
      expect(result, [pills]);
    });

    test('sorts by expiry date ascending by default', () {
      final result = ItemQuery.applyFilters(items, thresholdDays: 3);
      expect(result.map((e) => e.name), ['Painkillers', 'Milk', 'Apple']);
    });

    test('sorts by name alphabetically', () {
      final result =
      ItemQuery.applyFilters(items, sort: SortOption.name, thresholdDays: 3);
      expect(result.map((e) => e.name), ['Apple', 'Milk', 'Painkillers']);
    });

    test('sorts by date added, most recent first', () {
      final result =
      ItemQuery.applyFilters(items, sort: SortOption.dateAdded, thresholdDays: 3);
      expect(result.map((e) => e.name), ['Painkillers', 'Apple', 'Milk']);
    });

    test('combines multiple filters', () {
      final result = ItemQuery.applyFilters(
        items,
        query: 'milk',
        category: ItemCategory.dairy,
        thresholdDays: 3,
      );
      expect(result, [milk]);
    });
  });
