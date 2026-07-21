import 'package:hive/hive.dart';

import '../models/app_settings.dart';
import '../services/hive_service.dart';

class SettingsRepository {
  SettingsRepository({Box<AppSettings>? box}) : _box = box ?? HiveService.settingsBox;

  final Box<AppSettings> _box;

  AppSettings load() {
    final existing = _box.get(AppSettings.boxKey);
    if (existing != null) return existing;

    final defaults = AppSettings();
    _box.put(AppSettings.boxKey, defaults);
    return defaults;
  }

  Future<void> save(AppSettings settings) async {
    await _box.put(AppSettings.boxKey, settings);
  }
}
