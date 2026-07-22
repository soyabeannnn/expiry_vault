import 'package:flutter/foundation.dart';
import '../data/settings_repository.dart';
import '../models/app_settings.dart';
import '../models/pantry_item.dart';
import '../services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({SettingsRepository? repository})
      : _repository = repository ?? SettingsRepository() {
    _settings = _repository.load();
  }

  final SettingsRepository _repository;
  late AppSettings _settings;

  int get reminderLeadDays => _settings.reminderLeadDays;
  bool get hasOnboarded => _settings.hasOnboarded;
  bool get notificationsEnabled => _settings.notificationsEnabled;

  Future<void> completeOnboarding() async {
    _settings.hasOnboarded = true;
    await _repository.save(_settings);
    notifyListeners();
  }

  Future<void> setReminderLeadDays(int days, {Iterable<PantryItem>? itemsToReschedule}) async {
    _settings.reminderLeadDays = days;
    await _repository.save(_settings);
    if (itemsToReschedule != null) {
      await NotificationService.instance.rescheduleAll(itemsToReschedule, days);
    }
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _settings.notificationsEnabled = enabled;
    await _repository.save(_settings);
    notifyListeners();
  }
}