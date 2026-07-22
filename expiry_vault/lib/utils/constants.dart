class AppConstants {
  AppConstants._();

  static const int defaultReminderLeadDays = 3;

  static const List<String> commonUnits = [
    'pcs',
    'g',
    'kg',
    'ml',
    'L',
    'pack',
    'box',
    'bottle',
    'tablet',
  ];
}

enum SortOption { expiryDate, name, dateAdded }

extension SortOptionX on SortOption {
  String get label {
    switch (this) {
      case SortOption.expiryDate:
        return 'Expiry date';
      case SortOption.name:
        return 'Name';
      case SortOption.dateAdded:
        return 'Date added';
    }
  }
}
