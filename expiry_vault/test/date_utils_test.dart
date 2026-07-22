import 'package:flutter_test/flutter_test.dart';
import 'package:expiry_vault/utils/date_utils.dart';

void main() {
  final today = DateTime(2026, 7, 11);

  group('formatDate', () {
    test('formats as "d MMM yyyy"', () {
      expect(AppDateUtils.formatDate(DateTime(2026, 7, 11)), '11 Jul 2026');
    });
  });

  group('friendlyCountdown', () {
    test('says "Expires today" for same-day expiry', () {
      expect(AppDateUtils.friendlyCountdown(DateTime(2026, 7, 11), from: today), 'Expires today');
    });

    test('says "Expires tomorrow" for next-day expiry', () {
      expect(
        AppDateUtils.friendlyCountdown(DateTime(2026, 7, 12), from: today),
        'Expires tomorrow',
      );
    });

    test('says "Expires in N days" for future dates beyond tomorrow', () {
      expect(
        AppDateUtils.friendlyCountdown(DateTime(2026, 7, 16), from: today),
        'Expires in 5 days',
      );
    });

    test('says "Expired yesterday" for the day before today', () {
      expect(
        AppDateUtils.friendlyCountdown(DateTime(2026, 7, 10), from: today),
        'Expired yesterday',
      );
    });

    test('says "Expired N days ago" for older dates', () {
      expect(
        AppDateUtils.friendlyCountdown(DateTime(2026, 7, 1), from: today),
        'Expired 10 days ago',
      );
    });
  });
}