import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_settings.dart';
import '../models/item_category.dart';
import '../models/pantry_item.dart';

class HiveService {
  HiveService._();

  static const String itemsBoxName = 'pantry_items';
  static const String settingsBoxName = 'app_settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PantryItemAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ItemCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }

    await Hive.openBox<PantryItem>(itemsBoxName);
    await Hive.openBox<AppSettings>(settingsBoxName);
  }

  static Box<PantryItem> get itemsBox => Hive.box<PantryItem>(itemsBoxName);
  static Box<AppSettings> get settingsBox => Hive.box<AppSettings>(settingsBoxName);
}