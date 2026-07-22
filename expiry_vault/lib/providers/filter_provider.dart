import 'package:flutter/foundation.dart';
import '../models/item_category.dart';
import '../models/item_status.dart';
import '../utils/constants.dart';

class FilterProvider extends ChangeNotifier {
  String _searchQuery = '';
  ItemCategory? _categoryFilter;
  ItemStatus? _statusFilter;
  SortOption _sortOption = SortOption.expiryDate;

  String get searchQuery => _searchQuery;
  ItemCategory? get categoryFilter => _categoryFilter;
  ItemStatus? get statusFilter => _statusFilter;
  SortOption get sortOption => _sortOption;

  bool get hasActiveFilters => _categoryFilter != null || _statusFilter != null;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(ItemCategory? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setStatusFilter(ItemStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setSortOption(SortOption sort) {
    _sortOption = sort;
    notifyListeners();
  }

  void clearFilters() {
    _categoryFilter = null;
    _statusFilter = null;
    notifyListeners();
  }

  void reset() {
    _searchQuery = '';
    _categoryFilter = null;
    _statusFilter = null;
    _sortOption = SortOption.expiryDate;
    notifyListeners();
  }
}