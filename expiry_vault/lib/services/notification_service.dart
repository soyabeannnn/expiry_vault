import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../models/pantry_item.dart';

/// Wraps `flutter_local_notifications` so the rest of the app only ever
/// talks about "schedule/cancel a reminder for this item" — never touches
/// the plugin API directly.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'expiry_reminders';
  static const String _channelName = 'Expiry reminders';
  static const String _channelDescription =
      'Reminders for items that are expiring soon or have expired';

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.local);
    } catch (_) {
      // Falls back to UTC if the platform timezone can't be resolved.
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Deterministic notification id derived from the item's uuid so the same
  /// item always maps to the same id (safe to call schedule twice; it just
  /// replaces the pending notification).
  int notificationIdFor(PantryItem item) => item.id.hashCode & 0x7fffffff;

  /// Builds the notification body text for a given lead time
  String _bodyFor(PantryItem item, int leadDays) {
    if (leadDays <= 0) return '${item.name} expires today.';
    if (leadDays == 1) return '${item.name} expires tomorrow.';
    return '${item.name} expires in $leadDays days.';
  }

  /// Schedules a single reminder at 09:00 on (expiryDate - leadDays). Does
  /// nothing if that moment has already passed.
  Future<int?> scheduleForItem(PantryItem item, int leadDays) async {
    if (!_initialized) return null;

    final expiry = item.expiryDate;
    final reminderDate = DateTime(expiry.year, expiry.month, expiry.day)
        .subtract(Duration(days: leadDays));
    final scheduledAt = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9,
    );

    if (scheduledAt.isBefore(DateTime.now())) {
      return null;
    }

    final id = notificationIdFor(item);
    final tzDate = tz.TZDateTime.from(scheduledAt, tz.local);

    try {
      await _plugin.zonedSchedule(
        id,
        '${item.name} is expiring soon',
        _bodyFor(item, leadDays),
        tzDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return id;
    } catch (e) {
      debugPrint('NotificationService: failed to schedule for ${item.name}: $e');
      return null;
    }
  }

  Future<void> cancelForItem(PantryItem item) async {
    await _plugin.cancel(notificationIdFor(item));
  }

  /// Re-derives every schedule from scratch, used when the lead-time
  /// setting changes in Settings.
  Future<void> rescheduleAll(Iterable<PantryItem> items, int leadDays) async {
    for (final item in items) {
      await cancelForItem(item);
      final id = await scheduleForItem(item, leadDays);
      item.scheduledNotificationId = id;
      await item.save();
    }
  }
}
