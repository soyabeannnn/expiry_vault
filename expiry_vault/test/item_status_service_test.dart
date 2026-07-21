import 'package:flutter_test/flutter_test.dart';
import 'package:pantry_pal/models/item_status.dart';
import 'package:pantry_pal/services/item_status_service.dart';

void main() {
  final today = DateTime(2026, 7, 11);

  group('daysUntil', () {
    test('returns 0 for an item expiring today', () {
      expect(ItemStatusService.daysUntil(DateTime(2026, 7, 11), from: today), 0);
    });

    test('returns positive count for a future date', () {
      expect(ItemStatusService.daysUntil(DateTime(2026, 7, 14), from: today), 3);
    });

    test('returns negative count for a past date', () {
      expect(ItemStatusService.daysUntil(DateTime(2026, 7, 9), from: today), -2);
    });

    test('ignores time-of-day, only compares calendar dates', () {
      final expiryLaterToday = DateTime(2026, 7, 11, 23, 59);
      expect(ItemStatusService.daysUntil(expiryLaterToday, from: today), 0);
    });
  });

  group('computeStatus', () {
    const threshold = 3;

    test('is fresh when days remaining exceeds the threshold', () {
      final status =
      ItemStatusService.computeStatus(DateTime(2026, 7, 20), threshold, from: today);
      expect(status, ItemStatus.fresh);
    });

    test('is expiring soon exactly at the threshold boundary', () {
      final status =
      ItemStatusService.computeStatus(DateTime(2026, 7, 14), threshold, from: today);
      expect(status, ItemStatus.expiringSoon);
    });

    test('is expiring soon the day just past the threshold is fresh', () {
      final status =
      ItemStatusService.computeStatus(DateTime(2026, 7, 15), threshold, from: today);
      expect(status, ItemStatus.fresh);
    });

    test('is expiring soon on the expiry day itself', () {
      final status =
      ItemStatusService.computeStatus(DateTime(2026, 7, 11), threshold, from: today);
      expect(status, ItemStatus.expiringSoon);
    });

    test('is expired the day after expiry', () {
      final status =
      ItemStatusService.computeStatus(DateTime(2026, 7, 10), threshold, from: today);
      expect(status, ItemStatus.expired);
    });

    test('is expired well in the past', () {
      final status =
      ItemStatusService.computeStatus(DateTime(2026, 1, 1), threshold, from: today);
      expect(status, ItemStatus.expired);
    });
  });
}