import '../models/item_category.dart';
import '../models/item_status.dart';
import '../models/pantry_item.dart';
import '../services/item_status_service.dart';
import 'constants.dart';

class ItemQuery {
  ItemQuery._();

  static List<PantryItem> applyFilters(
      List<PantryItem> items, {
        String query = '',
        ItemCategory? category,
        ItemStatus? status,
        SortOption sort = SortOption.expiryDate,
        required int thresholdDays,
        DateTime? now,
      }) {
    final normalizedQuery = query.trim().toLowerCase();

    var result = items.where((item) {
      if (category != null && item.category != category) return false;
      if (status != null &&
          ItemStatusService.computeStatus(item.expiryDate, thresholdDays, from: now) != status) {
        return false;
      }
      if (normalizedQuery.isNotEmpty && !item.name.toLowerCase().contains(normalizedQuery)) {
        return false;
      }
      return true;
    }).toList();

    result.sort((a, b) {
      switch (sort) {
        case SortOption.expiryDate:
          return a.expiryDate.compareTo(b.expiryDate);
        case SortOption.name:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case SortOption.dateAdded:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return result;
  }

  static List<PantryItem> needingAttention(
      List<PantryItem> items, {
        required int thresholdDays,
        DateTime? now,
      }) {
    final result = items.where((item) {
      final status = ItemStatusService.computeStatus(item.expiryDate, thresholdDays, from: now);
      return status != ItemStatus.fresh;
    }).toList();
    result.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return result;
  }
}
