import 'package:intl/intl.dart';

import '../services/item_status_service.dart';

class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _shortDate = DateFormat('d MMM yyyy');

  static String formatDate(DateTime date) => _shortDate.format(date);

  static String friendlyCountdown(DateTime expiryDate, {DateTime? from}) {
    final days = ItemStatusService.daysUntil(expiryDate, from: from);
    if (days > 1) return 'Expires in $days days';
    if (days == 1) return 'Expires tomorrow';
    if (days == 0) return 'Expires today';
    if (days == -1) return 'Expired yesterday';
    return 'Expired ${-days} days ago';
  }
}
