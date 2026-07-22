import '../models/item_status.dart';

class ItemStatusService {
  ItemStatusService._();

  static int daysUntil(DateTime expiryDate, {DateTime? from}) {
    final today = _dateOnly(from ?? DateTime.now());
    final expiry = _dateOnly(expiryDate);
    return expiry.difference(today).inDays;
  }

  static ItemStatus computeStatus(DateTime expiryDate, int thresholdDays, {DateTime? from}) {
    final days = daysUntil(expiryDate, from: from);
    if (days < 0) return ItemStatus.expired;
    if (days <= thresholdDays) return ItemStatus.expiringSoon;
    return ItemStatus.fresh;
  }

  static DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
}
