import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 2)
class AppSettings extends HiveObject {
  AppSettings({
    this.reminderLeadDays = 3,
    this.hasOnboarded = false,
    this.notificationsEnabled = true,
  });

  static const String boxKey = 'app_settings';
  static const List<int> availableLeadDays = [1, 3, 7];

  @HiveField(0)
  int reminderLeadDays;

  @HiveField(1)
  bool hasOnboarded;

  @HiveField(2)
  bool notificationsEnabled;
}